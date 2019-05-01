import 'package:http/http.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'KULDATA.dart';
import 'Database.dart';
import 'rmesaj.dart';
import 'kontrolDonus.dart';

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
    if (response.body != "Auth Error") {
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
    else
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
    KontrolDonus mesajsonuc = await DBProvider.db.mesajKontrol(mesaj);
    var digest = sha1.convert(utf8.encode(KULDATA.kulEmail));
    if (!mesajsonuc.issame) {
      await post("http://gelengigames.com/deneme.php", body: {
        'mesajID': KULDATA.mesajid.toString(),
        'mesaj': mesaj,
        'kulID': KULDATA.kulId.toString(),
        'method': 'mesajat',
        'auth': digest.toString()
      });
      return mesajsonuc;
    } else {
      /*await post("http://gelengigames.com/deneme.php", body: {
        'mesajID': KULDATA.mesajid.toString(),
        'method': 'eslesmeBitir',
        'auth': digest.toString()
      });*/
      return mesajsonuc;
    }
  }

  mesajcek() async {
    var digest = sha1.convert(utf8.encode(KULDATA.kulEmail));
    final response = await post("http://gelengigames.com/deneme.php", body: {
      'MesajId': KULDATA.mesajid.toString(),
      'Mindex': mindex.toString(),
      'method': 'mesajCek',
      'KulId': KULDATA.kulId.toString(),
      'auth': digest.toString()
    });
    if (response.body != "NULL QUERY mesajCek") {
      mindex++;
      var jsondata = json.decode(response.body);
      List<Rmesaj> donecek = Rmesaj.fromArray(jsondata);
      return donecek;
      //return Rmesaj(gonderenid: int.parse(jsondata['GonderenId']),mesaj: jsondata['Mesaj'],mindex: int.parse(jsondata['MESAJINDEX']),isnull: false);
    } else {
      Rmesaj donecek =
          new Rmesaj(gonderenid: 0, mesaj: "0", mindex: 0, isnull: true);
      List<Rmesaj> doeceklist = new List<Rmesaj>();
      doeceklist.add(donecek);
      return doeceklist;
    }
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

  kayit(String kulAd,String kulSoyad,String kulEmail,String kulSifre) async {
    var response = await post("http://gelengigames.com/deneme.php", body: {
      'kulAd': kulAd,
      'kulSoyad': kulSoyad,
      'kulEmail': kulEmail,
      'kulSifre': kulSifre,
      'method': 'kayit',
    });
    print(response.body);
  }
}
