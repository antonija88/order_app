import 'package:flutter/material.dart';
import 'package:order_app/models/order.dart';
import 'package:order_app/providers/order_provider.dart';
import 'package:order_app/providers/rooms_provider.dart';
import 'package:order_app/providers/user_provider.dart';
import 'package:order_app/utility/size_config.dart';
import 'package:provider/provider.dart';
import '../constants.dart';

class ErrorDialogExistingEmail extends StatelessWidget {
  // const ErrorDialog({
  //   Key key,
  //   @required this.sizeH,
  //   @required this.sizeW,
  // }) : super(key: key);
  //
  // final double sizeH;
  // final double sizeW;

  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);
    double sizeH = SizeConfig.safeBlockVertical;
    double sizeW = SizeConfig.safeBlockHorizontal;

    return AlertDialog(
      titlePadding: EdgeInsets.zero,
      //contentPadding: EdgeInsets.zero,
      elevation: 50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0),),
      ),
      backgroundColor: Colors.white,
      // titlePadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      title: Stack(
        children: [
          Positioned(
              top: 0,
              right: 25,
              child: Image.asset("assets/images/tag.png", height: sizeH * 10,)),
          Padding(
            padding: EdgeInsets.only(left: sizeH * 4, top: sizeH * 3, bottom: sizeH * 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Error!', style: TextStyle(
                  color: kDarkGreyTextColor,
                  fontSize: sizeH * 3,
                ),),
                SizedBox(
                  height: sizeH * 6,
                ),
                Padding(
                  padding: EdgeInsets.only(left: sizeH * 2),
                  child: Text('Email is already taken', style: TextStyle(
                    color: kDarkGreyTextColor,
                    fontSize: sizeH * 2.3,
                  ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      // contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      actions: [
        ButtonBar(
          alignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: EdgeInsets.all(sizeH * 0.05),
                child: Container(
                  height: sizeH * 5,
                  width: sizeW * 20,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: kLightGreyColor),
                      borderRadius: BorderRadius.all(Radius.circular(20.0))
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'CLOSE',
                      style: TextStyle(
                          color: kDarkGreyTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: sizeH * 1.7),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}