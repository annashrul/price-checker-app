import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:price_checker_app/database_screen.dart';
import 'package:price_checker_app/helper_widget.dart';

import 'config.dart';
class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
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
    searchProduct();
  }

  Future searchProduct()async{
    print("=================================== BARCODE HERE ${barcodeController.text} ================================");

    WidgetHelper().notifBar(context,"success","kode barang : ${barcodeController.text}");
    // WidgetHelper().myPush(context,DatabaseScreen());
    Future.delayed(Duration(seconds: 2));
    setState(() {
      barcodeController.text='';
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    barcodeFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant().mainColor,

      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('SCAN YOUR ITEM', textAlign: TextAlign.center, style: TextStyle(fontSize:20.0,letterSpacing:5.0,color:Colors.white,fontWeight: FontWeight.bold)),
              Image.network('https://i.pinimg.com/originals/5e/2c/2c/5e2c2c13b52b2ae170c2f9d97156f880.gif',color: Colors.white,height: 50.0),
              SizedBox(height: 30.0),
              InkWell(
                highlightColor: Colors.transparent,
                splashColor: Colors.black,
                borderRadius: BorderRadius.circular(35.0),
                onTap: (){scanQR();},
                child: Image.asset('${Constant().localAssets}scanner.png',height: 220,color: Colors.white),
              ),
              SizedBox(height: 20.0),
              Container(
                width: MediaQuery.of(context).size.width/1.9,
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[200],width: 2.0)
                    )
                ),
                child: TextFormField(
                  cursorColor: Colors.grey[200],
                  style: TextStyle(fontSize:14,fontWeight: FontWeight.bold,color:Colors.grey[200]),
                  controller: barcodeController,
                  maxLines: 1,
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[200]),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    hintStyle: TextStyle(color:Colors.grey[200]),
                  ),
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  focusNode: barcodeFocus,
                  onFieldSubmitted: (e){
                    print("=================================== onFieldSubmitted : $e");
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
