class EmpAssocSales {
  String? status;
  String? message;
  Result? result;

  EmpAssocSales({this.status, this.message, this.result});

  EmpAssocSales.fromJson(Map<String, dynamic> json) {
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
  List<CadreSalesCount>? cadreSalesCount;

  Result({this.cadreSalesCount});

  Result.fromJson(Map<String, dynamic> json) {
    if (json['CadreSalesCount'] != null) {
      cadreSalesCount = <CadreSalesCount>[];
      json['CadreSalesCount'].forEach((v) {
        cadreSalesCount!.add(new CadreSalesCount.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.cadreSalesCount != null) {
      data['CadreSalesCount'] =
          this.cadreSalesCount!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CadreSalesCount {
  int? count;
  String? cadre;
  List<Childs>? childs;

  CadreSalesCount({this.count, this.cadre, this.childs});

  CadreSalesCount.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    cadre = json['Cadre'];
    if (json['childs'] != null) {
      childs = <Childs>[];
      json['childs'].forEach((v) {
        childs!.add(new Childs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['Cadre'] = this.cadre;
    if (this.childs != null) {
      data['childs'] = this.childs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Childs {
  String? agentCd;
  String? plotNo;
  String? plotArea;
  int? memberId;
  String? name;
  String? sector;
  String? associateName;

  Childs(
      {this.agentCd,
        this.plotNo,
        this.plotArea,
        this.memberId,
        this.name,
        this.sector,
        this.associateName});

  Childs.fromJson(Map<String, dynamic> json) {
    agentCd = json['AgentCd'];
    plotNo = json['PlotNo'];
    plotArea = json['PlotArea'];
    memberId = json['MemberId'];
    name = json['Name'];
    sector = json['Sector'];
    associateName = json['AssociateName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['AgentCd'] = this.agentCd;
    data['PlotNo'] = this.plotNo;
    data['PlotArea'] = this.plotArea;
    data['MemberId'] = this.memberId;
    data['Name'] = this.name;
    data['Sector'] = this.sector;
    data['AssociateName'] = this.associateName;
    return data;
  }
}