import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_flutter/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

final fireStore = FirebaseFirestore.instance;
User? loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;

  String messageText = '';
  final messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentuser();
  }

  void getCurrentuser() {
    final user = _auth.currentUser;
    try {
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser!.email);
      }
    } catch (e) {
      print(e);
    }
  }

  // void getMessages() async {
  //   final messages = await fireStore.collection('messages').get();
  //   for (var message in messages.docs) {
  //     print(message.data());
  //   }
  // }

  void messagesStream() async {
    await for (var snapshot in fireStore.collection('messages').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _auth.signOut();
              Navigator.pop(context);
              //Implement logout functionality
            },
          ),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      messageController.clear();
                      fireStore.collection('messages').add(
                        {
                          'sender': loggedInUser!.email,
                          'text': messageText,
                        },
                      );
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  const MessageStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: fireStore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data!.docs!.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.data();
          final messageSender = message.data();
          final currentUser = loggedInUser!.email;
          final messageBubble = MessageBubble(messageText, messageSender, currentUser == messageSender);
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(reverse: true,
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble(this.text, this.sender,this.isMe);

  final text;
  final sender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(crossAxisAlignment: isMe? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text('$sender'),
          Material(
            color: isMe ? Colors.blueAccent : Colors.blueGrey,
            borderRadius: isMe? BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(0),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30)
            ): BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30)
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                '$text',
                style: TextStyle(fontSize: 12,),
              ),
            ),
          ),
        ],
      ),
    );
    ;
  }
}
