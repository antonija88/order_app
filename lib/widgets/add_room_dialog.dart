import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:order_app/models/room.dart';
import 'package:order_app/providers/rooms_provider.dart';
import 'package:order_app/utility/size_config.dart';
import 'package:provider/provider.dart';
import 'package:order_app/constants.dart';

class AddRoomDialog extends StatefulWidget {
  Room room = Room();

  @override
  _AddRoomDialogState createState() => _AddRoomDialogState();
}

class _AddRoomDialogState extends State<AddRoomDialog> {
  final formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double sizeH = SizeConfig.safeBlockVertical;
    double sizeW = SizeConfig.safeBlockHorizontal;
    return Container(
      height: sizeH * 70,
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
                  padding: EdgeInsets.only(left: sizeH * 2, top: sizeH * 3, bottom: sizeH * 1.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Add Restaurant', style: TextStyle(
                        color: kDarkGreyTextColor,
                      ),
                      ),
                      SizedBox(
                        height: sizeH * 1,
                      ),
                      Text('Your Favourite Place', style: TextStyle(
                          color: kDarkGreyTextColor,
                          fontSize: sizeH * 2,
                          fontWeight: FontWeight.w300
                      ),
                      ),
                      Text('to Eat', style: TextStyle(
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
        content: Form(
          key: formkey,
          child: Container(
            height: sizeH * 17,
            child: Column(
              children: [
                TextFormField(
                  // initialValue: widget.item.foodName,
                  autofocus: true,
                  validator: (value) {
                    if (value.length <= 0) {
                      return 'Please enter Restaurant Name';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  maxLength: 30,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    focusedBorder:UnderlineInputBorder(
                      borderSide: const BorderSide(color: kGreenColor, width: 2.0),
                    ),
                    hintText: 'Restaurant Name',
                  ),
                  onSaved: (value) {
                    setState(() {
                      widget.room.title = value;
                    });
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(top: sizeH * 0.5),
                  child: Row(
                    children: [
                      Text('Active:',
                        style: TextStyle(
                          color: kDarkGreyTextColor,
                        ),),
                      SizedBox(
                        width: sizeW * 1,
                      ),
                      CupertinoSwitch(
                          trackColor: kRedColor,
                          value: widget.room.isActive,
                          onChanged: (value) {
                            setState(() {
                              widget.room.isActive = value;
                            });
                          }
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // actionsPadding: EdgeInsets.symmetric(horizontal: sizeH * 1, vertical: sizeH * 1),
        actions: [
          ButtonBar(
            // overflowButtonSpacing: 6.0,
            alignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  if (formkey.currentState.validate()) {
                    formkey.currentState.save();
                    Provider.of<RoomsProvider>(context, listen: false).addRooms(widget.room);
                    Navigator.pop(context);
                  }
                },
                child: Padding(
                  padding: EdgeInsets.all(sizeH * 0.05),
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

      // child: Container(
      //   decoration: BoxDecoration(
      //     color: Colors.white,
      //   ),
      //   child: Padding(
      //     padding: EdgeInsets.all(20.0),
      //     child: Form(
      //       key: formkey,
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.stretch,
      //         children: [
      //           Text(
      //             'CREATE ROOM',
      //             textAlign: TextAlign.center,
      //             style: TextStyle(
      //                 fontSize: sizeH * 3, fontWeight: FontWeight.bold),
      //           ),
      //           SizedBox(height: sizeH * 1),
      //           TextFormField(
      //             autofocus: true,
      //             keyboardType: TextInputType.text,
      //             decoration: InputDecoration(
      //               border: OutlineInputBorder(
      //                   borderRadius: BorderRadius.all(Radius.circular(5.0))),
      //               labelText: 'Room name',
      //             ),
      //             onSaved: (value) {
      //               setState(() {
      //                 title = value;
      //               });
      //             },
      //           ),
      //           SizedBox(height: sizeH * 2),
      //           TextButton(
      //             onPressed: () {
      //               if (formkey.currentState.validate()) {
      //                 formkey.currentState.save();
      //                  Provider.of<RoomsProvider>(context, listen: false).addRooms(Room(title: title));
      //                 Navigator.pop(context);
      //               }
      //             },
      //             child: Text(
      //               'CREATE',
      //               style: TextStyle(
      //                   color: Colors.white,
      //                   fontWeight: FontWeight.bold,
      //                   fontSize: sizeH * 2.5),
      //             ),
      //             style: TextButton.styleFrom(
      //               backgroundColor: Colors.blueAccent,
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
