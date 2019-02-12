import '../lib/nominatimApi.dart';
import '../lib/address.dart';

void main(List<String> args) async
{
	NominatimAPI api = new NominatimAPI();
	List<Address> addresses = await api.resolve(query: "Herengracht 613, Amsterdam");

	print("Resolve multi output: ");
	for (Address a in addresses)
	{
		print("${a.road} ${a.housenumber}, ${a.city} ${a.postcode}");
	}
}
