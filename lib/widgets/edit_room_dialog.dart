import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:order_app/models/order.dart';
import 'package:order_app/models/room.dart';
import 'package:order_app/providers/order_provider.dart';
import 'package:order_app/utility/size_config.dart';
import 'package:order_app/widgets/alert_remove_room_dialog.dart';
import 'package:order_app/widgets/error_dialog.dart';
import 'package:provider/provider.dart';
import 'package:order_app/providers/rooms_provider.dart';
import 'package:order_app/widgets/alert_remove_room_dialog.dart';
import 'package:order_app/models/room.dart';
import '../constants.dart';

class EditRoomDialog extends StatefulWidget {

  Room room;

  EditRoomDialog(this.room);

  @override
  _EditRoomDialogState createState() => _EditRoomDialogState();
}

class _EditRoomDialogState extends State<EditRoomDialog> {
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double sizeH = SizeConfig.safeBlockVertical;
    double sizeW = SizeConfig.safeBlockHorizontal;
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
                  padding: EdgeInsets.only(left: sizeW * 6, top: sizeH * 3, bottom: sizeH * 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Edit Room Name', style: TextStyle(
                        color: kDarkGreyTextColor,
                      ),
                      ),
                      SizedBox(
                        height: sizeH * 1,
                      ),
                      Text('Rename or Delete Room', style: TextStyle(
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
                  initialValue: widget.room.title,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  maxLength: 30,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    focusedBorder:UnderlineInputBorder(
                      borderSide: const BorderSide(color: kGreenColor, width: 2.0),
                    ),
                    hintText: 'Room Name',
                  ),
                  onSaved: (value) {
                    setState(() {
                      widget.room.title = value;
                    });
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter Room name';
                    } else {
                      if (value.length < 3) {
                        return 'Room name must be longer than 3 characters';
                      }
                    }
                    return null;
                  },
                ),
                Row(
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
              ],
            ),
          ),
        ),
        // actionsPadding: EdgeInsets.symmetric(horizontal: sizeH * 1, vertical: sizeH * 1),
        actions: [
          ButtonBar(
            alignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  if (formkey.currentState.validate()) {
                    formkey.currentState.save();
                    Provider.of<RoomsProvider>(context, listen: false).updateRoom(widget.room, widget.room.title);
                    Navigator.pop(context);
                  }
                },
                child: Padding(
                  padding: EdgeInsets.all(sizeH * 0.05),
                  child: Container(
                    height: sizeH * 5,
                    width: sizeW * 18,
                    decoration: BoxDecoration(
                        color: kGreenColor,
                        border: Border.all(color: kGreenColor),
                        borderRadius: BorderRadius.all(Radius.circular(20.0))
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        'EDIT',
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
                  showDialog(
                    context: context,
                    builder: (buildContext) {
                      return AlertRemoveRoomDialog(widget.room);
                    },
                  );
                  // Provider.of<RoomsProvider>(context, listen: false)
                  //     .removeRoom(widget.room) ;
                  // Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.all(sizeH * 0.05),
                  child: Container(
                    height: sizeH * 5,
                    width: sizeW * 18,
                    decoration: BoxDecoration(
                        color: kRedColor,
                        border: Border.all(color: kRedColor),
                        borderRadius: BorderRadius.all(Radius.circular(20.0))
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        'REMOVE',
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
                    width: sizeW * 18,
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
