import 'package:bottle_chat/helper/sharedPrefHelper.dart';
import 'package:bottle_chat/views/chatList.dart';
import 'package:bottle_chat/views/signin.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  bool isLoggedIn = false;
  getLoggedInStatus() async{
    await HelperFunctions.getUserLoogedInKey().then((value) => {
      setState((){
        isLoggedIn = value;
      })
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isLoggedIn ? ChatList() : SignIn(),
    );
  }
}
