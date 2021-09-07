import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:order_app/api/firebase_api.dart';
import 'package:order_app/providers/rooms_provider.dart';
import 'package:order_app/providers/user_provider.dart';
import 'package:order_app/screens/home_screen.dart';
import 'package:order_app/utility/size_config.dart';
import 'package:order_app/components/order_card.dart';
import 'package:order_app/models/order.dart';
import 'package:order_app/widgets/already_ordered_error.dart';
import 'package:order_app/widgets/edit_order_dialog.dart';
import 'package:order_app/widgets/error_dialog.dart';
import 'package:order_app/widgets/error_dialog_addOrder.dart';
import 'package:provider/provider.dart';
import 'package:order_app/providers/order_provider.dart';
import 'package:order_app/constants.dart';
import 'package:order_app/widgets/add_order_dialog.dart';
import 'package:order_app/widgets/edit_room_dialog.dart';
import 'package:order_app/widgets/error_dialog.dart';


class RoomScreen extends StatefulWidget {
  static const routName = 'room_screen';

  @override
  _RoomScreenState createState() => _RoomScreenState();
}

class _RoomScreenState extends State<RoomScreen> {
    bool didUserOrdered = false;

  // void undoDeletion(int index, Order item){
  //   Provider.of<OrderProvider>(context, listen: false).undoDeletion(index, item);
  // }

    void checkingIfUserAlreadyOrdered() {
      setState(() {
        didUserOrdered = false;
      });
      List<Order> orders = Provider.of<OrderProvider>(context, listen:false).orders;
      orders.forEach((element) {
        if(element.userNameID == Provider.of<UserProvider>(context, listen:false).user.uid) {
          setState(() {
            didUserOrdered = true;
          });
        }
      });

    }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double sizeH = SizeConfig.safeBlockVertical;
    double sizeW = SizeConfig.safeBlockHorizontal;
    List<Order> orders = Provider.of<OrderProvider>(context).orders;
    final room = Provider.of<RoomsProvider>(context, listen: false).room;

    if (orders != null && orders.isNotEmpty) {
      checkingIfUserAlreadyOrdered();
    } else {
      setState(() {
        didUserOrdered = false;
      });
    }

    return Scaffold(
        backgroundColor: kBackgroundColor,
      body:
        Padding(padding: EdgeInsets.all(sizeH * 2),
              child: Column(
                    children: [
                    Container(
                      color: kBackgroundColor,
                      child: SafeArea(
                        child: Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         GestureDetector(
                           onTap: () {
                             Navigator.pop(context);
                           },
                           child: Container(
                             child: Icon(
                                 Icons.arrow_back_ios_rounded,
                                 color: Colors.black,
                               ),
                      ),
                         ),
                         Image.asset("assets/images/Group.png", height: sizeH * 4,),
                         GestureDetector(
                           onTap: () {
                             showDialog(
                               context: context,
                               builder: (buildContext) {
                                 return EditRoomDialog(room);
                               },
                             );
                           },
                           child: Container(
                             child: Icon(
                               Icons.edit,
                               color: Colors.black,
                             ),
                           ),
                         ),
                      ],
                    ),
                      ),
                    ),
                      SizedBox(
                        height: sizeH * 2,
                      ),
                      Container(
                        height: sizeH *4,
                        child: Row(
                          children: [
                            Flexible(
                              fit: FlexFit.loose,
                              child: Text('${room.title}',
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                color: kDarkGreyTextColor,
                                fontWeight: FontWeight.w500,
                                fontSize: sizeH * 3,
                              ),),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Padding(
                          padding: EdgeInsets.only(top: sizeH * 1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                               children: [
                                 Text('You have',
                                 style: TextStyle(
                                   color: kDarkGreyTextColor,
                                 ),),
                                 SizedBox(width: sizeW * 1,),
                                 Container(
                                   decoration: BoxDecoration(
                                     color: kRedColor,
                                       border: Border.all(
                                         color: Colors.red[500],
                                       ),
                                     shape: BoxShape.circle,
                                   ),
                                   child: Padding(
                                     padding: EdgeInsets.all(sizeH * 1.5),
                                     child: Text(orders != null ? '${orders.length}' : "0",
                                       style: TextStyle(
                                         color: Colors.white,
                                       ),),
                                   ),
                                 ),
                                 SizedBox(width: sizeW * 1,),
                                 Text('items in your cart',
                                   style: TextStyle(
                                     color: kDarkGreyTextColor,
                                   ),),
                               ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (room.isActive== true) {
                                    if (didUserOrdered == false) {
                                      showDialog(
                                        context: context,
                                        builder: (buildContext) {
                                          return AddOrderDialog();
                                        },
                                      );
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (buildContext) {
                                          return AlreadyOrderedErrorDialog();
                                        },
                                      );
                                    }
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (buildContext) {
                                        return ErrorDialogAddOrder();
                                      },
                                    );
                                  }
                                },
                                child: Container(
                                  decoration:
                                  BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    color: didUserOrdered ? kGreenColor.withOpacity(0.5) : kGreenColor,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(sizeH * 1),
                                    child: Text('Add Order',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(child: Padding(
                        padding: EdgeInsets.symmetric(vertical: sizeH * 2),
                        child: StreamBuilder(
                          stream: FirebaseApi.readOrdersInRoom(room),
                          builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Text("Something Went Wrong");
                                } else {
                                  List<Order> orders = snapshot.data;
                                  if (orders != null && orders.length == 0) {
                                    return Center(child: Text("No orders"),);
                                  }
                                  Provider.of<OrderProvider>(context, listen: false).setOrders(orders);
                                  return ListView.separated(
                                    itemBuilder:  (context, index) => GestureDetector(
                                      onTap: () {
                                        if (orders[index].userNameID == Provider.of<UserProvider>(context, listen: false).user.uid) {
                                          showDialog(
                                            context: context,
                                            builder: (buildContext) {
                                              List<Order> orders =
                                                  Provider.of<OrderProvider>(context).orders;
                                              Order order = orders[index];
                                              return EditOrderDialog(order);
                                            },
                                          );
                                        }
                                      },
                                      child: Dismissible(
                                        key: ObjectKey(orders[index]),
                                        child: OrderCard(
                                          orderModel: orders[index],
                                          index: index,
                                        ),
                                        onDismissed: (direction) {
                                          var item = orders.elementAt(index);
                                          Provider.of<OrderProvider>(context, listen: false).deleteOrder(item, room);
                                          // ignore: deprecated_member_use
                                          Scaffold.of(context).showSnackBar(SnackBar(
                                              content: Text("Item deleted"),
                                              action: SnackBarAction(
                                                  label: "UNDO",
                                                  onPressed: () {
                                                    Provider.of<OrderProvider>(context, listen: false).addOrder(item, room);
                                                    Navigator.pop(context);
                                                  })));
                                        },
                                        background: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(8)),
                                            color:kRedColor,
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
                                            padding: EdgeInsets.all(sizeH * 2),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                Icon(Icons.delete, color: Colors.white),
                                                SizedBox(
                                                  width: sizeW *2,
                                                ),
                                                Text('Delete order', style: TextStyle(color: Colors.white)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    separatorBuilder: (context, index) => SizedBox(
                                      height: sizeH * 1,
                                    ),
                                    itemCount: orders != null ? orders.length : 0,
                                  );
                                }
                            }

                            // }
                        ),
                      ),
                      ),
                Container(
                  height: sizeH * 19,
                  decoration:
                      BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: Colors.white,
                      ),
                  child: Padding(
                    padding: EdgeInsets.all(sizeH * 1.5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: sizeW * 1),
                              child: Text(
                                'Total',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: sizeH * 3,
                                  color: kDarkGreyTextColor,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: sizeW * 2),
                              child: Text(
                                orders != null ? '${Provider.of<OrderProvider>(context).totalPrice().toStringAsFixed(2)} KN' : "0 KN",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: sizeH * 3,
                                  color: kDarkGreyTextColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(sizeH * 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child:
                                  GestureDetector(
                                    child: Container(
                                      decoration:
                                      BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                        color: kGreenColor,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(sizeH * 1.5),
                                        child: Text('Finish Order',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: sizeH * 2.5,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
        ),
      );
  }
}
