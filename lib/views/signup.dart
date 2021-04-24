import 'package:bottle_chat/helper/sharedPrefHelper.dart';
import 'package:bottle_chat/services/auth.dart';
import 'package:bottle_chat/services/database.dart';
import 'package:bottle_chat/views/chatList.dart';
import 'package:bottle_chat/views/signin.dart';
import 'package:bottle_chat/widgets/widget.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController fname = new TextEditingController();
  TextEditingController lname = new TextEditingController();
  TextEditingController email = new TextEditingController();
  // TextEditingController phoneNumber = new TextEditingController();
  TextEditingController password = new TextEditingController();
  signUpClick(){
    Map<String, String> userInfo = {
      "name": (fname.text + " " + lname.text),
      "email":email.text,
    };
    HelperFunctions.saveUserNameKey((fname.text + " " + lname.text));
    HelperFunctions.saveUserEmailKey(email.text);
    if(formKey.currentState.validate()){
      setState(() {
        isLoading = true;
      });
    }
    authMethods.createUserWithEmailAndPassword(email.text, password.text).then((value) => {
      HelperFunctions.saveUserLoggedInKey(true),
      databaseMethods.uploadData(userInfo),
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatList()))
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
                        return value.isEmpty ? "First Name is required" : null;
                      },
                      controller: fname,
                      decoration: bottomBorderBlueOnFocus("First Name"),
                    ),
                    TextFormField(
                      validator: (value){
                        return value.isEmpty ? "Last Name is required" : null;
                      },
                      controller: lname,
                      decoration: bottomBorderBlueOnFocus("Last Name"),
                    ),
                    TextFormField(
                      validator: (value){
                        return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value) ?  null : "Email required in correct format";
                      },
                      controller: email,
                      decoration: bottomBorderBlueOnFocus("Email ID"),
                    ),
                    // TextFormField(
                    //   validator: (value){
                    //     return value.isEmpty ? "Phone Number is required" : null;
                    //   },
                    //   controller: phoneNumber,
                    //   decoration: bottomBorderBlueOnFocus("Phone Number"),
                    // ),
                    TextFormField(
                      obscureText: true,
                      validator: (value){
                        return (value.isEmpty || value.length < 6) ? "Password is required and should be minimum 6 characters" : null;
                      },
                      controller: password,
                      decoration: bottomBorderBlueOnFocus("Password"),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Container(
                alignment: Alignment.centerRight,
                child: Text("Forgot Password?"),
              ),
              SizedBox(height: 20,),
              GestureDetector(
                onTap: (){
                  signUpClick();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text("Sign Up",style: TextStyle(
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
                child: Text("Sign Up with Google",style: TextStyle(
                  color: Colors.black87,
                  fontSize: 17,
                ),),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already Registered? ",style: TextStyle(
                  color: Colors.black87,
                  fontSize: 17,
                ),),
                GestureDetector(
                  onTap: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignIn()));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text("Sign In",style: TextStyle(
                      color: Colors.black87,
                      fontSize: 17,
                      decoration: TextDecoration.underline,
                    ),),
                  ),
                )
                ]
              )
            ],
          ),
        ),
      ),
    );
  }
}
