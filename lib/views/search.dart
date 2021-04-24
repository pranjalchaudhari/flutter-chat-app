import 'package:bottle_chat/helper/constants.dart';
import 'package:bottle_chat/helper/sharedPrefHelper.dart';
import 'package:bottle_chat/services/database.dart';
import 'package:bottle_chat/views/conversation.dart';
import 'package:bottle_chat/widgets/widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchResults = new TextEditingController();
  QuerySnapshot searchSnapshot;
  initiateSearch(){
    databaseMethods.getUserByEmail(searchResults.text).then(
      (value) => {
        setState((){
          searchSnapshot = value;
        })
      }
    );
  }
  Widget SearchList(){
    return searchSnapshot != null ? ListView.builder(
        shrinkWrap: true,
        itemCount: searchSnapshot.docs.length,
        itemBuilder: (context,index){
          return SearchTile(
            name: searchSnapshot.docs[index].get("name"),
            email: searchSnapshot.docs[index].get("email"),
          );
        }) : Container();
  }
  createChatRoomAndStartCoversation(String searchedUser){
    List<String> users = [searchedUser,Constant.myEmail];
    String chatRoomId = getChatRoomId(searchedUser,Constant.myEmail);
    Map<String, dynamic> chatRoomUsers = {
      "users" : users,
      "chatRoomId" : chatRoomId,
    };
    databaseMethods.createChatRoom(chatRoomId, chatRoomUsers);
    Navigator.push(context, MaterialPageRoute(builder: (context)=> ConversationsScreen(chatRoomId)));
  }
  Widget SearchTile({String name,String email}){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name),
              Text(email),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: ()=> createChatRoomAndStartCoversation(email),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
              child: Text("Connect", style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),),
            ),
          )
        ],
      ),
    );
  }
  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
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
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                        controller: searchResults,
                        decoration: InputDecoration(
                          hintText: "Search user",
                        ),
                      )
                  ),
                  GestureDetector(
                    onTap: (){
                      initiateSearch();
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        child: Icon(Icons.search)
                    ),
                  )
                ],
              ),
            ),
            SearchList(),
          ],
        ),
      ),
    );
  }
}