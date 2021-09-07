import 'package:flutter/material.dart';
import 'package:order_app/utility/size_config.dart';

class RectangularButton extends StatelessWidget {

  RectangularButton({this.buttonHeight, this.buttonTitle, this.buttonIcon, this.buttonTextColor, this.buttonColor, this.buttonIconSize});

  final double buttonHeight;
  final String buttonTitle;
  final String buttonIcon;
  final Color buttonColor;
  final Color buttonTextColor;
  final double buttonIconSize;


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double sizeH = SizeConfig.safeBlockVertical;
    double sizeW = SizeConfig.safeBlockHorizontal;
    return Container(
      padding: EdgeInsets.all(10.0),
      height: buttonHeight,
      decoration: BoxDecoration(
        color: buttonColor,
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         buttonIcon != null ? Image.asset(
            'assets/images/$buttonIcon',
            height: buttonIconSize,
          ) : SizedBox(),
          SizedBox(
            width: sizeW * 2,
          ),
          Text(
            buttonTitle,
            style: TextStyle(
              color: buttonTextColor,
              fontSize: sizeH * 2.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
