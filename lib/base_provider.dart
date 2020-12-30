import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' show Client;
import 'package:price_checker_app/config.dart';
import 'package:price_checker_app/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/general_model.dart';

class BaseProvider{
  Client client = Client();
  Future getProvider(url,param,{isTenant=false,isLogin=false})async{
    Map<String, String> head;

    if(isLogin==true){
      final repo = Repository();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final username  = base64.encode(utf8.encode(prefs.getString("tenant")));
      final token  = await repo.getDataUser("token");
      head={'Authorization':token,'username': username, 'password': Constant().password,'myconnection':Constant().connection};
    }
    if(isTenant==true){
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final username  = base64.encode(utf8.encode(prefs.getString("tenant")));
      head={'username':username, 'password': Constant().password,'myconnection':Constant().connection};
    }
    if(isTenant==false&&isLogin==false){
      head={'username': Constant().username, 'password': Constant().password,'myconnection':Constant().connection};
    }
    try{
      print("HEADER $head");
      print("URL ${Constant().baseUrl}$url");
      final response = await client.get("${Constant().baseUrl}$url", headers:head).timeout(Duration(seconds: Constant().timeout));
      print("STATUS CODE ${response.statusCode}");
      if (response.statusCode == 200) {
        return param(response.body);
      }
      else if(response.statusCode == 400){
        return '400';
      }
    }on TimeoutException catch (_) {
      print('TimeoutException');
      return 'TimeoutException';
    } on SocketException catch (_) {
      print('SocketException');
      return 'SocketException';
    }
  }
  Future postProvider(url,Map<String, Object> data,{isTenant=false,isLogin=false}) async {
    try {
      Map<String, String> head;
      final repo = Repository();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if(isLogin==true){
        final username  = base64.encode(utf8.encode(prefs.getString("tenant")));
        final token  = await repo.getDataUser("token");
        head={'Authorization':token,'username': username, 'password': Constant().password,'myconnection':Constant().connection};
      }
      if(isTenant==true){
        final username  = base64.encode(utf8.encode(prefs.getString("tenant")));
        head={'username':username, 'password': Constant().password,'myconnection':Constant().connection};
      }
      if(isTenant==false&&isLogin==false){
        head={'username': Constant().username, 'password': Constant().password,'myconnection':Constant().connection};
      }
      print(head);

      final request = await client.post(
          "${Constant().baseUrl}$url",
          headers:head,
          body:data
      ).timeout(Duration(seconds: Constant().timeout));
      print(request.body);
      if(request.statusCode==200){
        return jsonDecode(request.body);
      }
      else if(request.statusCode==400){
        return General.fromJson(jsonDecode(request.body));
      }
    } on TimeoutException catch (_) {
      return 'TimeoutException';
    } on SocketException catch (_) {
      return 'SocketException';
    }
  }


}