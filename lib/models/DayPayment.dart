class DayPayment {
  String? total;
  String? vENTURECD;
  String? userType;
  String? accType;

  DayPayment({this.total, this.vENTURECD, this.userType, this.accType});

  DayPayment.fromJson(Map<String, dynamic> json) {
    total = json['Total'];
    vENTURECD = json['VENTURECD'];
    userType = json['user_type'];
    accType = json['acc_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Total'] = this.total;
    data['VENTURECD'] = this.vENTURECD;
    data['user_type'] = this.userType;
    data['acc_type'] = this.accType;
    return data;
  }
}
