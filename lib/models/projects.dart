

// ignore_for_file: unnecessary_question_mark, duplicate_ignore

class Projects {
  String? vENTUREID;
  String? lINK;
  String? iMAGE;
  String? sECTORS;
  String? tITLE;
  String? enqyLink;
  // ignore: unnecessary_question_mark
  String? longitude;
  String? latitude;
  Null? brochuer;
  int? alloCount;
  int? avlCount;
  int? mortCount;
  int? regsCount;
  int? reseCount;
  int? totcount;
  String? facing;

  Projects(
      {this.vENTUREID,
        this.lINK,
        this.iMAGE,
        this.sECTORS,
        this.tITLE,
        this.enqyLink,
        this.longitude,
        this.latitude,
        this.brochuer,
        this.alloCount,
        this.avlCount,
        this.mortCount,
        this.regsCount,
        this.reseCount,
        this.totcount,
        this.facing});

  Projects.fromJson(Map<String, dynamic> json) {
    vENTUREID = json['VENTUREID'];
    lINK = json['LINK'];
    iMAGE = json['IMAGE'];
    sECTORS = json['SECTORS'];
    tITLE = json['TITLE'];
    enqyLink = json['EnqyLink'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    brochuer = json['Brochuer'];
    alloCount = json['allo_count'];
    avlCount = json['avl_count'];
    mortCount = json['mort_count'];
    regsCount = json['regs_count'];
    reseCount = json['rese_count'];
    totcount = json['totcount'];
    facing = json['facing'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['VENTUREID'] = this.vENTUREID;
    data['LINK'] = this.lINK;
    data['IMAGE'] = this.iMAGE;
    data['SECTORS'] = this.sECTORS;
    data['TITLE'] = this.tITLE;
    data['EnqyLink'] = this.enqyLink;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['Brochuer'] = this.brochuer;
    data['allo_count'] = this.alloCount;
    data['avl_count'] = this.avlCount;
    data['mort_count'] = this.mortCount;
    data['regs_count'] = this.regsCount;
    data['rese_count'] = this.reseCount;
    data['totcount'] = this.totcount;
    data['facing'] = this.facing;
    return data;
  }
}