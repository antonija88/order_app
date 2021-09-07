import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:order_app/api/firebase_api.dart';
import 'package:order_app/utility/size_config.dart';
import 'package:flutter/widgets.dart';
import 'package:order_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:order_app/constants.dart';
import 'package:order_app/models/user_model.dart';


class EditProfileItemDialog extends StatefulWidget {
  static const routName = 'edit_profile_item';

    @override
  _EditProfileItemDialogState createState() => _EditProfileItemDialogState();
}

class _EditProfileItemDialogState extends State<EditProfileItemDialog> {
  final formkey = GlobalKey<FormState>();
  UserModel user = UserModel();
  String _username;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double sizeH = SizeConfig.safeBlockVertical;
    double sizeW = SizeConfig.safeBlockHorizontal;
    user = Provider.of<UserProvider>(context, listen: false).user;
    return Container(
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
                      Text('Edit Profile', style: TextStyle(
                        color: kDarkGreyTextColor,
                      ),
                      ),
                      SizedBox(
                        height: sizeH * 1,
                      ),
                      Text('Choose Name', style: TextStyle(
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

        content: Form(
          key: formkey,
          child: Container(
            height: sizeH * 17,
            child: Column(
              children: [
                TextFormField(
                  initialValue: user.username,
                  autofocus: true,
                  maxLength: 20,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    focusedBorder:UnderlineInputBorder(
                      borderSide: const BorderSide(color: kGreenColor, width: 2.0),
                    ),
                    hintText: 'Your Name',
                  ),
                  onSaved: (value) {
                    setState(() {
                     user.username = value;
                    });
                  },
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
                    Provider.of<UserProvider>(context, listen: false).updateUser(user);
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
    );
  }
}
