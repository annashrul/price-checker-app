// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    result: Result.fromJson(json["result"]),
    msg: json["msg"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "result": result.toJson(),
    "msg": msg,
    "status": status,
  };
}

class Result {
  Result({
    this.id,
    this.token,
    this.username,
    this.lokasi,
    this.status,
    this.lvl,
    this.access,
    this.userLvl,
    this.passwordOtorisasi,
    this.nama,
    this.alamat,
    this.email,
    this.nohp,
    this.tglLahir,
    this.foto,
    this.createdAt,
    this.logo,
    this.favIcon,
    this.title,
    this.modulAkses,
    this.namaHarga,
    this.setHarga,
    this.useSupplier,
    this.isPublic,
  });

  String id;
  String token;
  String username;
  List<Lokasi> lokasi;
  String status;
  String lvl;
  List<Access> access;
  String userLvl;
  String passwordOtorisasi;
  String nama;
  String alamat;
  String email;
  String nohp;
  DateTime tglLahir;
  String foto;
  DateTime createdAt;
  String logo;
  String favIcon;
  String title;
  List<ModulAkse> modulAkses;
  NamaHarga namaHarga;
  int setHarga;
  int useSupplier;
  int isPublic;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    token: json["token"],
    username: json["username"],
    lokasi: List<Lokasi>.from(json["lokasi"].map((x) => Lokasi.fromJson(x))),
    status: json["status"],
    lvl: json["lvl"],
    access: List<Access>.from(json["access"].map((x) => Access.fromJson(x))),
    userLvl: json["user_lvl"],
    passwordOtorisasi: json["password_otorisasi"],
    nama: json["nama"],
    alamat: json["alamat"],
    email: json["email"],
    nohp: json["nohp"],
    tglLahir: DateTime.parse(json["tgl_lahir"]),
    foto: json["foto"],
    createdAt: DateTime.parse(json["created_at"]),
    logo: json["logo"],
    favIcon: json["fav_icon"],
    title: json["title"],
    modulAkses: List<ModulAkse>.from(json["modul_akses"].map((x) => ModulAkse.fromJson(x))),
    namaHarga: NamaHarga.fromJson(json["nama_harga"]),
    setHarga: json["set_harga"],
    useSupplier: json["use_supplier"],
    isPublic: json["is_public"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "token": token,
    "username": username,
    "lokasi": List<dynamic>.from(lokasi.map((x) => x.toJson())),
    "status": status,
    "lvl": lvl,
    "access": List<dynamic>.from(access.map((x) => x.toJson())),
    "user_lvl": userLvl,
    "password_otorisasi": passwordOtorisasi,
    "nama": nama,
    "alamat": alamat,
    "email": email,
    "nohp": nohp,
    "tgl_lahir": tglLahir.toIso8601String(),
    "foto": foto,
    "created_at": createdAt.toIso8601String(),
    "logo": logo,
    "fav_icon": favIcon,
    "title": title,
    "modul_akses": List<dynamic>.from(modulAkses.map((x) => x.toJson())),
    "nama_harga": namaHarga.toJson(),
    "set_harga": setHarga,
    "use_supplier": useSupplier,
    "is_public": isPublic,
  };
}

class Access {
  Access({
    this.id,
    this.label,
    this.name,
  });

  int id;
  String label;
  String name;

  factory Access.fromJson(Map<String, dynamic> json) => Access(
    id: json["id"],
    label: json["label"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "label": label,
    "name": name,
  };
}

class Lokasi {
  Lokasi({
    this.kode,
    this.nama,
  });

  String kode;
  String nama;

  factory Lokasi.fromJson(Map<String, dynamic> json) => Lokasi(
    kode: json["kode"],
    nama: json["nama"],
  );

  Map<String, dynamic> toJson() => {
    "kode": kode,
    "nama": nama,
  };
}

class ModulAkse {
  ModulAkse({
    this.id,
    this.value,
    this.isChecked,
    this.label,
  });

  int id;
  String value;
  bool isChecked;
  String label;

  factory ModulAkse.fromJson(Map<String, dynamic> json) => ModulAkse(
    id: json["id"],
    value: json["value"],
    isChecked: json["isChecked"],
    label: json["label"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "value": value,
    "isChecked": isChecked,
    "label": label,
  };
}

class NamaHarga {
  NamaHarga({
    this.harga1,
    this.harga2,
    this.harga3,
    this.harga4,
  });

  String harga1;
  String harga2;
  String harga3;
  String harga4;

  factory NamaHarga.fromJson(Map<String, dynamic> json) => NamaHarga(
    harga1: json["harga1"],
    harga2: json["harga2"],
    harga3: json["harga3"],
    harga4: json["harga4"],
  );

  Map<String, dynamic> toJson() => {
    "harga1": harga1,
    "harga2": harga2,
    "harga3": harga3,
    "harga4": harga4,
  };
}
