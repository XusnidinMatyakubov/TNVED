// ignore_for_file: non_constant_identifier_names

class TnvedCode<T> {
  final T id;
  final T name;
  final T unit1;
  final T unit2;
  final T license;
  final T isdeleted;
  final T startdate;
  final T finishdate;
  final T u1;
  final T u2;

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
      required this.u2
      });

  factory TnvedCode.formJson(Map<String, dynamic> json) {
    return TnvedCode(
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
  }
}
