import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:order_app/api/firebase_api.dart';
import 'package:order_app/constants.dart';
import 'package:order_app/models/order.dart';
import 'package:order_app/models/user_model.dart';
import 'package:order_app/providers/order_provider.dart';
import 'package:order_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:order_app/utility/size_config.dart';

class OrderCard extends StatefulWidget {
  OrderCard({this.orderModel, this.index});

  final Order orderModel;
  final int index;

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  String profileImage;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double sizeH = SizeConfig.safeBlockVertical;
    double sizeW = SizeConfig.safeBlockHorizontal;

    final users = Provider.of<List<UserModel>>(context);

    users.forEach((element) {
      if (element.uid == widget.orderModel.userNameID) {
       profileImage = element.profileImage;
      }
    });

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color:
        Colors.white,
        boxShadow: [
          BoxShadow(
            spreadRadius: 1,
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: Offset(2, 4), // Shadow position
          ),
        ],
      ),

      child: Padding(
        padding: EdgeInsets.all(sizeH * 1),
        child: IntrinsicHeight(
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: kBackgroundColor,
                radius: 25.0,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: profileImage != null ? Image.network(profileImage).image : Image.asset('assets/images/profile_picture.png').image,//Selected Image
                        fit: BoxFit.fill),
                  ),
                )
                ),
              SizedBox(width: sizeW * 2,),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(sizeH * 0.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.orderModel.foodName,
                        style: TextStyle(
                          color: kDarkGreyTextColor,
                          fontSize: sizeH * 2,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        widget.orderModel.userName,
                        style: TextStyle(
                          color: kDarkGreyTextColor,
                          fontSize: sizeH * 2,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              VerticalDivider(
                width: sizeW * 0.5,
                color: kDividerColor,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: sizeW * 2),
                child: Text(
                  '${widget.orderModel.price.toStringAsFixed(2)} kn',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: kDarkGreyTextColor,
                    fontSize: sizeH * 2.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
