class PlotApprovalModel {
  int? memberid;
  String? sectorCd;
  String? plotNo;
  String? plotArea;
  String? pCATEG;
  String? fACING;
  String? ratePerSq;
  String? adminFee;
  String? totalCost;
  String? devCharges;
  String? costPremium;
  String? bSP4;
  String? bsp6;
  String? others;
  String? carpusFund;
  String? compDiscount;
  String? rateCalc;
  double? spPremium;
  double? premium;
  int? paidAmount;
  double? discount;

  PlotApprovalModel(
      {this.memberid,
        this.sectorCd,
        this.plotNo,
        this.plotArea,
        this.pCATEG,
        this.fACING,
        this.ratePerSq,
        this.adminFee,
        this.totalCost,
        this.devCharges,
        this.costPremium,
        this.bSP4,
        this.bsp6,
        this.others,
        this.carpusFund,
        this.compDiscount,
        this.rateCalc,
        this.spPremium,
        this.premium,
        this.paidAmount,
        this.discount});
  // Variable name==null? 0.00 : variable name
  PlotApprovalModel.fromJson(Map<String, dynamic> json) {
    memberid = json['Memberid'] == null ? null :  json['Memberid'];
    sectorCd = json['SectorCd']== null ? null :  json['SectorCd'];
    plotNo = json['PlotNo']== null ? null :  json['PlotNo'];
    plotArea = json['PlotArea']== null ? null :  json['PlotArea'];
    pCATEG = json['PCATEG']== null ? null :  json['PCATEG'];
    fACING = json['FACING']== null ? null :  json['FACING'];
    ratePerSq = json['RatePerSq']== null ? null :  json['RatePerSq'];
    adminFee = json['AdminFee']== null ? null :  json['AdminFee'];
    totalCost = json['TotalCost']== null ? null :  json['TotalCost'];
    devCharges = json['DevCharges']== null ? null :  json['DevCharges'];
    costPremium = json['costPremium']== null ? null :  json['costPremium'];
    bSP4 = json['BSP4']== null ? null :  json['BSP4'];
    bsp6 = json['bsp6']== null ? null :  json['bsp6'];
    others = json['Others']== null ? null :  json['Others'];
    carpusFund = json['CarpusFund']== null ? null :  json['CarpusFund'];
    compDiscount = json['CompDiscount']== null ? null :  json['CompDiscount'];
    rateCalc = json['Rate_Calc']== null ? null :  json['Rate_Calc'];
    spPremium = parseDouble(json['spPremium'])== null ? null :  parseDouble(json['spPremium']);
    premium = parseDouble(json['Premium'])== null ? null :  parseDouble(json['Premium']);
    paidAmount = json['PaidAmount']?.toInt() == null ? null :  json['PaidAmount']?.toInt();
    discount = json['Discount']== null ? null :  parseDouble(json['Discount']);
  }
  double? parseDouble(dynamic value) {
    try {
      if (value is String) {
        return double.parse(value);
      } else if (value is double) {
        return value;
      } else {
        return 0.0;
      }
    } catch (e) {
      // return null if double.parse fails
      return null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Memberid'] = this.memberid;
    data['SectorCd'] = this.sectorCd;
    data['PlotNo'] = this.plotNo;
    data['PlotArea'] = this.plotArea;
    data['PCATEG'] = this.pCATEG;
    data['FACING'] = this.fACING;
    data['RatePerSq'] = this.ratePerSq;
    data['AdminFee'] = this.adminFee;
    data['TotalCost'] = this.totalCost;
    data['DevCharges'] = this.devCharges;
    data['costPremium'] = this.costPremium;
    data['BSP4'] = this.bSP4;
    data['bsp6'] = this.bsp6;
    data['Others'] = this.others;
    data['CarpusFund'] = this.carpusFund;
    data['CompDiscount'] = this.compDiscount;
    data['Rate_Calc'] = this.rateCalc;
    data['spPremium'] = this.spPremium;
    data['Premium'] = this.premium;
    data['PaidAmount'] = this.paidAmount;
    data['Discount'] = this.discount;
    return data;
  }
}
