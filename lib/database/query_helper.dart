
class UserQuery {
  static const String TABLE_NAME = "user";
  static const String CREATE_TABLE =
      " CREATE TABLE IF NOT EXISTS $TABLE_NAME ( id INTEGER PRIMARY KEY AUTOINCREMENT, id_user TEXT , token TEXT, username TEXT, status TEXT, lvl TEXT, user_lvl TEXT,password_otorisasi TEXT,  nama TEXT, alamat TEXT, email TEXT, nohp TEXT, tgl_lahir TEXT, foto TEXT, created_at TEXT, logo TEXT, fav_icon TEXT, title TEXT, set_harga TEXT, use_supplier TEXT, is_public TEXT ) ";
  static const String SELECT = "select * from $TABLE_NAME";
}

class LokasiQuery {
  static const String TABLE_NAME = "lokasi";
  static const String CREATE_TABLE =
      " CREATE TABLE IF NOT EXISTS $TABLE_NAME ( id INTEGER PRIMARY KEY AUTOINCREMENT, kode TEXT , name TEXT) ";
  static const String SELECT = "select * from $TABLE_NAME";
}
