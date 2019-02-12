import 'latLng.dart';

class Address
{
	Address({
		this.coordinates,

		this.osm_type,

		this.country,
        this.countryIsoCode,

		this.road,
		this.housenumber,

		this.city,
		this.postcode,
        this.suburb,
		this.state
	});

	final LatLng coordinates;

	final String osm_type;

	final String country;
    final String countryIsoCode;

	final String road;
	final String housenumber;

	final String city;
	final String postcode;
    final String suburb;
	final String state;
}
