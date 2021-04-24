import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{
  getUserByEmail(String email){
    return FirebaseFirestore.instance.collection("users").where("email", isEqualTo: email).get();
  }
  uploadData(userData){
    FirebaseFirestore.instance.collection("users").add(userData);
  }
  createChatRoom(String chatRoomId, chatRoomUsers){
    FirebaseFirestore.instance.collection("chatRooms").doc(chatRoomId).set(chatRoomUsers).catchError((e){
      print(e.toString());
    });
  }
  addConversations(chatRoomId, messageMap){
    FirebaseFirestore.instance.collection("chatRooms").doc(chatRoomId).collection("chats").add(messageMap).catchError((e){print(e.toString());});
  }
  getConversations(chatRoomId) async{
    return await FirebaseFirestore.instance.collection("chatRooms").doc(chatRoomId).collection("chats").orderBy("time",descending: true).snapshots();
  }
  getChatRooms(String userEmail) async{
    return await FirebaseFirestore.instance.collection("chatRooms").where("users", arrayContains: userEmail).snapshots();
  }
}