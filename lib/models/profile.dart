class Profile {
  String? status;
  String? message;
  ProfileModelResult ? result;

  Profile({
    this.status,
    this.message,
    this.result,
  });
  Profile.fromJson(Map<String, dynamic> json) {
    status = json['status']?.toString();
    message = json['message']?.toString();
    result = (json['result'] != null) ? ProfileModelResult.fromJson(json['result']) : null;
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class ProfileModelResult {
  String? id;
  String? name;
  String? image;
  String? mobile;
  String? email;
  String? cadre;
  String? joiningdate;
  String? address;
  String? pancard;
  String? aadhar;

  ProfileModelResult({
    this.id,
    this.name,
    this.image,
    this.mobile,
    this.email,
    this.cadre,
    this.joiningdate,
    this.address,
    this.pancard,
    this.aadhar,
  });
  ProfileModelResult.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    name = json['name']?.toString();
    image = json['image']?.toString();
    mobile = json['mobile']?.toString();
    email = json['email']?.toString();
    cadre = json['cadre']?.toString();
    joiningdate = json['joiningdate']?.toString();
    address = json['address']?.toString();
    pancard = json['pancard']?.toString();
    aadhar = json['aadhar']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data1 = <String, dynamic>{};
    data1['id'] = id;
    data1['name'] = name;
    data1['image'] = image;
    data1['mobile'] = mobile;
    data1['email'] = email;
    data1['cadre'] = cadre;
    data1['joiningdate'] = joiningdate;
    data1['address'] = address;
    data1['pancard'] = pancard;
    data1['aadhar'] = aadhar;
    return data1;
  }
}




