import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:price_checker_app/auth_screen.dart';
import 'package:price_checker_app/base_provider.dart';
import 'package:price_checker_app/database_screen.dart';
import 'package:price_checker_app/detail_product.dart';
import 'package:price_checker_app/helper_widget.dart';
import 'package:price_checker_app/model/product_model.dart';
import 'package:price_checker_app/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtual_keyboard/virtual_keyboard.dart';
import 'package:wakelock/wakelock.dart';
import 'dart:ui' as ui;
import 'config.dart';
import 'model/general_model.dart';
class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey _menuKey = new GlobalKey();
  PopupMenu menu;
  GlobalKey btnKey = GlobalKey();
  GlobalKey btnKey2 = GlobalKey();
  GlobalKey btnKey3 = GlobalKey();
  bool isLoading=false;
  String _scanBarcode = 'Unknown';
  var barcodeController = TextEditingController();
  final FocusNode barcodeFocus = FocusNode();
  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode("#00e676", "Cancel", true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted)return false;

    setState(() {
      _scanBarcode = barcodeScanRes;
      barcodeController.text = barcodeScanRes;
    });
    searchProduct(barcodeScanRes);
  }
  Future searchProduct(e)async{
    WidgetHelper().loadingDialog(context);
    print("=================================== BARCODE HERE ${barcodeController.text} ================================");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString("kode_lokasi");
    var res = await BaseProvider().getProvider("barang/get?page=1&searchby=barcode&lokasi=${prefs.getString("kode_lokasi")}&q=$e", productModelFromJson,isLogin: true);
    // var res = await BaseProvider().getProvider("barang/get?page=1&searchby=barcode&lokasi=${prefs.getString("kode_lokasi")}&q=2109019753", productModelFromJson,isLogin: true);
    setState(() {
      barcodeController.text='';
    });
    Navigator.pop(context);
    if(res==Constant().errTimeout||res==Constant().errSocket){
      WidgetHelper().notifBar(context,"failed", 'no connection available');
    }
    else if(res=='400'){
      WidgetHelper().notifBar(context,"failed", 'Product not found');
      hideKeyboard(context);
      barcodeFocus.requestFocus();
    }
    else{
      if(res is General){
        WidgetHelper().notifBar(context,"failed", 'Product not found');
        hideKeyboard(context);
        barcodeFocus.requestFocus();
      }
      else{
        if(res is ProductModel){
          List arrProduct=[];
          var result = ProductModel.fromJson(res.toJson());
          if(result.result.data.length>0){
            print(result.result.data.length);
            result.result.data.forEach((element) {
              arrProduct.add(element.toJson());
            });
            WidgetHelper().myPushAndLoad(context,DetailProduct(data: arrProduct),(){
              print("#################################### ABUS EUY ##################################");

              hideKeyboard(context);
              SystemChannels.textInput.invokeMethod('TextInput.hide');
              barcodeFocus.requestFocus();
              if(this.mounted){
                setState(() {});

              }
            });
          }
          else{
            WidgetHelper().notifBar(context,"failed", 'Product Not Found');
          }
        }

      }
    }
  }
  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus.unfocus();
    }
  }
  void stateChanged(bool isShow) {
    print('menu is ${isShow ? 'showing' : 'closed'}');
  }
  void onClickMenu(MenuItemProvider item)async {
    if(item.menuTitle=='Setting'){
      // barcodeFocus.unfocus();
      WidgetHelper().myModal(context, TimerModal(callback: (param){
        if(param=='success'){
          hideKeyboard(context);
          barcodeFocus.requestFocus();
        }
      }));
    }
    else{
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove("kode_lokasi");
      WidgetHelper().myPushRemove(context,AuthScreen());
    }
  }
  void onDismiss() {
    print('Menu is dismiss');
  }
  void maxColumn() {
    PopupMenu menu = PopupMenu(
        maxColumn: 2,
        items: [
          MenuItem(
              title: 'Exit',
              image: Icon(Icons.settings_power, color: Colors.white,)
          ),
          MenuItem(
              title: 'Setting',
              image: Icon(Icons.settings, color: Colors.white,)
          ),

        ],
        onClickMenu: onClickMenu,
        stateChanged: stateChanged,
        onDismiss: onDismiss
    );
    menu.show(widgetKey: btnKey);
  }
  String img='';
  final repo = Repository();
  Future loadUser()async{
    final foto  = await repo.getDataUser("logo");
    print(foto);
    setState(() {
      img = foto;
    });
    barcodeFocus.requestFocus();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUser();
    Wakelock.enable();
    // SystemChannels.textInput.invokeMethod('TextInput.hide');
    // WidgetsBinding.instance.addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
  }
  Future<void> _refresh() {
    return loadUser();
  }
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    PopupMenu.context = context;
    barcodeFocus.requestFocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        actions: [
          Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                  margin: EdgeInsets.only(right:50),
                  height: 24,
                  width: 24,
                  child:MaterialButton(
                    height: 45.0,
                    key: btnKey,
                    onPressed: maxColumn,
                    child: Icon(Icons.more_vert, size: 24,color: Colors.white,),
                  )
              ),
            ],
          )
        ],
      ),
      key: _scaffoldKey,
      backgroundColor: Constant().mainColor,
      // resizeToAvoidBottomPadding: true,
      resizeToAvoidBottomInset: true,
      body:GestureDetector(
        // behavior: HitTestBehavior.translucent,
        onTap: (){
          print("onTap");
          hideKeyboard(context);
          barcodeFocus.requestFocus();
        },
        onDoubleTap: (){
          print("onDoubleTap");
          hideKeyboard(context);
          barcodeFocus.requestFocus();
        },
        onTapDown: (e){
          print("onTapDown");
          hideKeyboard(context);
          barcodeFocus.requestFocus();
        },
        onTapCancel: (){
          print("onTapCancel");
          hideKeyboard(context);
          barcodeFocus.requestFocus();
        },
        onForcePressEnd: (e){
          print("onForcePressEnd");
          hideKeyboard(context);
          barcodeFocus.requestFocus();
        },
        onForcePressPeak: (e){
          print("onForcePressPeak");
          hideKeyboard(context);
          barcodeFocus.requestFocus();
        },
        onForcePressStart: (e){
          print("onForcePressStart");
          hideKeyboard(context);
          barcodeFocus.requestFocus();
        },
        onForcePressUpdate: (e){
          print("onForcePressUpdate");
          hideKeyboard(context);
          barcodeFocus.requestFocus();
        },
        onHorizontalDragCancel: (){
          print("onForcePressUpdate");
          hideKeyboard(context);
          barcodeFocus.requestFocus();
        },
        onHorizontalDragDown: (e){
          print("onForcePressUpdate");
          hideKeyboard(context);
          barcodeFocus.requestFocus();
        },
        onHorizontalDragEnd: (e){
          print("onForcePressUpdate");
          hideKeyboard(context);
          barcodeFocus.requestFocus();
        },
        onHorizontalDragStart: (e){
          print("onForcePressUpdate");
          hideKeyboard(context);
          barcodeFocus.requestFocus();
        },
        onHorizontalDragUpdate: (e){
          print("onForcePressUpdate");
          hideKeyboard(context);
          barcodeFocus.requestFocus();
        },
        onLongPress: (){
          print("onForcePressUpdate");
          hideKeyboard(context);
          barcodeFocus.requestFocus();
        },
        onLongPressEnd: (e){
          print("onForcePressUpdate");
          hideKeyboard(context);
          barcodeFocus.requestFocus();
        },
        onLongPressMoveUpdate: (e){
          print("onForcePressUpdate");
          hideKeyboard(context);
          barcodeFocus.requestFocus();
        },
        onLongPressStart: (e){
          print("onForcePressUpdate");
          hideKeyboard(context);
          barcodeFocus.requestFocus();
        },
        onLongPressUp: (){
          print("onForcePressUpdate");
          hideKeyboard(context);
          barcodeFocus.requestFocus();
        },
        onPanCancel: (){
          print("onForcePressUpdate");
          hideKeyboard(context);
          barcodeFocus.requestFocus();
        },
        onPanDown: (e){
          print("onForcePressUpdate");
          hideKeyboard(context);
          barcodeFocus.requestFocus();
        },
        onPanEnd: (e){
          print("onForcePressUpdate");
          hideKeyboard(context);
          barcodeFocus.requestFocus();
        },
        onPanStart: (e){
          print("onForcePressUpdate");
          hideKeyboard(context);
          barcodeFocus.requestFocus();
        },
        onPanUpdate: (e){
          print("onForcePressUpdate");
          hideKeyboard(context);
          barcodeFocus.requestFocus();
        },

        child: RefreshIndicator(
          child:  LayoutBuilder(
            builder: (context, constraints) => ListView(
              children: [
                Container(
                  padding: const EdgeInsets.all(20.0),
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 390,
                          width: 390,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage('$img'),
                                  fit: BoxFit.cover,
                                  alignment: Alignment.centerLeft
                              )
                          ),
                        ),
                        // Container(height: MediaQuery.of(context).size.height/1,width: 1.0,color: Colors.white),
                        Container(
                          margin: EdgeInsets.only(top:50.0),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('SCAN YOUR ITEM', textAlign: TextAlign.center, style: TextStyle(fontSize:30.0,letterSpacing:5.0,color:Colors.white,fontWeight: FontWeight.bold)),
                                Text('Dekatkan barcode ke scanner untuk', textAlign: TextAlign.center, style: TextStyle(fontSize:15.0,letterSpacing:5.0,color:Colors.white,fontWeight: FontWeight.bold)),
                                Text('mendapatkan informasi harga dari barang tersebut', textAlign: TextAlign.center, style: TextStyle(fontSize:15.0,letterSpacing:5.0,color:Colors.white,fontWeight: FontWeight.bold)),
                                Image.network('https://i.pinimg.com/originals/5e/2c/2c/5e2c2c13b52b2ae170c2f9d97156f880.gif',color: Colors.white,height: 50.0),
                                SizedBox(height: 30.0),
                                InkWell(
                                  highlightColor: Colors.transparent,
                                  splashColor: Colors.black,
                                  borderRadius: BorderRadius.circular(35.0),
                                  onLongPress: (){
                                    // searchProduct("e");
                                    scanQR();
                                  },
                                  child: Image.asset('${Constant().localAssets}scanner.png',height: 220,color: Colors.white),
                                ),
                                SizedBox(height: 20.0),
                                Container(
                                    width:400.0,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color:Constant().mainColor
                                    ),
                                    child:TextFormField(
                                      cursorColor: Colors.grey[200],
                                      style: TextStyle(fontSize:14,fontWeight: FontWeight.bold,color: Constant().mainColor),
                                      controller: barcodeController,
                                      maxLines: 1,
                                      autofocus: true,
                                      showCursor: false,
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(color: Constant().mainColor),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide.none,
                                        ),
                                        hintStyle: TextStyle(color: Constant().mainColor),
                                      ),
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      focusNode: barcodeFocus,
                                      onFieldSubmitted: (e){
                                        print("=================================== onFieldSubmitted : $e");
                                        searchProduct(e);
                                      },
                                      // onChanged: (e){
                                      //   print("=================================== onChanged : $e");
                                      // },
                                    )
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          key: _refreshIndicatorKey,
          onRefresh: _refresh,
        ),
      ),
    );
  }

}


class TimerModal extends StatefulWidget {
  Function(String param) callback;
  TimerModal({this.callback});
  @override
  _TimerModalState createState() => _TimerModalState();
}

class _TimerModalState extends State<TimerModal> {
  var timerController = TextEditingController();
  final FocusNode timerFocus = FocusNode();
  getTimer()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getInt("timer")!=null){
      setState(() {
        text = prefs.getInt("timer").toString();
      });
    }
  }
  Future handleTimer(e)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("timer",int.parse(text));
    print(prefs.getInt("timer"));
    Navigator.pop(context);
    widget.callback('success');
    // Navigator.pop(context);
  }
  String text = '';
  bool shiftEnabled = false;
  bool isNumericMode = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Constant().mainColor,
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
            title: Text("Enter Timer (second)",style: TextStyle(color: Colors.grey[200],fontWeight: FontWeight.bold),),
          ),
          Divider(),
          Expanded(
            child: Center(
              child: Column(
              children: <Widget>[
                Text(
                  text,
                  style: Theme.of(context).textTheme.headline1,
                ),
                Divider(),
                Expanded(
                  child: InkWell(
                    onTap: (){
                      if(text!=''){
                        handleTimer(text);
                      }
                    },
                    borderRadius: BorderRadius.circular(10),
                    highlightColor: Colors.transparent,
                    splashColor: Colors.black,
                    child: Container(
                      padding: EdgeInsets.only(top:20.0,bottom:20.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey[200]),
                      ),
                      child: Text('SAVE', textAlign: TextAlign.center, style: TextStyle(letterSpacing:5.0,color:Colors.white,fontWeight: FontWeight.bold),),
                    )
                  ),
                ),
                Container(
                  color: Colors.transparent,
                  child: VirtualKeyboard(
                      height: 300,
                      textColor: Colors.white,
                      type: VirtualKeyboardType.Numeric,
                      onKeyPress: _onKeyPress
                  ),
                )
              ],
            ),
            )
          )


        ],
      ),
    );
  }
  // Fired when the virtual keyboard key is pressed.
  _onKeyPress(VirtualKeyboardKey key) {
    if (key.keyType == VirtualKeyboardKeyType.String) {
      text = text + (shiftEnabled ? key.capsText : key.text);
    } else if (key.keyType == VirtualKeyboardKeyType.Action) {
      switch (key.action) {
        case VirtualKeyboardKeyAction.Backspace:
          if (text.length == 0) return;
          text = text.substring(0, text.length - 1);
          break;
        case VirtualKeyboardKeyAction.Return:
          text = text + '\n';
          break;
        case VirtualKeyboardKeyAction.Space:
          text = text + key.text;
          break;
        case VirtualKeyboardKeyAction.Shift:
          shiftEnabled = !shiftEnabled;
          break;
        default:
      }
    }
    // Update the screen
    setState(() {});
  }
}
