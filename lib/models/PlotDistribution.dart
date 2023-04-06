class PlotDistribution {
  int? total;
  String? extend;
  String? fACING;


  PlotDistribution({this.total, this.extend, this.fACING});

  PlotDistribution.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    extend = json['Extend'];
    fACING = json['FACING'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['Extend'] = this.extend;
    data['FACING'] = this.fACING;
    return data;
  }
}