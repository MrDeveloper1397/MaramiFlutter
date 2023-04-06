class NewAgentDetails {
  String? status;
  String? message;
  UserResult? result;

  NewAgentDetails({this.status, this.message, this.result});

  NewAgentDetails.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    result =
    json['result'] != null ? new UserResult.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class UserResult {
  Userdata? userdata;
  List<Cadre>? cadre;

  UserResult({this.userdata, this.cadre});

  UserResult.fromJson(Map<String, dynamic> json) {
    userdata = json['userdata'] != null
        ? new Userdata.fromJson(json['userdata'])
        : null;
    if (json['cadre'] != null) {
      cadre = <Cadre>[];
      json['cadre'].forEach((v) {
        cadre!.add(new Cadre.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userdata != null) {
      data['userdata'] = this.userdata!.toJson();
    }
    if (this.cadre != null) {
      data['cadre'] = this.cadre!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Userdata {
  bool? status;
  String? agentId;
  bool? isCadre;
  bool? isPan;
  bool? isAadhar;
  bool? isWorkingUnder;
  String? seniourId;

  Userdata(
      {this.status,
        this.agentId,
        this.isCadre,
        this.isPan,
        this.isAadhar,
        this.isWorkingUnder,
        this.seniourId});

  Userdata.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    agentId = json['AgentId'];
    isCadre = json['isCadre'];
    isPan = json['isPan'];
    isAadhar = json['isAadhar'];
    isWorkingUnder = json['isWorkingUnder'];
    seniourId = json['seniourId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['AgentId'] = this.agentId;
    data['isCadre'] = this.isCadre;
    data['isPan'] = this.isPan;
    data['isAadhar'] = this.isAadhar;
    data['isWorkingUnder'] = this.isWorkingUnder;
    data['seniourId'] = this.seniourId;
    return data;
  }
}

class Cadre {
  String? agentMasterCd;
  String? agentName;
  String? agentCadre;
  String? workingUnder;
  String? mobile;
  String? superExecutive;
  String? panNo;
  int? rowsCount;
  String? cDT;
  Null? loginUser;
  Null? loginUserName;
  String? companyName;
  String? address;

  Cadre(
      {this.agentMasterCd,
        this.agentName,
        this.agentCadre,
        this.workingUnder,
        this.mobile,
        this.superExecutive,
        this.panNo,
        this.rowsCount,
        this.cDT,
        this.loginUser,
        this.loginUserName,
        this.companyName,
        this.address});

  Cadre.fromJson(Map<String, dynamic> json) {
    agentMasterCd = json['AgentMasterCd'];
    agentName = json['AgentName'];
    agentCadre = json['AgentCadre'];
    workingUnder = json['WorkingUnder'];
    mobile = json['Mobile'];
    superExecutive = json['SuperExecutive'];
    panNo = json['PanNo'];
    rowsCount = json['RowsCount'];
    cDT = json['CDT'];
    loginUser = json['LoginUser'];
    loginUserName = json['LoginUserName'];
    companyName = json['CompanyName'];
    address = json['Address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AgentMasterCd'] = this.agentMasterCd;
    data['AgentName'] = this.agentName;
    data['AgentCadre'] = this.agentCadre;
    data['WorkingUnder'] = this.workingUnder;
    data['Mobile'] = this.mobile;
    data['SuperExecutive'] = this.superExecutive;
    data['PanNo'] = this.panNo;
    data['RowsCount'] = this.rowsCount;
    data['CDT'] = this.cDT;
    data['LoginUser'] = this.loginUser;
    data['LoginUserName'] = this.loginUserName;
    data['CompanyName'] = this.companyName;
    data['Address'] = this.address;
    return data;
  }
}