import 'package:bottle_chat/helper/constants.dart';
import 'package:bottle_chat/helper/sharedPrefHelper.dart';
import 'package:bottle_chat/services/auth.dart';
import 'package:bottle_chat/services/database.dart';
import 'package:bottle_chat/views/conversation.dart';
import 'package:bottle_chat/views/signin.dart';
import 'package:bottle_chat/views/search.dart';
import 'package:flutter/material.dart';
class ChatList extends StatefulWidget {
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomsStream;
  Widget chatRoomList(){
    return StreamBuilder(
      stream: chatRoomsStream,
      builder: (context, snapshot){
        return (snapshot.hasData && snapshot.data.docs[0].get("chatRoomId").toString().contains(Constant.myEmail)) ? ListView.builder(
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context,index){
              return ChatRoomsTile(
                snapshot.data.docs[index].get("chatRoomId").toString().replaceAll("_", "").replaceAll(Constant.myEmail, "").split("@")[0],
                  snapshot.data.docs[index].get("chatRoomId")
              );
            }) : Container();
      },
    );
  }
  @override
  void initState() {
    getUserInfo();
    databaseMethods.getChatRooms(Constant.myEmail).then((value){
      setState(() {
        chatRoomsStream = value;
      });
    });
    // TODO: implement initState
    super.initState();
  }
  
  getUserInfo() async{
    Constant.myEmail =  await HelperFunctions.getUserEmailKey();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/logo.png",height: 30,),
        actions: [
          GestureDetector(
            onTap: (){
              authMethods.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignIn()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
      ),

    );
  }
}
class ChatRoomsTile extends StatelessWidget {
  final String displayName;
  final String chatRoomId;
  ChatRoomsTile(this.displayName,this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> ConversationsScreen(chatRoomId))),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text("${displayName.substring(0,1).toUpperCase()}"),
            ),
            SizedBox(width: 8,),
            Text(displayName),
          ],
        ),
      ),
    );
  }
}
