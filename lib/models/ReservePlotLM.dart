class ReservePlotLM {
  String? ventureCd;
  String? ventureName;
  String? sector;
  String? dbname;


  ReservePlotLM({this.ventureCd, this.ventureName, this.sector,this.dbname});

  ReservePlotLM.fromJson(Map<String, dynamic> json) {
    ventureCd = json['VentureCd'];
    ventureName = json['VentureName'];
    sector = json['Sector'];
    dbname = json['dbname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['VentureCd'] = this.ventureCd;
    data['VentureName'] = this.ventureName;
    data['Sector'] = this.sector;
    data['dbname'] = this.dbname;
    return data;
  }
}