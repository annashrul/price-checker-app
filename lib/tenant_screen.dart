import 'dart:convert';
import 'dart:typed_data';

import 'package:asset_cache/asset_cache.dart';
import 'package:flutter/material.dart';
import 'package:price_checker_app/auth_screen.dart';
import 'package:price_checker_app/base_provider.dart';
import 'package:price_checker_app/database_screen.dart';
import 'package:price_checker_app/helper_widget.dart';
import 'package:price_checker_app/model/general_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config.dart';

class TenantScreen extends StatefulWidget {
  @override
  _TenantScreenState createState() => _TenantScreenState();
}

class _TenantScreenState extends State<TenantScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  var tenantController = TextEditingController();
  final FocusNode tenantFocus = FocusNode();
  bool isError=false;

  Future tryAgain()async{
    Navigator.pop(context);
    this.save();
  }

  Future save()async{
    if(tenantController.text==''){
      tenantFocus.requestFocus();
      WidgetHelper().notifBar(context,"failed","tenant cannot be empty");
    }
    else{
      WidgetHelper().loadingDialog(context);
      var res = await BaseProvider().getProvider("site/tenant?tenant=${base64.encode(utf8.encode(tenantController.text))}", generalFromJson,isLogin: false, isTenant: false);
      Navigator.pop(context);
      if(res==Constant().errTimeout||res==Constant().errSocket){
        setState(() {
          isError=true;
        });
        WidgetHelper().notifDialog(context, 'Warning !!', 'no connection available', (){tryAgain();},txtBtn: 'Try Again');
      }
      else{
        if(res is General){
          General result = res;
          print(result.status);
          if(result.status=='success'){
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString("tenant",tenantController.text);
            WidgetHelper().myPushRemove(context,AuthScreen());
          }
          else{
            WidgetHelper().notifDialog(context, 'Failed !!', 'Oooopss, tenant not available', (){Navigator.pop(context);});
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
          padding: const EdgeInsets.only(left:50.0,right:50.0),
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left:20.0,right:20.0),
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                            Text("Tenant", style: TextStyle(color: Colors.grey[200])),
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
                                controller: tenantController,
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
                                textInputAction: TextInputAction.done,
                                focusNode: tenantFocus,
                                onFieldSubmitted: (e){
                                  save();
                                },
                              ),
                            ),

                            SizedBox(height: 30.0),
                            InkWell(
                              borderRadius: BorderRadius.circular(10),
                              highlightColor: Colors.transparent,
                              splashColor: Colors.black,
                              onTap: ()async{
                                await Future.delayed(Duration(milliseconds: 90));
                                save();
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
                                child: Text('SAVE', textAlign: TextAlign.center, style: TextStyle(letterSpacing:5.0,color:Colors.white,fontWeight: FontWeight.bold),),
                              ),

                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ),


          ],
        )
      ),
    );
  }
}

