
class LoadDashBoard {
  String? upcomingProject;
  String? projectTitle;
  String? pjctId;
  String? sECTOR;
  String? title;
  String? context;
  String? lINK;
  String? enqyLink;
  int? alloCount;
  int? avlCount;
  int? mortCount;
  int? regsCount;
  int? reseCount;
  int? totcount;
  String? facing;

  LoadDashBoard(
      {this.upcomingProject,
      this.projectTitle,
      this.pjctId,
      this.sECTOR,
      this.title,
      this.context,
      this.lINK,
      this.enqyLink,
      this.alloCount,
      this.avlCount,
      this.mortCount,
      this.regsCount,
      this.reseCount,
      this.totcount,
      this.facing});

  LoadDashBoard.fromJson(Map<String, dynamic> json) {
    upcomingProject = json['UpcomingProject'];
    projectTitle = json['projectTitle'];
    pjctId = json['PjctId'];
    sECTOR = json['SECTOR'];
    title = json['Title'];
    context = json['Context'];
    lINK = json['LINK'];
    enqyLink = json['EnqyLink'];
    alloCount = json['allo_count'];
    avlCount = json['avl_count'];
    mortCount = json['mort_count'];
    regsCount = json['regs_count'];
    reseCount = json['rese_count'];
    totcount = json['totcount'];
    facing = json['facing'];
  }

  Map<String, dynamic> toJson() {

    final Map<String, dynamic> data = Map<String, dynamic>();
    data['UpcomingProject'] = this.upcomingProject;
    data['projectTitle'] = this.projectTitle;
    data['PjctId'] = this.pjctId;
    data['SECTOR'] = this.sECTOR;
    data['Title'] = this.title;
    data['Context'] = this.context;
    data['LINK'] = this.lINK;
    data['EnqyLink'] = this.enqyLink;
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
