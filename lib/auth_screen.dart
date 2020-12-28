import 'package:flutter/material.dart';
import 'package:price_checker_app/scan_screen.dart';

import 'config.dart';
import 'helper_widget.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var usernameController = TextEditingController();
  final FocusNode usernameFocus = FocusNode();
  var passwordController = TextEditingController();
  final FocusNode passwordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      // resizeToAvoidBottomPadding: false,

      backgroundColor: Constant().mainColor,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('${Constant().localAssets}bg_auth.png'),
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter
                )
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 320),
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
                            WidgetHelper().myPush(context, ScanScreen());
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

                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

}
