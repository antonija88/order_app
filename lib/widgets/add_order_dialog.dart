import 'package:flutter/material.dart';
import 'package:order_app/models/order.dart';
import 'package:order_app/providers/order_provider.dart';
import 'package:order_app/providers/rooms_provider.dart';
import 'package:order_app/providers/user_provider.dart';
import 'package:order_app/utility/size_config.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class AddOrderDialog extends StatefulWidget {

  @override
  _AddOrderDialogState createState() => _AddOrderDialogState();
}

class _AddOrderDialogState extends State<AddOrderDialog> {
  final formkey = GlobalKey<FormState>();
  FocusNode focusNodeOrder;
  FocusNode focusNodePrice;
  Order orderItem = Order();

  @override
  void initState() {
    super.initState();
    focusNodeOrder = FocusNode();
    focusNodePrice = FocusNode();
  }

  @override
  void dispose() {
    focusNodeOrder.dispose();
    focusNodePrice.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double sizeH = SizeConfig.safeBlockVertical;
    double sizeW = SizeConfig.safeBlockHorizontal;
    final room = Provider.of<RoomsProvider>(context, listen: false).room;
    return Container(
      color: Colors.grey.withOpacity(0.01),
      child: AlertDialog(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: sizeW * 6, top: sizeH * 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Add Order', style: TextStyle(
                        color: kDarkGreyTextColor,
                      ),
                      ),
                      SizedBox(
                        height: sizeH * 0.5,
                      ),
                      Text('Choose from Menu', style: TextStyle(
                          color: kDarkGreyTextColor,
                          fontSize: sizeH * 2,
                          fontWeight: FontWeight.w300
                      ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        // contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
        content: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: Form(
            key: formkey,
            child: Container(
              height: sizeH * 22,
              child: Column(
                children: [
                  TextFormField(
                    // initialValue: widget.item.foodName,
                    focusNode: focusNodeOrder,
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    maxLength: 30,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      focusedBorder:UnderlineInputBorder(
                        borderSide: const BorderSide(color: kGreenColor, width: 2.0),
                      ),
                      hintText: 'Your order',
                    ),
                    onFieldSubmitted: (term) {
                      focusNodeOrder.unfocus();
                      FocusScope.of(context).requestFocus(focusNodePrice);
                    },
                    onSaved: (value) {
                      setState(() {
                        orderItem.foodName = value;
                      });
                    },
                  ),
                  TextFormField(
                    // initialValue: widget.item.price.toString(),
                    focusNode: focusNodePrice,
                    // autofocus: true,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      focusedBorder:UnderlineInputBorder(
                        borderSide: const BorderSide(color: kGreenColor, width: 2.0),
                      ),
                      hintText: 'Price',
                    ),
                    onFieldSubmitted: (term) {
                      focusNodePrice.unfocus();
                    },
                    onSaved: (value) {
                      setState(() {
                          double itemPrice = double.parse(value);
                          orderItem.price = itemPrice;
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        // actionsPadding: EdgeInsets.symmetric(horizontal: sizeH * 1, vertical: sizeH * 1),
        actions: [
          ButtonBar(
            alignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  if (formkey.currentState.validate()) {
                    formkey.currentState.save();
                    setState(() {
                      orderItem.userNameID = Provider.of<UserProvider>(context, listen: false).user.uid;
                      orderItem.userName = Provider.of<UserProvider>(context, listen: false).user.username;
                    });
                    Provider.of<OrderProvider>(context, listen: false).addOrder(orderItem, room);
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  height: sizeH * 5,
                  width: sizeW * 20,
                  decoration: BoxDecoration(
                      color: kGreenColor,
                      border: Border.all(color: kGreenColor),
                      borderRadius: BorderRadius.all(Radius.circular(20.0))
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'ADD',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: sizeH * 1.7),
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
                        'CANCEL',
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
      ),
    );
  }
}
