import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'ClientModel.dart';
import 'package:sqflite/sqflite.dart';
import 'KULDATA.dart';
import 'kontrolDonus.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  List kelimeler = [
    'ki',
    'da',
    'de',
    've',
    'veya',
    'fakat',
    'ama',
    'ancak',
    'mi',
    'misin',
    'midir',
    'mı',
    'mısın',
    'mıdır',
    'mu',
    'musun',
    'mudur',
    'mü',
    'müsün',
    'müdür',
    'gibi',
    'kadar',
    'ile',
    'için',
    'ya',
    'yada',
    "Ne",
    "Neye",
    "Neyden",
    "Nereye",
    "Nereden",
    "Nerede",
    "Kim",
    "Kime",
    "Kimden",
    "Niye",
    "Neden",
    "Bir",
    "İki",
    "Üç",
    "Dört",
    "Beş",
    "Altı",
    "Yedi",
    "Sekiz",
    "Dokuz",
    "On",
    "Ben",
    "Sen",
    "O",
    "Biz",
    "Siz",
    "Onlar",
    "Bana",
    "Beni",
    "Benden",
    "Benim",
    "Sana",
    "Senden",
    "Senin",
    "Ona",
    "Onun",
    "Ondan",
    "Biz",
    "Bize",
    "Bizden",
    "Size",
    "Siz",
    "Sizden",
    "Onlar",
    "Onlara",
    "Onları",
    "Sizi",
    "Beni",
    "Bizi",
    "Seni",
    "Onları",
    "Eğer",
    "Bile",
    "Dahi",
    "Bazı"
  ];

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Mesajlar.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Client ("
          "id INTEGER PRIMARY KEY,"
          "Kelime TEXT,"
          "gonderenid INTEGER"
          ")");
    });
  }

  newClient(Client newClient) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Client");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Client (id,Kelime,gonderenid)"
        " VALUES (?,?,?)",
        [id, newClient.kelime, newClient.gonderenid]);
    return raw;
  }

  getClient(String kelime) async {
    final db = await database;
    var res =
        await db.query("Client", where: "Kelime = ?", whereArgs: [kelime]);
    return res.isNotEmpty ? Client.fromMap(res.first) : null;
  }

  Future<List<Client>> getAllClients() async {
    final db = await database;
    var res = await db.query("Client");
    List<Client> list =
        res.isNotEmpty ? res.map((c) => Client.fromMap(c)).toList() : [];
    return list;
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete FROM Client");
  }

  deleteFromIndex(int index) async {
    final db = await database;
    db.rawDelete("Delete FROM Client WHERE id=" + index.toString());
  }

  Future<KontrolDonus> mesajKontrol(String mesaj) async {
    List mesajKelimeleri = mesaj.split(" ");
    List silinecekler = new List<String>();
    for (String klm in mesajKelimeleri) {
      for (int i = 0; i < kelimeler.length; i++) {
        if (klm == kelimeler[i]) silinecekler.add(klm);
      }
    }

    for (String silinecek in silinecekler) {
      mesajKelimeleri.remove(silinecek);
    }

    List tumkelimeler = await getAllClients();
    for (Client c in tumkelimeler) {
      List<String> ayrilmis = c.kelime.split(" ");
      for (String ak in ayrilmis) {
        for (String mk in mesajKelimeleri)
          if (ak == mk && c.gonderenid == KULDATA.kulId) {
            print("ayni kelime kullanımı");
            return KontrolDonus(issame: true,mesaj: c.kelime,kelime: ak);
          }
      }
    }
    print("ayni kelime kullanılmamış");
    return KontrolDonus(issame: false);
  }
}
