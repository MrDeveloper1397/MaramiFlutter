class AvailablePlots {
  int? total;
  String? extend;
  String? ventureCd;
  String? sectorCd;
  String? ventureName;
  String? status;
  String? dbname;

  AvailablePlots(
      {this.total,
      this.extend,
      this.ventureCd,
      this.sectorCd,
      this.ventureName,
      this.status,
      this.dbname});

  AvailablePlots.fromJson(Map<String, dynamic> json) {
    total = json['Total'];
    extend = json['Extend'];
    ventureCd = json['VentureCd'];
    sectorCd = json['SectorCd'];
    ventureName = json['VentureName'];
    status = json['Status'];
    dbname = json['dbname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Total'] = this.total;
    data['Extend'] = this.extend;
    data['VentureCd'] = this.ventureCd;
    data['SectorCd'] = this.sectorCd;
    data['VentureName'] = this.ventureName;
    data['Status'] = this.status;
    data['dbname'] = this.dbname;
    return data;
  }
} // TODO Implement this library.
