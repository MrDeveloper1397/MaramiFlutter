class DayPaymentModel {
  int? vouchno;
  int? vcode;
  String? paymentDate;
  String? agentCode;
  String? agentName;
  String? amount;
  String? cheqDDno;
  String? cheqDate;

  DayPaymentModel(
      {this.vouchno,
      this.vcode,
      this.paymentDate,
      this.agentCode,
      this.agentName,
      this.amount,
      this.cheqDDno,
      this.cheqDate});

  DayPaymentModel.fromJson(Map<String, dynamic> json) {
    vouchno = json['Vouchno'] as int;
    vcode = json['Vcode'] as int;
    paymentDate = json['PaymentDate'];
    agentCode = json['AgentCode'] as String;
    agentName = json['AgentName'];
    amount = json['Amount'];
    cheqDDno = json['CheqDDno'];
    cheqDate = json['CheqDate'];
  }
}
