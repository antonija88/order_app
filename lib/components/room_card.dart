import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:order_app/models/room.dart';
import 'package:order_app/utility/size_config.dart';
import 'package:order_app/constants.dart';


class RoomCard extends StatelessWidget {
  final Room room;
  RoomCard({@required this.room});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double sizeH = SizeConfig.safeBlockVertical;
    double sizeW = SizeConfig.safeBlockHorizontal;
    bool isActive = true;

    return Container(
      padding: EdgeInsets.all(sizeH * 1.5),
      decoration: BoxDecoration(
        color: Colors.white,
         borderRadius: BorderRadius.all(Radius.circular(sizeW * 4),
         ),
      ),
      child: Column(
        children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: room.isActive ? Image.asset('assets/images/Ellipse.png', height: sizeH * 1.5) :  Image.asset('assets/images/inactive_circle.png', height: sizeH * 1.5),
           ),
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Image.asset('assets/images/heart.png', height: sizeH * 1.5),
           ),
        ],
      ),
       Padding(
         padding: EdgeInsets.only(bottom: sizeH * 1),
         child: Container(child: Image.asset('assets/images/04.png', height: sizeH * 12,)),
       ),
       SizedBox(
         height: sizeH * 2,
       ),
       Padding(
         padding: EdgeInsets.all(sizeH * 0.3),
         child: Text(room.title,
           overflow: TextOverflow.visible,
           maxLines: 2,
           textAlign: TextAlign.center,
           style: TextStyle(
             fontWeight: FontWeight.w500,
             color: kDarkGreyTextColor,
             fontSize: sizeH * 2,
           ),
         ),
       ),
      ],
    ),
    );
  }
}
