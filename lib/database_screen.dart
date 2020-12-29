import 'package:flutter/material.dart';
import 'package:price_checker_app/auth_screen.dart';

import 'config.dart';
import 'helper_widget.dart';
import 'tenant_screen.dart';

class DatabaseScreen extends StatefulWidget {
  @override
  _DatabaseScreenState createState() => _DatabaseScreenState();
}

class _DatabaseScreenState extends State<DatabaseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constant().mainColor,
      bottomSheet: InkWell(
        borderRadius: BorderRadius.circular(0),
        highlightColor: Colors.transparent,
        splashColor: Colors.black,
        onTap: ()async{
          await Future.delayed(Duration(milliseconds: 90));
          WidgetHelper().myPush(context, AuthScreen());
          // WidgetHelper().myModal(context, ModalTenant());
        },
        child: Container(
          padding: EdgeInsets.only(top:20.0,bottom:20.0),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[200]),
          ),
          child: Text('SELANJUTNYA', textAlign: TextAlign.center, style: TextStyle(letterSpacing:5.0,color:Constant().mainColor,fontWeight: FontWeight.bold),),
        ),

      ),
      body: Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top:20.0),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('${Constant().localAssets}bg_db.png'),
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter
                )
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 300),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              // color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.all(23),
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                    child:Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.0),
                        InkWell(
                          borderRadius: BorderRadius.circular(10),
                          highlightColor: Colors.transparent,
                          splashColor: Colors.black,
                          onTap: ()async{
                            await Future.delayed(Duration(milliseconds: 90));
                            // WidgetHelper().myModal(context, ModalTenant(title: 'Database'));
                          },
                          child: Container(
                            padding: EdgeInsets.all(20.0),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey[200]),
                            ),
                            child: Text('CHOOSE DATABASE', textAlign: TextAlign.center, style: TextStyle(letterSpacing:3.0,color: Colors.white,fontWeight: FontWeight.bold),),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
