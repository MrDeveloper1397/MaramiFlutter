class EmpAssocDownline {
  String? status;
  String? message;
  Result? result;

  EmpAssocDownline({this.status, this.message, this.result});

  EmpAssocDownline.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    result =
        json['result'] != null ? new Result.fromJson(json['result']) : null;
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

class Result {
  List<AssocaitiveTree>? assocaitiveTree;

  Result({this.assocaitiveTree});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['AssocaitiveTree'] != null) {
      assocaitiveTree = <AssocaitiveTree>[];
      json['AssocaitiveTree'].forEach((v) {
        assocaitiveTree!.add(new AssocaitiveTree.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.assocaitiveTree != null) {
      data['AssocaitiveTree'] =
          this.assocaitiveTree!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AssocaitiveTree {
  int? associatescount;
  String? carde;
  List<Childs>? childs;

  AssocaitiveTree({this.associatescount, this.carde, this.childs});

  AssocaitiveTree.fromJson(Map<String, dynamic> json) {
    associatescount = json['Associatescount'];
    carde = json['Carde'];
    if (json['childs'] != null) {
      childs = <Childs>[];
      json['childs'].forEach((v) {
        childs!.add(new Childs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Associatescount'] = this.associatescount;
    data['Carde'] = this.carde;
    if (this.childs != null) {
      data['childs'] = this.childs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Childs {
  String? agentCd;
  String? agentName;
  String? agentCarde;
  String? workUnder;
  String? panNo;
  String? mobile;

  Childs(
      {this.agentCd,
      this.agentName,
      this.agentCarde,
      this.workUnder,
      this.panNo,
      this.mobile});

  Childs.fromJson(Map<String, dynamic> json) {
    agentCd = json['AgentCd'];
    agentName = json['AgentName'];
    agentCarde = json['AgentCarde'];
    workUnder = json['WorkUnder'];
    panNo = json['PanNo'];
    mobile = json['Mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AgentCd'] = this.agentCd;
    data['AgentName'] = this.agentName;
    data['AgentCarde'] = this.agentCarde;
    data['WorkUnder'] = this.workUnder;
    data['PanNo'] = this.panNo;
    data['Mobile'] = this.mobile;
    return data;
  }
}
