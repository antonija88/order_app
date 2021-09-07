import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:order_app/models/user_model.dart';
import 'package:order_app/providers/order_provider.dart';
import 'package:order_app/providers/rooms_provider.dart';
import 'package:order_app/providers/user_provider.dart';
import 'package:order_app/screens/sign_in.dart';
import 'package:order_app/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:order_app/screens/edit_profile_item.dart';
import 'package:order_app/screens/room_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/sing_up.dart';
import 'screens/welcome_screen.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => OrderProvider()),
        ChangeNotifierProvider(create: (ctx) => UserProvider()),
        ChangeNotifierProvider(create: (ctx) => RoomsProvider()),
        StreamProvider<List<UserModel>>(create: (context) => streamOfUsers(), initialData: [])
      ],

      child: MaterialApp(
        theme: ThemeData(visualDensity: VisualDensity.adaptivePlatformDensity, fontFamily: "Rubik"),
        home: WelcomeScreen(),
        routes: {
          WelcomeScreen.routName: (context) => WelcomeScreen(),
          SignInScreen.routName: (context) => SignInScreen(),
          SingUp.routName: (context) => SingUp(),
          HomeScreen.routName: (context) => HomeScreen(),
          EditProfileItemDialog.routName: (context) => EditProfileItemDialog(),
          RoomScreen.routName: (context) => RoomScreen(),
        },
      ),
    );
  }

  Stream<List<UserModel>> streamOfUsers() {
    var ref = FirebaseFirestore.instance.collection('users');
    return ref.snapshots().map((list) => list.docs.map((doc) => UserModel.fromFirestore(doc)).toList());
  }
}
