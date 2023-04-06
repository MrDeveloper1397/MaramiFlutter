class Approvallist {
  int? count;
  String? ventureCd;
  String? ventureName;
  String? unitCd;
  String? plot;
  String? commCalc;
  String? dbName;

  Approvallist(
      {this.count,
      this.ventureCd,
      this.ventureName,
      this.unitCd,
      this.plot,
      this.commCalc,
      this.dbName});

  Approvallist.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    ventureCd = json['VentureCd'];
    ventureName = json['VentureName'];
    unitCd = json['UnitCd'];
    plot = json['Plot'];
    commCalc = json['CommCalc'];
    dbName = json['dbName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['VentureCd'] = this.ventureCd;
    data['VentureName'] = this.ventureName;
    data['UnitCd'] = this.unitCd;
    data['Plot'] = this.plot;
    data['CommCalc'] = this.commCalc;
    return data;
  }
}
