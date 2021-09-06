import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:post/components/ScheduleCard.dart';
import 'package:post/utils/constants.dart';

class PastSchedule extends StatefulWidget {
  const PastSchedule({Key? key}) : super(key: key);

  @override
  _PastScheduleState createState() => _PastScheduleState();
}

class _PastScheduleState extends State<PastSchedule> {
  CollectionReference users = FirebaseFirestore.instance.collection('posts');
  User? user = FirebaseAuth.instance.currentUser;
  late Query query;

  @override
  void initState() {
    Query profiles = users.where("userId", isEqualTo: user!.uid);
    //.where("dateTime", isLessThan: DateTime.now());
    query = profiles;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Past Schedule',
          style: TextStyle(color: kPrimaryDarkColor),
        ),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: 500,
          height: MediaQuery.of(context).size.height,
          child: StreamBuilder<QuerySnapshot>(
            stream: query.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                  return Padding(
                  padding: const EdgeInsets.only(top: 300),
                  child: Column(
                    children: [
                      CupertinoActivityIndicator(),
                    ],
                  ),
                );
              }

              if (snapshot.data!.docs.length != 0) {
                return new ListView(
                    children: snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      DateTime _timestamp = data['dateTime'].toDate();
                      var d12 = DateFormat('dd/MM/yy').format(_timestamp);

                      return CardRow(
                        src: data["_uploadedFileURL"],
                        time: d12.toString(),
                        content: data["message"],
                        press: () {
                          print(data);
                        },
                      );
                    }).toList(),
                  );
              }
              return Padding(
                padding: const EdgeInsets.only(top: 300),
                child: Column(
                  children: [
                    Text("No data available"),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
