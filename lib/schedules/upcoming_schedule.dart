import 'package:flutter/material.dart';

class Upcoming extends StatefulWidget {
  const Upcoming(
      {Key? key,
      required this.title,
      required this.postdate,
      required this.posttime,
      required this.postimage})
      : super(key: key);

  final String title;
  final String postdate;
  final String posttime;
  final String postimage;

  @override
  _UpcomingState createState() => _UpcomingState();
}

class _UpcomingState extends State<Upcoming> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Upcoming Sedules',
          style: TextStyle(
              color: Colors.grey, fontSize: 25.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20.0, right: 20.0),
          child: Card(
            color: Colors.grey[50],
            elevation: 0,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${widget.postdate}",
                  style: TextStyle(fontSize: 16.0, color: Colors.black),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Container(
                    width: 60,
                    child: Text(
                      "${widget.posttime}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                      style: TextStyle(fontSize: 14.0, color: Colors.grey),
                    )),
                SizedBox(
                  width: 10,
                ),
                Card(
                  color: Colors.grey[50],
                  elevation: 3,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                              height: 70,
                              width: 70,
                              alignment: Alignment.centerLeft,
                              child: Image(
                                image: AssetImage('assets/user.jpg'),
                                fit: BoxFit.fill,
                              )),
                        ),
                        Container(
                          width: 230,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 2.0, top: 10.0, bottom: 10.0, right: 2.0),
                            child: Text(
                              "${widget.title}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 8,
                            ),
                          ),
                        )
                      ]),
                )
              ])
            ]),
          ),
        ),
      ),
    );
  }
}
