import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:post/components/ScheduleCard.dart';
import 'package:post/utils/constants.dart';

class Upcoming extends StatefulWidget {
  const Upcoming({Key? key}) : super(key: key);

  @override
  _UpcomingState createState() => _UpcomingState();
}

class _UpcomingState extends State<Upcoming> {
  CollectionReference users =
      FirebaseFirestore.instance.collection('usersProfile');
  User? user = FirebaseAuth.instance.currentUser;
  late Query query;

  @override
  void initState() {
    Query profiles = users.where("accountId", isEqualTo: user!.uid);
    query = profiles;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Upcoming Schedule',
          style: TextStyle(color: kPrimaryDarkColor),
        ),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: 500,
          height: 500,
          child: StreamBuilder<QuerySnapshot>(
            stream: query.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              return new ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  print("data");
                  print(data);
                  return CardRow(
                    src: "https://moodforcode.com/assets/images/moodforcode.jpg",
                    time: "12.3.21",
                    content: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it",
                    press: () {
                      print(data);
                    },
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}
