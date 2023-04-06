class NewIDCreation {
  String? status;
  String? message;
  NewUserResult? result;

  NewIDCreation({this.status, this.message, this.result});

  NewIDCreation.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    result =
    json['result'] != null ? new NewUserResult.fromJson(json['result']) : null;
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

class NewUserResult {
  NewUserdata? userdata;
  List<Cadre>? cadre;

  NewUserResult({this.userdata, this.cadre});

  NewUserResult.fromJson(Map<String, dynamic> json) {
    userdata = json['userdata'] != null
        ? new NewUserdata.fromJson(json['userdata'])
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

class NewUserdata {
  String? status;
  int? newAgentId;


  NewUserdata(
      {this.status,
        this.newAgentId,
      });

  NewUserdata.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    newAgentId = json['newAgentId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['newAgentId'] = this.newAgentId;
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