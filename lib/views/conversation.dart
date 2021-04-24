import 'package:bottle_chat/helper/constants.dart';
import 'package:bottle_chat/services/database.dart';
import 'package:bottle_chat/widgets/widget.dart';
import 'package:flutter/material.dart';
class ConversationsScreen extends StatefulWidget {
  final String chatRoomId;
  ConversationsScreen(this.chatRoomId);

  @override
  _ConversationsScreenState createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController writtenMessage = new TextEditingController();
  Stream chatMessageStream;
  Widget chatMessageList(){
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index){
            return MessageTile(snapshot.data.docs[index].get("message"),snapshot.data.docs[index].get("sendBy") == Constant.myEmail);
          }
        ) : CircularProgressIndicator();
      }
    );

  }
  sendMessage(){
    if(writtenMessage.text.isNotEmpty){
      Map<String, dynamic> messageMap = {
        "message":writtenMessage.text,
        "sendBy":Constant.myEmail,
        "time":DateTime.now().millisecond
      };
      databaseMethods.addConversations(widget.chatRoomId, messageMap);
      writtenMessage.text = "";
    }
  }
  @override
  void initState() {
    databaseMethods.getConversations(widget.chatRoomId).then((value){
      setState(() {
        chatMessageStream = value;
      });
    });
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Stack(
          children: [
            chatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                color: Color(0x54FFFFFF),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: writtenMessage,
                          decoration: InputDecoration(
                              hintText: "Message ...",
                              hintStyle: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                              ),
                          ),
                        )),
                    SizedBox(width: 16,),
                    GestureDetector(
                      onTap: () {
                        sendMessage();
                      },
                      child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    const Color(0x36FF2196F3),
                                    const Color(0x0FFF2196F3)
                                  ],
                                  begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.bottomRight
                              ),
                              borderRadius: BorderRadius.circular(40)
                          ),
                          padding: EdgeInsets.all(12),
                          child: Image.asset("assets/images/send.png",
                            height: 25, width: 25,)),
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
class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile(this.message, this.isSendByMe);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isSendByMe ? 0 : 20, right: isSendByMe ? 24 : 0),
      margin: EdgeInsets.symmetric(vertical: 9),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSendByMe ? [
              const Color(0xff007EF4),
              const Color(0xff2A75BC)
            ] : [
              const Color(0xFFCCCCFF),
              const Color(0xFFCCCCFF)
            ],
          ),
          borderRadius: isSendByMe ? BorderRadius.only(topLeft: Radius.circular(23),topRight: Radius.circular(23),bottomLeft: Radius.circular(23)) : BorderRadius.only(topLeft: Radius.circular(23),topRight: Radius.circular(23),bottomRight: Radius.circular(23))
        ),
        child: Text(message),
      ),
    );
  }
}
