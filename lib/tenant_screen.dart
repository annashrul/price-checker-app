import 'package:flutter/material.dart';
import 'package:price_checker_app/database_screen.dart';
import 'package:price_checker_app/helper_widget.dart';

import 'config.dart';

class TenantScreen extends StatefulWidget {
  @override
  _TenantScreenState createState() => _TenantScreenState();
}

class _TenantScreenState extends State<TenantScreen> {
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
          WidgetHelper().myPush(context,DatabaseScreen());
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
                    image: AssetImage('${Constant().localAssets}bg_tenant.png'),
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter
                )
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 350),
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
                            WidgetHelper().myModal(context, ModalTenant(title: 'Tenant',));
                          },
                          child: Container(
                            padding: EdgeInsets.all(20.0),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey[200]),
                            ),
                            child: Text('CHOOSE TENANT', textAlign: TextAlign.center, style: TextStyle(letterSpacing:3.0,color: Colors.white,fontWeight: FontWeight.bold),),
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



class ModalTenant extends StatefulWidget {
  String title;
  ModalTenant({this.title});
  @override
  _ModalTenantState createState() => _ModalTenantState();
}

class _ModalTenantState extends State<ModalTenant> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height/1,
      padding: EdgeInsets.only(top:10.0,left:0,right:0),
      decoration: BoxDecoration(
        // color: Colors.white,
        // borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0),topRight:Radius.circular(10.0) ),
      ),
      // color: Colors.white,
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
            title: Text("List ${widget.title}",style: TextStyle(color: Colors.black),),
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
                      },
                      child: ListTile(
                        title: Text("${widget.title}"),
                        trailing: Icon(Icons.arrow_forward_ios,color:Colors.grey[200]),
                      ),
                    );
                  },
                  separatorBuilder: (context,index){return Divider(height: 1.0,color: Colors.grey[200]);},
                  itemCount:100
              )
            ),
          )
        ],
      ),
    );
  }
}
