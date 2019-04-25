class Rmesaj{
final String mesaj;
final int gonderenid;
final int mindex;
final bool isnull;

Rmesaj({this.gonderenid,this.mesaj,this.mindex,this.isnull});

  factory Rmesaj.fromJson(Map<String,dynamic> json)
  {
    return Rmesaj(
      gonderenid: json['GonderenId'],
      mesaj: json['Mesaj'],
      mindex: json['MESAJINDEX'],
    );
  }
}