class DayCollection {
  String? recAmount;
  int? acnumb;
  String? venturecd;
  String? ventureName;
  int? branchCd;
  String? branchName;

  DayCollection(
      {this.recAmount,
      this.acnumb,
      this.venturecd,
      this.ventureName,
      this.branchCd,
      this.branchName});

  DayCollection.fromJson(Map<String, dynamic> json) {
    recAmount = json['RecAmount'];
    acnumb = json['Acnumb'];
    venturecd = json['venturecd'];
    ventureName = json['VentureName'];
    branchCd = json['BranchCd'];
    branchName = json['BranchName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['RecAmount'] = this.recAmount;
    data['Acnumb'] = this.acnumb;
    data['venturecd'] = this.venturecd;
    data['VentureName'] = this.ventureName;
    data['BranchCd'] = this.branchCd;
    data['BranchName'] = this.branchName;
    return data;
  }
}
