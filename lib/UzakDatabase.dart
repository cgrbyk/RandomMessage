import 'package:mysql1/mysql1.dart';
import 'Database.dart';
import 'KULDATA.dart';
import 'rmesaj.dart';

class UzakDatabase {
  static var conn;
  int mindex = 0;
  UzakDatabase() {
    if (conn == null) baglan();
  }
  baglan() async {
    var settings = new ConnectionSettings(
        host: '185.210.92.181',
        port: 3306,
        user: 'gelengig_public_acces',
        password: '957g7957g7!',
        db: 'gelengig_tekrar_db');
    conn = await MySqlConnection.connect(settings);
  }

  giris(String kulmail, String kulsifre) async {
    int kulID;
    var results = await conn.query("SELECT GIRIS(?,?)", [kulmail, kulsifre]);
    for (var row in results) {
      kulID = row[0];
      print('KullId: ' + kulID.toString());
    }
    if (kulID != 10) {
      KULDATA.kulEmail = kulmail;
      KULDATA.kulId = kulID;
      await kullverisicek();
      return true;
    } else
      return false;
  }

  kullverisicek() async {
    var results = await conn.query(
        "SELECT KullaniciAdi,KullaniciSoyad FROM KULLANICI Where KullaniciId=?",
        [KULDATA.kulId]);
    for (var row in results) {
      print('KulAdı: ${row[0]}, KulSoyad:${row[1]}');
      KULDATA.kulAdi = row[0].toString();
      KULDATA.kulSoyad = row[1].toString();
    }
  }

  esles() async {
    if (KULDATA.kulEmail != null) {
      var results = await conn.query("Select ESLES(?)", [KULDATA.kulEmail]);
      for (var row in results) {
        print(row[0].toString());
        return row[0].toString();
      }
    }
  }

  eslesmeControl() async {
    if (KULDATA.kulEmail != null) {
      var results =
          await conn.query("Select ESLESMEKONTROL(?)", [KULDATA.kulId]);
      for (var row in results) {
        print(row[0].toString());
        return row[0].toString();
      }
    }
  }

  mesajGonder(String mesaj) async {
    bool mesajsonuc = await DBProvider.db.mesajKontrol(mesaj);
    if (mesajsonuc) {
      await conn.query(
          "Select MESAJAT(?,?,?)", [KULDATA.mesajid, mesaj, KULDATA.kulId]);
      return true;
    } else {
      await conn.query("Select ESLESMEBITIR(?)", [KULDATA.mesajid]);
      return false;
    }
  }

  eslesmeBitir() async {
    await conn.query("Select ESLESMEBITIR(?)", [KULDATA.mesajid]);
    return false;
  }

  mesajcek() async {
    Rmesaj rm = Rmesaj();
    var result = await conn.query(
        "SELECT Mesaj,GonderenId,MesajTarih,MESAJINDEX FROM MESAJ WHERE MesajId=? AND MESAJINDEX>?",
        [KULDATA.mesajid, mindex]);
    if (!result.isEmpty) {
      for (var row in result) {
        if (row[1] != KULDATA.kulId) {
          print(row[0].toString());
          mindex++;
          rm.mesaj = row[0];
          rm.gonderenid = row[1];
          rm.mindex = mindex;
          rm.isnull = false;
          return rm;
        }
      }
    }
    rm.isnull = true;
    return rm;
  }

  bitiskontrol() async {
    var results = await conn.query("Select BITISKONTROL(?)", [KULDATA.kulId]);
    for (var row in results) {
      print(row[0].toString());
      return row[0].toString();
    }
  }

  setmindextozero() {
    mindex = 0;
  }

  incmindex() {
    mindex++;
  }
}
