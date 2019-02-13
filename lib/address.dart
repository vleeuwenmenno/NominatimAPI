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

    static Address findAddress(String query, List<Address> list)
    {
        for(Address a in list)
        {
            if (query == "${a.road} ${a.housenumber}, ${a.city}")
                return a;
        }

        return null;
    }

    static List<String> toListString(String query, List<Address> list)
    {
        List<String> l = [];
        for(Address a in list)
        {
            l.add("${a.road} ${a.housenumber}, ${a.city}");
        }

        return l;
    }

    /// Public vars
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

    /// Public vars ^^^
}
