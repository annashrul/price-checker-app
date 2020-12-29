// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

ProductModel productModelFromJson(String str) => ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  ProductModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
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
    this.total,
    this.perPage,
    this.offset,
    this.to,
    this.lastPage,
    this.currentPage,
    this.from,
    this.data,
  });

  int total;
  int perPage;
  int offset;
  int to;
  int lastPage;
  int currentPage;
  int from;
  List<Datum> data;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    total: json["total"],
    perPage: json["per_page"],
    offset: json["offset"],
    to: json["to"],
    lastPage: json["last_page"],
    currentPage: json["current_page"],
    from: json["from"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "per_page": perPage,
    "offset": offset,
    "to": to,
    "last_page": lastPage,
    "current_page": currentPage,
    "from": from,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.barcode,
    this.hargaBeli,
    this.satuan,
    this.hrgJual,
    this.kdBrg,
    this.nmBrg,
    this.kelBrg,
    this.kategori,
    this.stockMin,
    this.supplier,
    this.subdept,
    this.deskripsi,
    this.jenis,
    this.tglInput,
    this.tglUpdate,
    this.kcp,
    this.poin,
    this.online,
    this.fav,
    this.berat,
    this.group1,
    this.group2,
    this.stock,
    this.gambar,
    this.tambahan,
  });

  String barcode;
  String hargaBeli;
  String satuan;
  String hrgJual;
  String kdBrg;
  String nmBrg;
  String kelBrg;
  String kategori;
  String stockMin;
  String supplier;
  String subdept;
  String deskripsi;
  String jenis;
  DateTime tglInput;
  DateTime tglUpdate;
  String kcp;
  String poin;
  String online;
  String fav;
  String berat;
  String group1;
  String group2;
  String stock;
  String gambar;
  List<Tambahan> tambahan;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    barcode: json["barcode"],
    hargaBeli: json["harga_beli"],
    satuan: json["satuan"],
    hrgJual: json["hrg_jual"],
    kdBrg: json["kd_brg"],
    nmBrg: json["nm_brg"],
    kelBrg: json["kel_brg"],
    kategori: json["kategori"],
    stockMin: json["stock_min"],
    supplier: json["supplier"],
    subdept: json["subdept"],
    deskripsi: json["deskripsi"],
    jenis: json["jenis"],
    tglInput: DateTime.parse(json["tgl_input"]),
    tglUpdate: DateTime.parse(json["tgl_update"]),
    kcp: json["kcp"],
    poin: json["poin"],
    online: json["online"],
    fav: json["fav"],
    berat: json["berat"],
    group1: json["group1"],
    group2: json["group2"],
    stock: json["stock"],
    gambar: json["gambar"],
    tambahan: List<Tambahan>.from(json["tambahan"].map((x) => Tambahan.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "barcode": barcode,
    "harga_beli": hargaBeli,
    "satuan": satuan,
    "hrg_jual": hrgJual,
    "kd_brg": kdBrg,
    "nm_brg": nmBrg,
    "kel_brg": kelBrg,
    "kategori": kategori,
    "stock_min": stockMin,
    "supplier": supplier,
    "subdept": subdept,
    "deskripsi": deskripsi,
    "jenis": jenis,
    "tgl_input": tglInput.toIso8601String(),
    "tgl_update": tglUpdate.toIso8601String(),
    "kcp": kcp,
    "poin": poin,
    "online": online,
    "fav": fav,
    "berat": berat,
    "group1": group1,
    "group2": group2,
    "stock": stock,
    "gambar": gambar,
    "tambahan": List<dynamic>.from(tambahan.map((x) => x.toJson())),
  };
}

class Tambahan {
  Tambahan({
    this.kdBrg,
    this.barcode,
    this.satuan,
    this.satuanJual,
    this.qtyKonversi,
    this.harga,
    this.lokasi,
    this.ppn,
    this.service,
    this.harga2,
    this.harga3,
    this.harga4,
    this.hargaBeli,
    this.stock,
  });

  String kdBrg;
  String barcode;
  String satuan;
  int satuanJual;
  int qtyKonversi;
  String harga;
  String lokasi;
  int ppn;
  int service;
  String harga2;
  String harga3;
  String harga4;
  String hargaBeli;
  String stock;

  factory Tambahan.fromJson(Map<String, dynamic> json) => Tambahan(
    kdBrg: json["kd_brg"],
    barcode: json["barcode"],
    satuan: json["satuan"],
    satuanJual: json["satuan_jual"],
    qtyKonversi: json["qty_konversi"],
    harga: json["harga"],
    lokasi: json["lokasi"],
    ppn: json["ppn"],
    service: json["service"],
    harga2: json["harga2"],
    harga3: json["harga3"],
    harga4: json["harga4"],
    hargaBeli: json["harga_beli"],
    stock: json["stock"],
  );

  Map<String, dynamic> toJson() => {
    "kd_brg": kdBrg,
    "barcode": barcode,
    "satuan": satuan,
    "satuan_jual": satuanJual,
    "qty_konversi": qtyKonversi,
    "harga": harga,
    "lokasi": lokasi,
    "ppn": ppn,
    "service": service,
    "harga2": harga2,
    "harga3": harga3,
    "harga4": harga4,
    "harga_beli": hargaBeli,
    "stock": stock,
  };
}
