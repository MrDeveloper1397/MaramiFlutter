class ReservePlot {
  String? ventureCd;
  String? ventureName;
  String? sector;

  ReservePlot({this.ventureCd, this.ventureName, this.sector});

  ReservePlot.fromJson(Map<String, dynamic> json) {
    ventureCd = json['VentureCd'];
    ventureName = json['VentureName'];
    sector = json['Sector'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['VentureCd'] = this.ventureCd;
    data['VentureName'] = this.ventureName;
    data['Sector'] = this.sector;
    return data;
  }
}