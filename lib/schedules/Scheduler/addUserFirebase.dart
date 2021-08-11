import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddUser extends StatefulWidget {
  @override
  _AddUserState createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {
  dynamic isTrueorFalse;

  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('users')
      .where("boolean", isEqualTo: "1")
      .snapshots();

  Widget build(BuildContext context) {
    String? fullName;
    String? company;
    int? age;
    String documentId = "O5bo8kardCBMtF9LbZoa";
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    Future<void> addUser() {
      return users
          .add({
            'first_name': "sharmi",
            'email': "m4c",
            'short_token': 21,
            'long_token': "token",
            'boolean': "1"
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    return SafeArea(
      child: Column(
        children: [
          TextButton(
            onPressed: addUser,
            child: Text(
              "Add User",
            ),
          ),
          Container(
            width: 500,
            height: 500,
            child: StreamBuilder<QuerySnapshot>(
              stream: _usersStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Text("Loading"));
                }

                return new ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    print("data");
                    print(data);
                    return GestureDetector(
                      onTap: () {
                        print(data);
                      },
                      child: new ListTile(
                        title: new Text(data['firstName']),
                        subtitle: new Text(data['lastName']),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          )
        ],
      ),
    );

    // return StreamBuilder<QuerySnapshot>(
    //   stream: _usersStream,
    //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    //     if (snapshot.hasError) {
    //       return Text('Something went wrong');
    //     }

    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return Text("Loading");
    //     }

    //     return new ListView(
    //       children: snapshot.data!.docs.map((DocumentSnapshot document) {
    //         Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    //         print("data");
    //         print(data);
    //         return new ListTile(
    //           title: new Text(data['full_name']),
    //           subtitle: new Text(data['company']),
    //         );
    //       }).toList(),
    //     );
    //   },
    // );

    // return SafeArea(
    //   child: FutureBuilder<DocumentSnapshot>(
    //     future: users.doc(documentId).get(),
    //     builder:
    //         (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    //       if (snapshot.hasError) {
    //         return Text("Something went wrong");
    //       }

    //       if (snapshot.hasData && !snapshot.data!.exists) {
    //         return Text("Document does not exist");
    //       }

    //       if (snapshot.connectionState == ConnectionState.done) {
    //         Map<String, dynamic> data =
    //             snapshot.data!.data() as Map<String, dynamic>;
    //         return Text("Full Name: ${data['full_name']} ${data['company']}");
    //       }

    //       return Text("loading");
    //     },
    //   ),
    // );
  }
}
