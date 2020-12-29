import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:price_checker_app/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helper_widget.dart';

class DetailProduct extends StatefulWidget {
  List data=[];
  DetailProduct({this.data});
  @override
  _DetailProductState createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int timeCounter = 0;
  bool timeUpFlag = false;

  getTimer()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      timeCounter = prefs.getInt("timer");
    });
  }
  Timer timer;
  _timerUpdate() async{
    timer = new Timer(const Duration(seconds: 1), () async {
      setState(() {
        timeCounter--;
      });
      if (timeCounter != 0)
        _timerUpdate();
      else
        timeUpFlag = true;
      if(timeUpFlag==true){
        Navigator.pop(context);
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTimer();
    // timeCounter=10;
    _timerUpdate();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: [
          InkWell(
            onTap: ()=>Navigator.pop(context),
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  color:Colors.black,
                    margin: EdgeInsets.only(right:50),
                    height: 24,
                    width: 24,
                    child:Icon(Icons.close, size: 24,color: Colors.white,)
                ),
              ],
            ),
          )
        ],
      ),
      backgroundColor: Constant().mainColor,
      bottomNavigationBar:Container(
        padding: EdgeInsets.only(top:20.0,bottom: 20.0),
        color: Colors.white,
        width: double.infinity,
        child: Text("halaman akan kembali dalam hitungan $timeCounter detik",textAlign: TextAlign.center,style: TextStyle(letterSpacing:3.0,color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20))
      ),
      resizeToAvoidBottomPadding: true,
      resizeToAvoidBottomInset: true,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 400,
                    width: 400,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage('${widget.data[0]['gambar']}'),
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.topCenter
                        )
                    ),
                  ),
                  SizedBox(width: 20.0),
                 Column(
                   mainAxisAlignment: MainAxisAlignment.start,
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     tempItem(context,"BARCODE BARANG", widget.data[0]['barcode']),
                     Divider(),
                     tempItem(context,"KODE BARANG", widget.data[0]['kd_brg']),
                     Divider(),
                     tempItem(context,"NAMA BARANG", widget.data[0]['nm_brg']),
                     Divider(),
                     tempItem(context,"SATUAN BARANG", widget.data[0]['satuan']),
                     Divider(),
                     tempItem(context,"HARGA BARANG","Rp ${WidgetHelper().formatter.format(int.parse( widget.data[0]['hrg_jual']))}.-"),
                     Divider(),
                     tempItem(context,"KELOMPOK BARANG",widget.data[0]['kel_brg']),
                   ],
                 )
                ],
              ),
            )
            
          ],
        ),
      ),
    );
  }


  Widget tempItem(BuildContext context, title, desc){
    return Row(
      children: [
        Container(
          width: 300,
          child: Text("$title",style: TextStyle(letterSpacing:3.0,color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20)),
        ),
        Text(": $desc",style: TextStyle(letterSpacing:3.0,color: Colors.white,fontSize: 20)),
      ],
    );
  }
}
// I/flutter ( 4352): WIDGET PRODUCT [{barcode: 8999909001633, harga_beli: 10000, satuan: Bks, hrg_jual: 11000, kd_brg: 2012292201, nm_brg: Udud Suruput, kel_brg: KEJU, kategori: satuan, stock_min: 0, supplier: PT BARATA, subdept: Sub-Dept01, deskripsi: Udud Suruput, jenis: 1, tgl_input: 2020-12-29T07:16:04.000Z, tgl_update: 2020-12-29T07:16:04.000Z, kcp: -, poin: 0, online: 0, fav: 0, berat: 0, group1: -, group2: D00001, stock: 0, gambar: http://npos.ptnetindo.com:6692/images/cef7888fec54e4c910e34020ad9eb615/barang/barang_201229164d4DaN.png, tambahan: [{kd_brg: 2012292201, barcode: 8999909001633, satuan: Bks, satuan_jual: 1, qty_konversi: 0, harga: 11000, lokasi: LK/0003, ppn: 0, service: 0, harga2: 11000, harga3: 11000, harga4: 11000, harga_beli: 10000, stock: 0}]}]
