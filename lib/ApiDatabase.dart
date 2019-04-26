import 'package:http/http.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'KULDATA.dart';
import 'Database.dart';
import 'rmesaj.dart';

class ApiDatabase {
  int mindex = 0;
  setmindextozero() {
    mindex = 0;
  }

  incmindex() {
    mindex++;
  }

  giris(String kulEmail, String kulSifre) async {
    var digest = sha1.convert(utf8.encode(kulEmail));
    final response = await post("http://gelengigames.com/deneme.php", body: {
      'kulEmail': kulEmail,
      'kulSifre': kulSifre,
      'method': 'giris',
      'auth': digest.toString()
    });
    var sonuc = jsonDecode(response.body);
    int kulID = int.parse(sonuc['kulID']);
    if (kulID != 10) {
      KULDATA.kulEmail = kulEmail;
      KULDATA.kulId = kulID;
      await kullverisicek();
      return true;
    } else
      return false;
  }

  kullverisicek() async {
    var digest = sha1.convert(utf8.encode(KULDATA.kulEmail));
    final response = await post("http://gelengigames.com/deneme.php", body: {
      'kulId': KULDATA.kulId.toString(),
      'method': 'kullverisicek',
      'auth': digest.toString()
    });
    var sonuc = jsonDecode(response.body);
    KULDATA.kulAdi = sonuc['KullaniciAdi'].toString();
    KULDATA.kulSoyad = sonuc['KullaniciSoyad'].toString();
  }

  esles() async {
    if (KULDATA.kulEmail != null) {
      var digest = sha1.convert(utf8.encode(KULDATA.kulEmail));
      final response = await post("http://gelengigames.com/deneme.php", body: {
        'kulEmail': KULDATA.kulEmail.toString(),
        'method': 'esles',
        'auth': digest.toString()
      });
      var sonuc = jsonDecode(response.body);
      return sonuc['Eslesme'];
    }
  }

  eslesmeControl() async {
    if (KULDATA.kulEmail != null) {
      var digest = sha1.convert(utf8.encode(KULDATA.kulEmail));
      final response = await post("http://gelengigames.com/deneme.php", body: {
        'kulID': KULDATA.kulId.toString(),
        'method': 'eslesmeControl',
        'auth': digest.toString()
      });
      var sonuc = jsonDecode(response.body);
      return sonuc['Eslesmecontrol'];
    }
  }

  mesajGonder(String mesaj) async {
    bool mesajsonuc = await DBProvider.db.mesajKontrol(mesaj);
    var digest = sha1.convert(utf8.encode(KULDATA.kulEmail));
    if (mesajsonuc) {
      await post("http://gelengigames.com/deneme.php", body: {
        'mesajID': KULDATA.mesajid.toString(),
        'mesaj': mesaj,
        'kulID': KULDATA.kulId.toString(),
        'method': 'mesajat',
        'auth': digest.toString()
      });
      return true;
    } else {
      await post("http://gelengigames.com/deneme.php", body: {
        'mesajID': KULDATA.mesajid.toString(),
        'method': 'eslesmeBitir',
        'auth': digest.toString()
      });
      return false;
    }
  }

  mesajcek() async {
    var digest = sha1.convert(utf8.encode(KULDATA.kulEmail));
    final response = await post("http://gelengigames.com/deneme.php", body: {
      'MesajId': KULDATA.mesajid.toString(),
      'Mindex': mindex.toString(),
      'method': 'mesajCek',
      'auth': digest.toString()
    });
    if (response.body != "NULL QUERY mesajCek") {
      mindex++;
      var jsondata = json.decode(response.body)[0];
      return Rmesaj(gonderenid: int.parse(jsondata['GonderenId']),mesaj: jsondata['Mesaj'],mindex: int.parse(jsondata['MESAJINDEX']),isnull: false);
    }
    else
    return Rmesaj(isnull: true);
  }

  eslesmeBitir() async {
    var digest = sha1.convert(utf8.encode(KULDATA.kulEmail));
    await post("http://gelengigames.com/deneme.php", body: {
      'mesajID': KULDATA.mesajid.toString(),
      'method': 'eslesmeBitir',
      'auth': digest.toString()
    });
    return false;
  }

  bitiskontrol() async {
    var digest = sha1.convert(utf8.encode(KULDATA.kulEmail));
    final response = await post("http://gelengigames.com/deneme.php", body: {
      'kulID': KULDATA.kulId.toString(),
      'method': 'bitiskontrol',
      'auth': digest.toString()
    });
    var sonuc = jsonDecode(response.body);
    return sonuc['bitisControl'];
  }
}
