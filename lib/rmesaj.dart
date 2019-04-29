class Rmesaj{
final String mesaj;
final int gonderenid;
final int mindex;
final bool isnull;

Rmesaj({this.gonderenid,this.mesaj,this.mindex,this.isnull});

  factory Rmesaj.fromJson(Map<String,dynamic> json)
  {
    return Rmesaj(
      gonderenid: int.parse(json['GonderenId']),
      mesaj: json['Mesaj'],
      mindex: int.parse(json['MESAJINDEX']),
      isnull: false,
    );
  }

  static List<Rmesaj> fromArray(var jsonArray)
  {
    List<Rmesaj> gelenmesajlar=List<Rmesaj>();
    for(Map<String,dynamic> json in jsonArray)
    {
      gelenmesajlar.add(Rmesaj.fromJson(json));
    }
    return gelenmesajlar;
  }
}