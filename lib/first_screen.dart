import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/Screens/google_sign_in.dart';
// import 'package:firebase/Screens/login_screen.dart';
import 'package:firebase/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirstScreen extends StatelessWidget {
  // final FirebaseAuth auth = FirebaseAuth.instance;
  // final FirebaseUser user = await auth.currentUser!;
  // getCurrentUser() async {
  //   var user = FirebaseAuth.instance.currentUser;
  //   print(user!.email);
  //   print(user.displayName);
  //   print(user.metadata);
  //   print(user);
  // }

  Future getMydata() async {
    var collection = FirebaseFirestore.instance.collection('UserData');
    var userData = await collection.get();
    for (var querySnapshot in userData.docs) {
      Map<String, dynamic> data = querySnapshot.data();
      var name = data['name'];
      var image = data['image'];
      print(name);
      print(image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Good to go"),
      ),
      body: Container(
        child: Row(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('UserData')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    // print(snapshot.data!.docs.map.toString());
                    // var getdata = getCurrentUser();
                    // print(getdata);
                    // print(phone);
                    getMydata();
                    print("---------------------");

                    return ListView(
                      children: snapshot.data!.docs.map((document1) {
                        return Container(
                            child: Center(child: Text(document1['name'])
                                // Image.network(document1['image'])
                                ));
                      }).toList(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// // import 'package:chat_app/Authenticate/Methods.dart';
// // import 'package:chat_app/Screens/ChatRoom.dart';
// // import 'package:chat_app/group_chats/group_chat_screen.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase/Screens/google_sign_in.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class FirstScreen extends StatefulWidget {
//   @override
//   _FirstScreenState createState() => _FirstScreenState();
// }

// class _FirstScreenState extends State<FirstScreen> with WidgetsBindingObserver {
//   Map<String, dynamic>? userMap;
//   bool isLoading = false;
//   final TextEditingController _search = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance!.addObserver(this);
//     setStatus("Online");
//   }

//   void setStatus(String status) async {
//     await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
//       "status": status,
//     });
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       // online
//       setStatus("Online");
//     } else {
//       // offline
//       setStatus("Offline");
//     }
//   }

//   String chatRoomId(String user1, String user2) {
//     if (user1[0].toLowerCase().codeUnits[0] >
//         user2.toLowerCase().codeUnits[0]) {
//       return "$user1$user2";
//     } else {
//       return "$user2$user1";
//     }
//   }

//   void onSearch() async {
//     FirebaseFirestore _firestore = FirebaseFirestore.instance;

//     setState(() {
//       isLoading = true;
//     });

//     await _firestore
//         .collection('users')
//         .where("email", isEqualTo: _search.text)
//         .get()
//         .then((value) {
//       setState(() {
//         userMap = value.docs[0].data();
//         isLoading = false;
//       });
//       print(userMap);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Home Screen"),
//         actions: [
//           IconButton(icon: Icon(Icons.logout), onPressed: () => signOutGoogle())
//         ],
//       ),
//       body: isLoading
//           ? Center(
//               child: Container(
//                 height: size.height / 20,
//                 width: size.height / 20,
//                 child: CircularProgressIndicator(),
//               ),
//             )
//           : Column(
//               children: [
//                 SizedBox(
//                   height: size.height / 20,
//                 ),
//                 Container(
//                   height: size.height / 14,
//                   width: size.width,
//                   alignment: Alignment.center,
//                   child: Container(
//                     height: size.height / 14,
//                     width: size.width / 1.15,
//                     child: TextField(
//                       controller: _search,
//                       decoration: InputDecoration(
//                         hintText: "Search",
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(
//                   height: size.height / 50,
//                 ),
//                 ElevatedButton(
//                   onPressed: onSearch,
//                   child: Text("Search"),
//                 ),
//                 SizedBox(
//                   height: size.height / 30,
//                 ),
//                 userMap != null
//                     ? ListTile(
//                         onTap: () {
//                           String roomId = chatRoomId(
//                               _auth.currentUser!.displayName!,
//                               userMap!['name']);
//                         },
//                         leading: Icon(Icons.account_box, color: Colors.black),
//                         title: Text(
//                           userMap!['name'],
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 17,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         subtitle: Text(userMap!['email']),
//                         trailing: Icon(Icons.chat, color: Colors.black),
//                       )
//                     : Container(),
//               ],
//             ),
//     );
//   }
// }
