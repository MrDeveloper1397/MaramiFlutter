class ApprovalData {
  int? memberId;
  String? applicantName;
  String? dateJoin;
  String? plotApproval;
  String? plotCostApproval;
  String? commissionApproval;
  String? discountApproval;
  String? dbName;

  ApprovalData(
      {this.memberId,
      this.applicantName,
      this.dateJoin,
      this.plotApproval,
      this.plotCostApproval,
      this.commissionApproval,
      this.discountApproval,
      this.dbName});

  ApprovalData.fromJson(Map<String, dynamic> json) {
    memberId = json['MemberId'];
    applicantName = json['ApplicantName'];
    dateJoin = json['DateJoin'];
    plotApproval = json['PlotApproval'];
    plotCostApproval = json['PlotCostApproval'];
    commissionApproval = json['CommissionApproval'];
    discountApproval = json['DiscountApproval'];
    dbName = json['dbName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MemberId'] = this.memberId;
    data['ApplicantName'] = this.applicantName;
    data['DateJoin'] = this.dateJoin;
    data['PlotApproval'] = this.plotApproval;
    data['PlotCostApproval'] = this.plotCostApproval;
    data['CommissionApproval'] = this.commissionApproval;
    data['DiscountApproval'] = this.discountApproval;
    return data;
  }
}
