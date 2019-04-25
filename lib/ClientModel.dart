import 'dart:convert';

Client clientFromJson(String str) {
  final jsonData = json.decode(str);
  return Client.fromMap(jsonData);
}

String clientToJson(Client data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Client {
  int index;
  String kelime;
  int gonderenid;

  Client({
    this.index,
    this.kelime,
    this.gonderenid,
  });

  factory Client.fromMap(Map<String, dynamic> json) => new Client(
        index: json["id"],
        kelime: json["Kelime"],
        gonderenid: json["gonderenid"],
      );

  Map<String, dynamic> toMap() => {
        "id": index,
        "Kelime": kelime,
        "gonderenid": gonderenid,
      };
}
