class ChoiceDetailsLM {
  String? plotNo;
  String? plotArea;

  ChoiceDetailsLM({this.plotNo, this.plotArea});

  ChoiceDetailsLM.fromJson(Map<String, dynamic> json) {
    plotNo = json['plotno'];
    plotArea = json['PLOTAREA'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['plotno'] = this.plotNo;
    data['PLOTAREA'] = this.plotArea;
    return data;
  }
}
