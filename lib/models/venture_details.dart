class VentureDetails {
  final String plotNum;
  final String plotArea;
  final String facing;

  VentureDetails(
      {required this.plotNum, required this.plotArea, required this.facing});

  factory VentureDetails.fromJson(Map<String, dynamic> json) {
    return VentureDetails(
      plotNum: json['plotnum'],
      plotArea: json['plotarea'],
      facing: json['facing'],
    );
  }
}
