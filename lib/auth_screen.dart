import 'package:asset_cache/asset_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:price_checker_app/base_provider.dart';
import 'package:price_checker_app/model/login_model.dart';
import 'package:price_checker_app/scan_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config.dart';
import 'database/config_database.dart';
import 'database/query_helper.dart';
import 'helper_widget.dart';
import 'model/general_model.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  var usernameController = TextEditingController();
  final FocusNode usernameFocus = FocusNode();
  var passwordController = TextEditingController();
  final FocusNode passwordFocus = FocusNode();
  final DatabaseConfig _helper = new DatabaseConfig();

  Future tryAgain()async{
    Navigator.pop(context);
    this.login();
  }

  Future login()async{
    if(usernameController.text==''){
      WidgetHelper().notifBar(context,"failed","username cannot be empty");
      usernameFocus.requestFocus();
    }
    else if(passwordController.text==''){
      WidgetHelper().notifBar(context,"failed","password cannot be empty");
      passwordFocus.requestFocus();
    }
    else{
      WidgetHelper().loadingDialog(context);
      final data={
        "username": usernameController.text,
        "password": passwordController.text,
        "lokasi": "",
        "kassa": ""
      };
      var res = await BaseProvider().postProvider("auth/bo", data,isTenant: true);
      Navigator.pop(context);
      if(res==Constant().errSocket||res==Constant().errTimeout){
        WidgetHelper().notifDialog(context, 'Warning !!', 'no connection available', (){tryAgain();});
      }
      else{
        if(res is General){
          WidgetHelper().notifDialog(context, 'Failed !!', 'Username and password do not match', (){Navigator.pop(context);});
        }
        else{
          var result = LoginModel.fromJson(res);
          if(result.status=='success'){
            final toLocalUser={
              "id": result.result.id.toString(),
              "token": result.result.token.toString(),
              "username": result.result.username.toString(),
              "user_lvl": result.result.userLvl.toString(),
              "password_otorisasi": result.result.passwordOtorisasi.toString(),
              "nama": result.result.nama.toString(),
              "alamat": result.result.alamat.toString(),
              "email": result.result.email.toString(),
              "nohp": result.result.nohp.toString(),
              "tgl_lahir": result.result.tglLahir.toString(),
              "foto": result.result.foto.toString(),
              "created_at": result.result.createdAt.toString(),
              "logo":  result.result.logo.toString(),
              "fav_icon": result.result.favIcon.toString(),
              "title": result.result.title.toString(),
              "set_harga": result.result.setHarga.toString(),
              "use_supplier": result.result.useSupplier.toString(),
              "is_public": result.result.isPublic.toString()
            };
            final countTbl = await _helper.getData("SELECT * FROM user");
            if(countTbl.length>0){
              await _helper.deleteAll(UserQuery.TABLE_NAME);
              print("DELET USER");
              await _helper.deleteAll(LokasiQuery.TABLE_NAME);
              print("DELET LOKASI");
            }
            print("INSERT USER $toLocalUser");
            await _helper.insert(UserQuery.TABLE_NAME,toLocalUser);
            for(var i=0;i<result.result.lokasi.length;i++){
              print("INSERT LOKASI ${result.result.lokasi[i].nama}");
              await _helper.insert(LokasiQuery.TABLE_NAME,{"kode":result.result.lokasi[i].kode.toString(),"name":result.result.lokasi[i].nama.toString()});
            }
            setState(() {
              usernameController.text='';
              passwordController.text='';
            });
            WidgetHelper().myModal(context, LocationModal());

          }
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Constant().mainColor,
      body: LayoutBuilder(
        builder: (context,constraints)=>ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left:20.0,right:20.0),
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FutureBuilder<ByteData>(
                      future: ByteDataAssets.instance.load('ic_logo.png'),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: MemoryImage(snapshot.data.buffer.asUint8List()),
                                    fit: BoxFit.fitWidth,
                                    alignment: Alignment.topCenter
                                )
                            ),
                          );
                          // return Image.memory(snapshot.data.buffer.asUint8List());
                        } else {
                          return Text('loading..');
                        }
                      },
                    ),
                    //
                    // Container(
                    //   height: 200,
                    //   width: 200,
                    //   decoration: BoxDecoration(
                    //       image: DecorationImage(
                    //           image: AssetImage('${Constant().localAssets}ic_logo.png'),
                    //           fit: BoxFit.fitWidth,
                    //           alignment: Alignment.topCenter
                    //       )
                    //   ),
                    // ),
                    Container(
                      width: MediaQuery.of(context).size.width/3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        // color: Colors.white,
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                        child:Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10.0),
                            Text("Username", style: TextStyle(color: Colors.grey[200])),
                            SizedBox(height: 10.0),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey[200]
                              ),
                              child: TextFormField(
                                cursorColor: Constant().mainColor,
                                style: TextStyle(fontSize:14,fontWeight: FontWeight.bold,color: Constant().mainColor),
                                controller: usernameController,
                                maxLines: 1,
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey[200]),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  hintStyle: TextStyle(color:Constant().mainColor),
                                ),
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                focusNode: usernameFocus,
                                onFieldSubmitted: (term){
                                  passwordFocus.requestFocus();
                                },
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text("Password", style: TextStyle(color: Colors.grey[200])),
                            SizedBox(height: 10.0),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey[200]
                              ),
                              child: TextFormField(
                                cursorColor: Constant().mainColor,
                                style: TextStyle(fontSize:14,fontWeight: FontWeight.bold,color: Constant().mainColor),
                                controller: passwordController,
                                maxLines: 1,
                                obscureText: true,
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey[200]),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  hintStyle: TextStyle(color:Constant().mainColor),
                                ),
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                focusNode: passwordFocus,

                              ),
                            ),
                            SizedBox(height: 30.0),
                            InkWell(
                              borderRadius: BorderRadius.circular(10),
                              highlightColor: Colors.transparent,
                              splashColor: Colors.black,
                              onTap: ()async{
                                await Future.delayed(Duration(milliseconds: 90));
                                login();
                                // WidgetHelper().myPush(context, ScanScreen());
                                // WidgetHelper().myModal(context, ModalTenant());
                              },
                              child: Container(
                                padding: EdgeInsets.only(top:20.0,bottom:20.0),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey[200]),
                                ),
                                child: Text('SIGN IN', textAlign: TextAlign.center, style: TextStyle(letterSpacing:5.0,color:Colors.white,fontWeight: FontWeight.bold),),
                              ),

                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],
        )
      ),
    );
  }

}

class LocationModal extends StatefulWidget {
  @override
  _LocationModalState createState() => _LocationModalState();
}

class _LocationModalState extends State<LocationModal> {
  List arrLocation=[];

  DatabaseConfig _helper = DatabaseConfig();

  Future loadData()async{
    var res = await _helper.getData("SELECT * FROM lokasi");
    setState(() {
      arrLocation = res;
    });

    print(res);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height/1.5,
      padding: EdgeInsets.only(top:10.0,left:0,right:0),
      child: Column(
        children: [
          Center(
            child: Container(
              padding: EdgeInsets.only(top:0.0),
              width: 50,
              height: 10.0,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius:  BorderRadius.circular(10.0),
              ),
            ),
          ),
          ListTile(
            dense:true,
            contentPadding: EdgeInsets.only(left: 10.0, right: 10.0),
            leading: InkWell(
              onTap: ()=>Navigator.pop(context),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Center(child: Icon(Icons.close,color:Colors.grey[200])),
              ),
            ),
            title: Text("Choose Location",style: TextStyle(color: Colors.grey[200],fontWeight: FontWeight.bold),),
          ),
          Divider(),
          Expanded(
            child: Scrollbar(
                child: ListView.separated(
                    itemBuilder: (context,index){
                      return InkWell(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.black38,
                        onTap: ()async{
                          await Future.delayed(Duration(milliseconds: 90));
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          print("=========================== NAMA LOKASI ${arrLocation[index]['name']}");
                          print("=========================== KODE LOKASI ${arrLocation[index]['kode']}");
                          prefs.setString("nama_lokasi",arrLocation[index]['name']);
                          prefs.setString("kode_lokasi",arrLocation[index]['kode']);
                          WidgetHelper().myPushRemove(context,ScanScreen());
                        },
                        child: ListTile(
                          title: Text("${arrLocation[index]['name']}",style: TextStyle(color:Colors.grey[200]),),
                          trailing: Icon(Icons.arrow_forward_ios,color:Colors.grey[200]),
                        ),
                      );
                    },
                    separatorBuilder: (context,index){return Divider(height: 1.0,color: Colors.black12);},
                    itemCount:arrLocation.length
                )
            ),
          )
        ],
      ),
    );
  }
}


