DeviceProperties getDeviceProperties(List<String> list) {
  var map = getMap(list);
  return DeviceProperties.fromMap(map);
}

Map<String, String> getMap(List<String> list) {
  Map<String, String> myMap = {};
  list.forEach(
    (element) {
      myMap.addAll(
        {
          element.substring(0, element.indexOf(":")):
              element.substring(element.indexOf(":") + 1, element.length),
        },
      );
    },
  );
  return myMap;
}

class DeviceProperties {
  DeviceProperties({
    required this.rightBattery,
    required this.leftBattery,
    required this.rightProvisioned,
    required this.leftProvisioned,
  });
  String rightBattery = "";
  String leftBattery = "";
  String rightProvisioned = "";
  String leftProvisioned = "";

  factory DeviceProperties.fromMap(Map<String, dynamic> myMap) =>
      DeviceProperties(
        rightBattery: myMap["rightBatt"],
        leftBattery: myMap["leftBatt"],
        rightProvisioned: myMap["provisioned c"],
        leftProvisioned: myMap["provisioned s"],
      );
}
