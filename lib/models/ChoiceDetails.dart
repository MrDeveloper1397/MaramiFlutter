class ChoiceDetails {
  String? plotNo;
  String? plotArea;

  ChoiceDetails({this.plotNo, this.plotArea});

  ChoiceDetails.fromJson(Map<String, dynamic> json) {
    plotNo = json['PlotNo'];
    plotArea = json['PLOTAREA'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PlotNo'] = this.plotNo;
    data['PLOTAREA'] = this.plotArea;
    return data;
  }
}
