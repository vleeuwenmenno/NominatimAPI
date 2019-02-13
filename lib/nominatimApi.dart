library NominatimAPI;

import 'dart:core';
import 'dart:io';
import 'dart:convert';

import 'address.dart';
import 'latLng.dart';

import 'package:http/http.dart' as http;

class NominatimAPI
{
    //Public vars
	final String host;

    final bool allowInsecure;

    final Duration cooldown;

    //Public vars

    /// Private vars
	DateTime _lastRequest;

    /// Private vars

    /// Constructor
    ///
    /// [host] is the host for requesting resolvers to
    /// [cooldown] is optional and is used to prevent overflowing the server with requests
    /// [allowInsecure] enables you to resolve to non-https hosts (Not recommended)
	NominatimAPI({this.host = "https://nominatim.openstreetmap.org", this.allowInsecure = false, this.cooldown = const Duration(seconds: 1)})
	{
        /// Set the initial last request to 1 second ago as that's the default cooldown time
		_lastRequest = DateTime.now().subtract(this.cooldown);
	}

    /// Resolve a [query] to the [host] specified in this class
    ///
    /// Returns List of addresses if successful (If not returns [null])
    ///
    /// [query] defines the address we are looking for
    /// [verbose] is for outputting debug data
 	Future<List<Address>> resolve({String query, bool verbose = false}) async
	{
        /// Check if we are running this request securely
        if (!host.startsWith("https://") && !allowInsecure)
        {
            print("WARNING: Using http hosts is not allowed (Override this using `allowInsecure: true`)");
            return null;
        }

        /// Make sure we are allowed to do the request
		if (DateTime.now().millisecondsSinceEpoch - _lastRequest.millisecondsSinceEpoch > cooldown.inMilliseconds)
		{
			_lastRequest = DateTime.now();

			dynamic json;
			List<Address> aList = new List<Address>();
            String uri = "${host}/search/${query}?format=jsonv2&addressdetails=1";

			print("Resolving query '${query}' using get request => '${uri}'");

			http.Response s = await _fetchPost(uri);

			if (verbose)
			{
				print("JSON>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
				print(s.body);
				print("JSON^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^");
			}

			try
			{
				json = jsonDecode(s.body);
			}
			catch (e)
			{
				print("WARNING: Failed to parse photon json output.");
				return null;
			}

			if (json != null)
			{
				for (dynamic map in json)
				{
					Address a;

					double lat = double.parse(map['lat']);
					double lng = double.parse(map['lon']);

					LatLng latLng = new LatLng(lat, lng);

                    String osm_type = map['osm_type'];

                    String country = map['address']['country'];
                    String countryIsoCode = map['address']['country_code'];

                    String road = map['address']['road'];
                    String housenumber = map['address']['house_number'];

                    String city;

                    if (map['address']['city'] != null)
                        city = map['address']['city'];
                    else if (map['address']['town'] != null)
                        city = map['address']['town'];
                    else if (map['address']['village'] != null)
                        city = map['address']['village'];

                    String postcode = map['address']['postcode'];
                    String suburb = map['address']['suburb'];
                    String state = map['address']['state'];

                    if (housenumber == null)
                        housenumber = "";

                    if (road == null)
                        road = "";

					a = new Address(
						osm_type: osm_type,

						country: country,
                        countryIsoCode: countryIsoCode,

                        road: road,
						housenumber: housenumber,

						city: city,
						postcode: postcode,
                        suburb: suburb,
						state: state,

						coordinates: latLng
					);

					aList.add(a);
				}

				print("Resolved query with ${aList.length} entries");

				return aList;
			}
		}
		else
			print("WARNING: Cooldown, your latest request was less than the cooldown duration. (${DateTime.now().millisecondsSinceEpoch - _lastRequest.millisecondsSinceEpoch}/${cooldown.inMilliseconds}ms)");

		return null;
	}

    /// Fetch data with GET request [url]
    ///
    /// [url] is the actual requested path to the remote server
	Future<http.Response> _fetchPost(String url)
    {
		return http.get(url);
	}
}
