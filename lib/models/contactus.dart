class getContact {
  String? address1;
  String? names;

  getContact({required this.address1, required this.names});

  getContact.fromJson(Map<String, dynamic> json) {
    address1 = json['Address1'];
    names = json['Names'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Address1'] = this.address1;
    data['Names'] = this.names;
    return data;
  }
}