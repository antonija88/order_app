import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:order_app/constants.dart';
import 'package:order_app/models/user_model.dart';
import 'package:order_app/providers/user_provider.dart';
import 'package:order_app/widgets/add_room_dialog.dart';
import 'package:order_app/screens/edit_profile_item.dart';
import 'package:order_app/screens/sign_in.dart';
import 'package:order_app/utility/size_config.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:order_app/api/firebase_api.dart';
import 'package:order_app/providers/rooms_provider.dart';
import 'package:order_app/models/room.dart';
import 'package:order_app/screens/room_screen.dart';
import 'package:order_app/components/room_card.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  static const String routName = 'home_screen';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  String imageUrl;

  @override
  void initState() {
    FirebaseApi.getUser(FirebaseAuth.instance.currentUser.uid).then((value) {
      setState(() {
        Provider.of<UserProvider>(context, listen: false).user = value;
      });
    });
    super.initState();
  }

  // final picker = ImagePicker();
  //
  // Future pickImage() async {
  //   final pickedFile = await picker.getImage(source: ImageSource.gallery);
  //
  //   setState(() {
  //     _imageFile = pickedFile;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();
    SizeConfig().init(context);
    double sizeH = SizeConfig.safeBlockVertical;
    double sizeW = SizeConfig.safeBlockHorizontal;
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: kBackgroundColor,
        endDrawer: Drawer(
            child: ListView(
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                      DrawerHeader(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 0.01),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(sizeH * 1.5),
                              child: Text('Order App',
                              style: TextStyle(
                                fontSize: sizeH * 3.5,
                                color: kDarkGreyTextColor,
                                fontWeight: FontWeight.bold,
                              ),),
                            ),
                            SizedBox(
                              height: sizeH * 4,
                            ),
                            Container(
                              padding: EdgeInsets.all(sizeH * 1),
                              child: Text(
                                'Version 0.1.1',
                                style: TextStyle(fontSize: sizeH * 2.5, fontWeight: FontWeight.normal,
                                    color: Colors.white),
                              ),
                              decoration: BoxDecoration(
                                color: kLightGreyColor,
                                border: Border.all(
                                  color: kLightGreyColor,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListTile(
                        title: Text('Favourites',
                          style: TextStyle(
                            fontSize: sizeH * 3,
                            color: kDarkGreyTextColor,
                            fontWeight: FontWeight.w300),),
                        onTap: () {
                          // Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: Text('Cart',
                          style: TextStyle(
                            fontSize: sizeH * 3,
                              color: kDarkGreyTextColor,
                              fontWeight: FontWeight.w300
                          ),),
                        onTap: () {
                          // Navigator.pop(context);
                        },
                       ),
                        ListTile(
                          title: Text('Menu',
                            style: TextStyle(
                              fontSize: sizeH * 3,
                                color: kDarkGreyTextColor,
                                fontWeight: FontWeight.w300
                            ),),
                          onTap: () {
                            // Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: Text('About',
                            style: TextStyle(
                              fontSize: sizeH * 3,
                                color: kDarkGreyTextColor,
                                fontWeight: FontWeight.w300
                            ),),
                          onTap: () {
                            // Navigator.pop(context);
                          },
                        ),
                        Divider(
                          height: sizeH * 1,
                          indent: sizeH * 2.5,
                        ),
                        SizedBox(
                          height: sizeH * 4,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: sizeH * 2.5),
                          child: Text('${user.username}',
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                              fontSize: sizeH * 2,
                                color: kDarkGreyTextColor,
                                fontWeight: FontWeight.w300,
                          ),
                          ),
                        ),
                        SizedBox(
                          height: sizeH * 4,
                        ),
                        Padding(
                          padding:  EdgeInsets.symmetric(horizontal: sizeW * 2.5),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  onTap: () {
                                    FirebaseApi.logout().then((value) {
                                      Navigator.pushReplacementNamed(context, SignInScreen.routName);
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(sizeH * 1),
                                    child: Text(
                                      'LOG OUT',
                                      style: TextStyle(fontSize: sizeH * 1.5, fontWeight: FontWeight.normal,
                                          color: Colors.white),
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black,
                                      border: Border.all(
                                        color: Colors.black,
                                      ),
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 3,
                                  child: SizedBox(
                                width: sizeW * 7,
                              ))
                            ],
                          ),
                        ),
                      ],
                    ),
        ),
      body: _selectedIndex == 0
          ?
          Padding(
            padding: EdgeInsets.all(sizeH * 2),
            child: Column(
              children: [
                 Container(
                   color: kBackgroundColor,
                   child: SafeArea(
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Image.asset("assets/images/Group.png", height: sizeH * 4,),
                         Text('Home',
                           style: TextStyle(color: kDarkGreyTextColor,
                               fontSize: sizeH * 3),
                         ),
                         GestureDetector(
                             onTap: () {
                               scaffoldKey.currentState.openEndDrawer();
                             },
                             child: Image.asset("assets/images/menu_icon.png", height: sizeH * 3,)),
                       ],
                     ),
                   ),
                 ),
                SizedBox(
                  height: sizeH * 2,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (buildContext) {
                            return AddRoomDialog();
                          },
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: sizeH *1, bottom: sizeH * 1.5),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          decoration:
                          BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: kGreenColor,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(sizeH * 1),
                            child: Text('Add Restaurant',
                              style: TextStyle(
                                color: Colors.white,
                              ),),
                          ),
                        ),
                      ),
                    ),
                    // Expanded(child: SizedBox())
                  ],
                ),
                Expanded(
                  child: Container(
                    child: StreamBuilder(
                        stream: FirebaseApi.readRooms(),
                        builder: (context, snapshot) {
                          switch (snapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Center(child: CircularProgressIndicator());
                            default:
                              if (snapshot.hasError) {
                                return Text('Something Went Wrong Try later');
                              } else {
                                List<Room> rooms = snapshot.data;
                                final provider = Provider.of<RoomsProvider>(context);
                                provider.setRooms(rooms);
                                if (rooms.length == 0) {
                                  return Center(child: Text("No Restaurant"),);
                                }
                                return GridView.builder(
                                  padding: EdgeInsets.only(top: sizeH * 2),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: sizeH * 2,
                                      mainAxisSpacing: sizeH * 2,
                                      childAspectRatio:  MediaQuery.of(context).size.width /
                                          (MediaQuery.of(context).size.height / 1.6),
                                  ),
                                  itemCount: rooms.length,
                                  itemBuilder: (context, index) {
                                    final room = rooms[index];
                                    return GestureDetector(
                                        onTap: () {
                                          Provider.of<RoomsProvider>(context, listen: false)
                                              .setRoom(room);
                                          Navigator.pushNamed(
                                              context, RoomScreen.routName);
                                        },
                                        child: RoomCard(room: room));
                                  },
                                );
                              }
                          }
                        }),
                  ),
                ),
              ],
            ),
          )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              Container(
                  color: kBackgroundColor,
                  child: Padding(
                  padding: EdgeInsets.all(sizeH * 2),
                    child: SafeArea(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Image.asset("assets/images/Group.png", height: sizeH * 4),
                        Text('Profile',
                        style: TextStyle(color: kDarkGreyTextColor,
                        fontSize: sizeH * 3),
                        ),
                        GestureDetector(
                        onTap: () {
                          scaffoldKey.currentState.openEndDrawer();
                          },
                        child: Image.asset("assets/images/menu_icon.png", height: sizeH * 3,)),
                        ],
                      ),
                    ),
                  ),
                  ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                            CircleAvatar(
                            radius: 80.0,
                              backgroundColor: Colors.white,
                              child: (user.profileImage != null)
                                  ? Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: Image.network(user.profileImage).image,//Selected Image
                                      fit: BoxFit.fill),
                                ),
                              ) :
                              Image.network('https://www.materialui.co/materialIcons/image/add_a_photo_black_36x36.png',//Default Picture
                                fit: BoxFit.fill),
                              ),
                              SizedBox(
                                      height: sizeH * 5,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        uploadImage(user.uid);
                                      },
                                      child: Text('Change Profile Picture',
                                        style: TextStyle(color: kDarkGreyTextColor,
                                            fontWeight: FontWeight.w300,
                                            fontSize: sizeH * 2.5),
                                      ),
                                    ),
                        ],
                      ),

                      Padding(
                          padding: EdgeInsets.symmetric(vertical: sizeH * 2),
                          child: Column(
                            children: [
                              user.username != null ? Text(user.username) : Text('username'),
                              SizedBox(
                                height: sizeH * 3,
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => EditProfileItemDialog());
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: kRedColor,
                                      border: Border.all(color: kRedColor),
                                      borderRadius: BorderRadius.all(Radius.circular(20.0))
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(sizeH * 2),
                                    child: Text('Edit Profile',
                                      style: TextStyle(color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                          fontSize: sizeH * 2.5),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ),
                    ],
                  ),
                )
              ],
            ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(width: 0.1)),
          boxShadow:  [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
      ),
        height: sizeH * 15,
        child: BottomNavigationBar(
          selectedItemColor: kDarkGreyTextColor,
          unselectedItemColor: kGreyTextColor,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home,
                    color:
                        _selectedIndex == 0 ? kDarkGreyTextColor : kGreyTextColor),
                label: 'HOME'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person,
                    color:
                        _selectedIndex == 1 ? kDarkGreyTextColor : kGreyTextColor),
                label: 'PROFILE'),
          ],
          backgroundColor: Colors.white,
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() {
            _selectedIndex = index;
          }),
        ),
      ),
    );
  }
  uploadImage(String userId) async {
    final _storage = FirebaseStorage.instance;
    final _picker = ImagePicker();
    var file;

    await Permission.photos.request();

   var permissionStatus = await Permission.photos.status;

   if (permissionStatus.isGranted) {
    _picker.getImage(source: ImageSource.gallery).then((value) async {
      file = File(value.path);
      final UploadTask uploadTask = _storage.ref().child('profileImages/${userId}profileImage').putFile(file);

      final TaskSnapshot downloadUrl = (await uploadTask.whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')))));

      final String url = await downloadUrl.ref.getDownloadURL().then((value) {
        setState(() {
        Provider.of<UserProvider>(context, listen: false).user.profileImage = value;
        });
        UserModel user = Provider.of<UserProvider>(context, listen: false).user;
        FirebaseApi.updateUserData(user).then((value) {
        setState(() {

        });
      });

      return imageUrl;
      });
    });

    }  else {
     print('Grant permissions and try again');
   }


  }
}
