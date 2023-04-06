class TotalCommission {
  int? index;
  String? agentCode;
  String? agentName;
  String? agentLevel;
  String? agentCadre;
  String? commission;
  String? totalAmo;
  String? discount;
  String? grossPayable;

  TotalCommission(
      {this.index,
        this.agentCode,
        this.agentName,
        this.agentLevel,
        this.agentCadre,
        this.commission,
        this.totalAmo,
        this.discount,
        this.grossPayable});

  TotalCommission.fromJson(Map<String, dynamic> json) {
    index = json['Index'];
    agentCode = json['AgentCode'];
    agentName = json['AgentName'];
    agentLevel = json['AgentLevel'];
    agentCadre = json['AgentCadre'];
    commission = json['Commission'];
    totalAmo = json['Total_Amo'];
    discount = json['Discount'];
    grossPayable = json['GrossPayable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Index'] = this.index;
    data['AgentCode'] = this.agentCode;
    data['AgentName'] = this.agentName;
    data['AgentLevel'] = this.agentLevel;
    data['AgentCadre'] = this.agentCadre;
    data['Commission'] = this.commission;
    data['Total_Amo'] = this.totalAmo;
    data['Discount'] = this.discount;
    data['GrossPayable'] = this.grossPayable;
    return data;
  }




}