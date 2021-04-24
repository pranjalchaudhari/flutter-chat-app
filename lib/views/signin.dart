import 'package:bottle_chat/helper/sharedPrefHelper.dart';
import 'package:bottle_chat/services/auth.dart';
import 'package:bottle_chat/services/database.dart';
import 'package:bottle_chat/views/chatList.dart';
import 'package:bottle_chat/views/signup.dart';
import 'package:bottle_chat/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  QuerySnapshot snapshotUserInfo;
  signInClick(){
    if(formKey.currentState.validate()){
      HelperFunctions.saveUserEmailKey(email.text);
      setState(() {
        isLoading = true;
      });
    }
    databaseMethods.getUserByEmail(email.text).then((value)=>{
      snapshotUserInfo = value,
      HelperFunctions.saveUserNameKey(snapshotUserInfo.docs[0].get("name"))
    });
    authMethods.signInWithEmailAndPassword(email.text, password.text).then((value) => {
      if(value != null){
        HelperFunctions.saveUserLoggedInKey(true),
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatList()))
      }
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading ? Container(
        child: Center(child: CircularProgressIndicator()),
      ) : SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Form(
                key: formKey,
                child: Column(
                 children: [
                   TextFormField(
                     validator: (value){
                       return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value) ?  null : "Email required in correct format";
                     },
                     controller: email,
                     decoration: bottomBorderBlueOnFocus("Email ID"),
                   ),
                   TextFormField(
                     obscureText: true,
                     validator: (value){
                       return (value.isEmpty || value.length < 6) ? "Password is required and should be minimum 6 characters" : null;
                     },
                     controller: password,
                     decoration: bottomBorderBlueOnFocus("Password"),
                   ),
                ],
              )),
              SizedBox(height: 20,),
              Container(
                alignment: Alignment.centerRight,
                child: Text("Forgot Password?"),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  signInClick();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text("Sign In",style: TextStyle(
                    color: Colors.white70,
                    fontSize: 17,
                  ),),
                ),
              ),
              SizedBox(height: 15,),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Color(0xffFFA3DBF5),
                  borderRadius: BorderRadius.circular(30)
                ),
                child: Text("Sign In with Google",style: TextStyle(
                  color: Colors.black87,
                  fontSize: 17,
                ),),
              ),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have account? ",style: TextStyle(
                    color: Colors.black87,
                    fontSize: 17,
                  ),),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignUp()));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text("Register Now",style: TextStyle(
                        color: Colors.black87,
                        fontSize: 17,
                        decoration: TextDecoration.underline,
                      ),),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

onPressed(){

}
