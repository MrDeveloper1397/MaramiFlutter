class CollectionData {
  int bookscount = 0;
  int paymentTotal = 0;

  CollectionData({required this.bookscount, required this.paymentTotal});

  CollectionData.fromJson(Map<String, dynamic> json) {
    bookscount = json['bookscount'];
    paymentTotal = json['PaymentTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookscount'] = this.bookscount;
    data['PaymentTotal'] = this.paymentTotal;
    return data;
  }
}
