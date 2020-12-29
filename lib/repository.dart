import 'database/config_database.dart';
import 'database/query_helper.dart';

class Repository{
  final DatabaseConfig _helper = new DatabaseConfig();
  Future getDataUser(param) async{
    final users = await _helper.getData("SELECT * FROM ${UserQuery.TABLE_NAME}");
    if(users.length>0){
      if(param=='id'){return users[0]['id'];}
      if(param=='id_user'){return users[0]['id_user'];}
      if(param=='token'){return users[0]['token'];}
      if(param=='username'){return users[0]['username'];}
      if(param=='status'){return users[0]['status'];}
      if(param=='lvl'){return users[0]['lvl'];}
      if(param=='user_lvl'){return users[0]['user_lvl'];}
      if(param=='password_otorisasi'){return users[0]['password_otorisasi'];}
      if(param=='nama'){return users[0]['nama'];}
      if(param=='alamat'){return users[0]['alamat'];}
      if(param=='email'){return users[0]['email'];}
      if(param=='nohp'){return users[0]['nohp'];}
      if(param=='tgl_lahir'){return users[0]['tgl_lahir'];}
      if(param=='foto'){return users[0]['foto'];}
      if(param=='created_at'){return users[0]['created_at'];}
      if(param=='logo'){return users[0]['logo'];}
      if(param=='fav_icon'){return users[0]['fav_icon'];}
      if(param=='title'){return users[0]['title'];}
      if(param=='set_harga'){return users[0]['set_harga'];}
      if(param=='use_supplier'){return users[0]['use_supplier'];}
      if(param=='is_public'){return users[0]['is_public'];}
    }



  }
}