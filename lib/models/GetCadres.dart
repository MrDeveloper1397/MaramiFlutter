class CadreList {
  String? status;
  String? message;
  Result? result;

  CadreList({this.status, this.message, this.result});

  CadreList.fromJson(Map<String, dynamic> json) {
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
  String? status;
  List<Cadrelist>? cadrelist;

  Result({this.status, this.cadrelist});

  Result.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['cadrelist'] != null) {
      cadrelist = <Cadrelist>[];
      json['cadrelist'].forEach((v) {
        cadrelist!.add(new Cadrelist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.cadrelist != null) {
      data['cadrelist'] = this.cadrelist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cadrelist {
  String? agentCadre;

  Cadrelist({this.agentCadre});

  Cadrelist.fromJson(Map<String, dynamic> json) {
    agentCadre = json['AgentCadre'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AgentCadre'] = this.agentCadre;
    return data;
  }
}
