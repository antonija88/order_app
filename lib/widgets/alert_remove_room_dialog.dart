import 'package:flutter/material.dart';
import 'package:order_app/models/order.dart';
import 'package:order_app/providers/order_provider.dart';
import 'package:order_app/providers/rooms_provider.dart';
import 'package:order_app/providers/user_provider.dart';
import 'package:order_app/screens/home_screen.dart';
import 'package:order_app/utility/size_config.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import 'package:order_app/models/room.dart';

class AlertRemoveRoomDialog extends StatelessWidget {
  // const ErrorDialog({
  //   Key key,
  //   @required this.sizeH,
  //   @required this.sizeW,
  // }) : super(key: key);
  //
  // final double sizeH;
  // final double sizeW;
  Room room;

  AlertRemoveRoomDialog(this.room);

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
            padding: EdgeInsets.only(left: sizeH * 3.5, top: sizeH * 3, bottom: sizeH * 4, right: sizeH*2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Alert!', style: TextStyle(
                  color: kDarkGreyTextColor,
                  fontSize: sizeH * 3,
                ),),
                SizedBox(
                  height: sizeH * 6,
                ),
                Text('Are you sure?', style: TextStyle(
                  color: kDarkGreyTextColor,
                  fontSize: sizeH * 2,
                ),
                ),
                SizedBox(
                  height: sizeH * 1,
                ),
                Text('This will delete all orders if you have any.', style: TextStyle(
                  color: kDarkGreyTextColor,
                  fontSize: sizeH * 2,
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
                Provider.of<RoomsProvider>(context, listen: false)
                    .removeRoom(room);
                Navigator.pushReplacementNamed(context, HomeScreen.routName);
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
                      'YES',
                      style: TextStyle(
                          color: kDarkGreyTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: sizeH * 1.7),
                    ),
                  ),
                ),
              ),
            ),
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
                      'NO',
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