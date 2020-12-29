import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:price_checker_app/config.dart';

class WidgetHelper{
  final formatter = new NumberFormat("#,###");

  myModal(BuildContext context,Widget child){
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(0.0))),
        backgroundColor: Constant().mainColor,
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: child,
        )
    );
  }

  myPushRemove(BuildContext context, Widget widget){
    return  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        new CupertinoPageRoute(builder: (BuildContext context)=>widget), (Route<dynamic> route) => false
    );
  }
  myPush(BuildContext context, Widget widget){
    return Navigator.push(context, CupertinoPageRoute(builder: (context) => widget));
  }
  myPushAndLoad(BuildContext context, Widget widget,Function callback){
    return Navigator.push(context, CupertinoPageRoute(builder: (context) => widget)).whenComplete(callback);
  }

  void notifBar(BuildContext context,String param, String desc) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      reverseAnimationCurve: Curves.decelerate,
      forwardAnimationCurve: Curves.elasticOut,
      padding: EdgeInsets.all(10),
      borderRadius: 0,
      backgroundGradient: LinearGradient(
        colors: param=='success'?[Colors.white,Colors.white]:[Colors.red, Colors.red],
        stops: [0.6, 1],
      ),
      boxShadows: [
        BoxShadow(
          color: Colors.black45,
          offset: Offset(3, 3),
          blurRadius: 3,
        ),
      ],
      icon: Icon(
        param=='success'?Icons.check_circle_outline:Icons.info_outline,
        size: 28.0,
        color: param=='success'?Constant().mainColor:Colors.white,
      ),
      duration: Duration(seconds: 3),
      leftBarIndicatorColor: param=='success'?Colors.grey[200]:Colors.red[300],
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      messageText: Text(desc,style: TextStyle(color: param=='success'?Constant().mainColor:Colors.white)),
    )..show(context);
  }

  loadingDialog(BuildContext context,{title='loading ...'}){
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 100.0),
            child: AlertDialog(
              content: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey), semanticsLabel: 'tunggu sebentar', backgroundColor: Colors.black),
                  SizedBox(width:10.0),
                  Text(title, style: TextStyle(color:Colors.grey,fontWeight:FontWeight.bold))
                  // RichText(text: TextSpan(text:'Tunggu Sebentar ...', style: TextStyle(fontWeight:FontWeight.bold,color:Theme.of(context).primaryColorDark, fontSize: 14)))
                ],
              ),
            )
        );
      },
    );
  }

  notifDialog(BuildContext context,title,desc,Function callback,{txtBtn='Oke'}){
    return  showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: AlertDialog(
              title:Text('$title'),
              content:Text('$desc'),
              actions: <Widget>[
                FlatButton(
                  onPressed:callback,
                  child:Text("$txtBtn"),
                ),
              ],
            ),
          );
        }
    );
  }
  loadingWidget(BuildContext context,{title='loading ...'}){
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey), semanticsLabel: 'tunggu sebentar', backgroundColor: Colors.black),
          SizedBox(width:10.0),
          Text(title, style: TextStyle(color:Colors.grey,fontWeight:FontWeight.bold))
        ],
      ),
    );
  }

}