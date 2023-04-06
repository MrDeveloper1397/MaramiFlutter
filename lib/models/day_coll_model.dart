class DayCollectionModel {
  String? bookType;
  int? memberReceiptsId = 0;
  String? cheqDDno;
  String? cheqdate;
  String? bankName;
  String? receiptDate;
  String? postingDate;
  int? passBook = 0;
  String? applName;
  String? recAmount;
  String? discount;

  DayCollectionModel(
      {this.bookType,
      this.memberReceiptsId,
      this.cheqDDno,
      this.cheqdate,
      this.bankName,
      this.receiptDate,
      this.postingDate,
      this.passBook,
      this.applName,
      this.recAmount,
      this.discount});

  DayCollectionModel.fromJson(Map<String, dynamic> json) {
    bookType = json['BookType'];
    memberReceiptsId = json['MemberReceiptsId'];
    cheqDDno = json['CheqDDno'];
    cheqdate = json['cheqdate'];
    bankName = json['BankName'];
    receiptDate = json['receiptDate'];
    postingDate = json['PostingDate'];
    passBook = json['PassBook'];
    applName = json['ApplName'];
    recAmount = json['RecAmount'];
    discount = json['Discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BookType'] = this.bookType;
    data['MemberReceiptsId'] = this.memberReceiptsId;
    data['CheqDDno'] = this.cheqDDno;
    data['cheqdate'] = this.cheqdate;
    data['BankName'] = this.bankName;
    data['receiptDate'] = this.receiptDate;
    data['PostingDate'] = this.postingDate;
    data['PassBook'] = this.passBook;
    data['ApplName'] = this.applName;
    data['RecAmount'] = this.recAmount;
    data['Discount'] = this.discount;
    return data;
  }
}
