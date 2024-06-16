import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  final serverUrl = "http://localhost:8080/api/rest";
  final adminSecret = "myadminsecretkey";

  // GET FACILITIES
  var url = Uri.parse("$serverUrl/facilities");
  http.get(
    url,
    headers: {"x-hasura-admin-secret": adminSecret},
  ).then((response) {
    var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
    if (decodedResponse.containsKey('facilities')) {
      for (var facility in decodedResponse['facilities']) {
        print(
            "--> ${facility['id']} ${facility['name']} ${facility['address']}");
      }
    } else {
      print("Error");
    }
  }).onError((error, stackTrace) {
    print(error);
  });

  // POST ACCESS LOG FOR A USER
  var dt = DateTime.now();
  String isoDate = dt.toIso8601String();

  var data = {
    "user_id": "e5f0ba2a-53cb-43ec-a8c9-a1d01834268e",
    "facility_id": 130,
    "timestamp": isoDate,
    "type": "IN",
    "temperature": "36.5",
  };

  url = Uri.parse("$serverUrl/access_log");
  http
      .post(
    url,
    headers: {"x-hasura-admin-secret": adminSecret},
    body: json.encode(data),
  )
      .then((response) {
    var decodedResponse = json.decode(utf8.decode(response.bodyBytes)) as Map;
    print(decodedResponse);
  }).onError((error, stackTrace) {
    print(error);
  });
}
