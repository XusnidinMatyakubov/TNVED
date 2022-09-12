import 'dart:convert';

List<TnvedCode> tnvedCodeFromJson(String str) => List<TnvedCode>.from(json.decode(str).map((x) => TnvedCode.fromJson(x)));

String tnvedCodeToJson(List<TnvedCode> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TnvedCode<T> {
  TnvedCode({
    required this.id,
    required this.name,
    required this.unit1,
    required this.unit2,
    required this.license,
    required this.isdeleted,
    required this.startdate,
    required this.finishdate,
    required this.u1,
    required this.u2,
  });

  T id;
  T name;
  T unit1;
  T unit2;
  T license;
  T isdeleted;
  T startdate;
  T finishdate;
  T u1;
  T u2;

  factory TnvedCode.fromJson(Map<String, dynamic> json) => TnvedCode(
    id: json["id"],
    name: json["name"],
    unit1: json["unit1"],
    unit2: json["unit2"],
    license: json["license"],
    isdeleted: json["isdeleted"],
    startdate: json["startdate"],
    finishdate: json["finishdate"],
    u1: json["u1"],
    u2: json["u2"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "unit1": unit1,
    "unit2": unit2,
    "license": license,
    "isdeleted": isdeleted,
    "startdate": startdate,
    "finishdate": finishdate,
    "u1": u1,
    "u2": u2,
  };

  @override
  String toString() {
    return 'TnvedCode{id: $id, name: $name, unit1: $unit1, unit2: $unit2, license: $license, isdeleted: $isdeleted, startdate: $startdate, finishdate: $finishdate, u1: $u1, u2: $u2}';
  }
}