import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:post/home/home.dart';

import 'package:post/schedules/scheduler/calendar.dart';
import 'package:post/schedules/paymentPlan.dart';
import 'package:post/schedules/upcoming_schedule.dart';

import 'package:post/utils/constants.dart';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as dio;
import 'package:post/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:path/path.dart' as Path;

//const AD_ACCOUNT_ID = '1814755458831738';
//const ACCESS_TOKEN =
//'EAAFkm83HxkoBALFCK9DZBpXwpqxk6l9nMAUXYw7o0DlpCDNfGxodAzVEIl4t4WZAButavVKxafFmnplq3SOx1pf0pZCRrgQpwzcMxXzWHuiJbMjq9FV4lasT2ZAAVtz0N7rX93902rFWj5kntCjrIuhAmhz1JQKsJmks8QOguRF7d1sZCa3OQeDMHZCK2y9ZCGrqrg9PUllJHWVWjZADZCYfI';

class NewSchedule extends StatefulWidget {
  NewSchedule({
    Key? key,
    required this.title,
    required this.date,
    required this.date2,
    required this.time,
  }) : super(key: key);

  final String title;
  final String date;
  final String date2;
  final String time;

  @override
  _NewScheduleState createState() => _NewScheduleState();
}

class _NewScheduleState extends State<NewSchedule> {
  final myTextController = TextEditingController();

  bool isSwitched = false;
  bool isSwitchedfb = false;
  bool isSwitchedtwitter = false;
  String text = "";
  String description = "";
  var _currentIndex = 1;

  @override
  void dispose() {
    myTextController.dispose();
    super.dispose();
  }

  // Single Image Picker - From Camera / Gallery

  File? _image;
  String? _uploadedFileURL;

  final List<Map<String, dynamic>> _allUsers = [
    {"id": 1, "name": "Andy", "age": 29},
    {"id": 2, "name": "Aragon", "age": 40},
    {"id": 3, "name": "Bob", "age": 5},
    {"id": 4, "name": "Barbara", "age": 35},
    {"id": 5, "name": "Candy", "age": 21},
    {"id": 6, "name": "Colin", "age": 55},
    {"id": 7, "name": "Audra", "age": 30},
    {"id": 8, "name": "Banana", "age": 14},
    {"id": 9, "name": "Caversky", "age": 100},
    {"id": 10, "name": "Becky", "age": 32},
  ];

  // _imgFromCamera() async {
  //   PickedFile? image = await ImagePicker()
  //       .getImage(source: ImageSource.camera, imageQuality: 50);

  //   setState(() {
  //     _image = image;
  //     //uploadFile();
  //   });
  // }

  // _imgFromGallery() async {
  //   File image = (await ImagePicker.pickImage(
  //       source: ImageSource.gallery, imageQuality: 50));

  //   setState(() {
  //     _image = image;
  //     // uploadFile();
  //     print("image picker name : ...................");
  //     print(_image);
  //   });
  // }

  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 50
            // maxWidth: 1800,
            // maxHeight: 1800,
            );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50
            // maxWidth: 1800,
            // maxHeight: 1800,
            );
    if (pickedFile != null) {
      setState(() {
        // _image = image;
        _image = File(pickedFile.path);
      });
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      title: new Text('Photo Library'),
                      trailing: new Icon(Icons.photo_library),
                      onTap: () {
                        _getFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    title: new Text('Take Photo'),
                    trailing: new Icon(Icons.photo_camera),
                    onTap: () {
                      _getFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                  Divider(),
                  new ListTile(
                    shape: Border.all(
                        color: Colors.grey, width: 10, style: BorderStyle.solid),
                    title: new Text(
                      'Cancel',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

// multi image picker
  List<Asset> images = [];
  String? _error = 'Pick your images';

  Widget buildGridView() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 15,
        ),
        FloatingActionButton(
          splashColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          elevation: 0,
          onPressed: () {
            loadAssets();
          },
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(100.0)),
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
                // stops: [0.3, 0.3, 0.7, 0.1, 1],
                colors: [
                  Color(0xFFFFE0B2),
                  Color(0xFFFFB74D),
                  Color(0xFFE040FB),
                  Color(0xFFBA68C8),
                  Color(0xFF7E57C2),
                ],
              ),
            ),
            padding: const EdgeInsets.all(13.0),
            child: Icon(
              Icons.camera_alt,
              size: 26.0,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          width: 15,
        ),
        Flexible(
          child: GridView.count(
            scrollDirection: Axis.horizontal,
            crossAxisCount: 1,
            children: List.generate(images.length, (index) {
              Asset asset = images[index];
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: AssetThumb(
                  asset: asset,
                  width: 700,
                  height: 700,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = [];
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          // actionBarColor: "#B200B5",
          actionBarTitle: "Quick Post",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    var ola = DateTime.now();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () =>    Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Home();
                            },
                          ),
          )
        ),
        centerTitle: true,
        title: Text(
          'New Schedule',
          style: TextStyle(color: kPrimaryDarkColor, fontSize: 18),
        ),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
        actions: [
          Center(
            child: GestureDetector(
              onTap: () {
                print(ola);
                description = myTextController.text;
                //createCampaign(description);

                print(myTextController.text);
                // Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (context) {
                //               return UpComingSchedule();
                //             },
                //           ),
                //         );

                // var route = new MaterialPageRoute(
                //   builder: (BuildContext context) => new Upcoming(
                //     postdate: "${widget.date2}",
                //     posttime: "${widget.time}",
                //     postimage: _image.toString(),
                //     title: myTextController.text,
                //   ),
                // );
                // Navigator.of(context).push(route);
              },
              child: Text(
                "Post",
                style: TextStyle(color: Colors.blue, fontSize: 18),
              ),
            ),
          ),
          SizedBox(
            width: size.width * (1 / 20),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            // multi image picker
            // Container(
            //   height: 200,
            //   child: buildGridView(),
            // ),

            // single image picker
            Center(
              child: GestureDetector(
                onTap: () {
                  _showPicker(context);
                },
                child: Container(
                  child: _image != null
                      ? ClipRRect(
                          // borderRadius: BorderRadius.circular(5),
                          child: Image.file(
                            _image!,
                            width: size.width * (16 / 20),
                            height: size.width * (16 / 20),
                            fit: BoxFit.fitHeight,
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            // borderRadius: BorderRadius.circular(50)
                          ),
                          width: size.width * (16 / 20),
                          height: size.width * (16 / 20),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.grey[400],
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              //     padding: EdgeInsets.symmetric(
              //       horizontal: size.width * (1 / 20),
              //      ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 14, top: 7, right: 14, bottom: 14),
                    child: TextFormField(
                      controller: myTextController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: "Description",
                        labelStyle: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  ListTile(
                    title: new Text('Tag People'),
                    trailing: new Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      print("Tag People Clicked........!");
                    },
                  ),
                  ListTile(
                      title: new Text('Select Page'),
                      trailing: new Icon(Icons.keyboard_arrow_right),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return AlertDialog(
                                    title: Center(
                                        child: Text(
                                      'Available Pages',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Poppins"),
                                    )),
                                    actions: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Container(
                                          width: 100,
                                          height: 30,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 15),
                                          decoration: new BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(35.0),
                                            gradient: new LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Color(0xFFFFE0B2),
                                                Color(0xFFFFB74D),
                                                Color(0xFFE040FB),
                                                Color(0xFFBA68C8),
                                                Color(0xFF7E57C2),
                                              ],
                                            ),
                                          ),
                                          child: new FlatButton(
                                              // color: Colors.orange[600],
                                              onPressed: () {
                                                Navigator.of(context).pop(true);
                                                print("exit");
                                              },
                                              child: const Text(
                                                "Ok",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )),
                                        ),
                                      ),

                                      // FlatButton(
                                      //   onPressed: () {
                                      //     Navigator.pop(context, null);
                                      //   },
                                      //   child: Text('CANCEL'),
                                      // ),
                                      // FlatButton(
                                      //   onPressed: () {
                                      //     Navigator.pop(context, ringTone[_currentIndex]);
                                      //   },
                                      //   child: Text('OK'),
                                      // ),
                                    ],
                                    content: Container(
                                      width: size.width * (18 / 20),
                                      height: 280,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: _allUsers.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return RadioListTile(
                                            value: index,
                                            groupValue: _currentIndex,
                                            selected: true,
                                            title: Text(_allUsers[index]["name"]
                                                .toString()),
                                            onChanged: (val) {
                                              setState(() {
                                                _currentIndex = index;
                                                //   final pageShortToken = page['data'][_currentIndex]['access_token'];
                                                //   final pageId = page['data'][_currentIndex]['id'];
                                                //   print(page['data'][_currentIndex]['name']);
                                                //   prefs.setString('pageId', pageId);
                                                //   prefs.setString('pageToken', pageShortToken);
                                                print(_allUsers[index]["id"]);
                                                print(val);
                                              });
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );
                            });
                      }),
                  //SwitchScheduled(),
                  ListTile(
                    title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Text('Scheduled at'),
                          Text(
                            "${widget.date}",
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ]),
                    trailing: CupertinoSwitch(
                      value: isSwitched,
                      onChanged: (value) {
                        setState(() {
                          isSwitched = value;
                          print(isSwitched);
                          if (value == true) {
                            //_awaitReturnValueFromSecondScreen(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Calendar()),
                            );
                          }
                        });
                      },
                      activeColor: Colors.blue,
                    ),
                  ),

                  // SwitchFacebook(),
                  // SwitchTwitter(),
                  // SwitchTumblr(),
                  SizedBox(height: 2),
                  // ListTile(
                  //   title: new Text('Facebook'),
                  //   trailing: CupertinoSwitch(
                  //     value: isSwitchedfb,
                  //     onChanged: (value) {
                  //       setState(() {
                  //         isSwitchedfb = value;
                  //         print(isSwitchedfb);
                  //         if (value == true) {
                  //           //_awaitReturnValueFromSecondScreen(context);
                  //         }
                  //       });
                  //     },
                  //     activeColor: Colors.blue,
                  //   ),
                  // ),
                  // SizedBox(height: 2),
                  // ListTile(
                  //   title: new Text('Twitter'),
                  //   trailing: CupertinoSwitch(
                  //     value: isSwitchedtwitter,
                  //     onChanged: (value) {
                  //       setState(() {
                  //         isSwitchedtwitter = value;
                  //         print(isSwitchedtwitter);
                  //         if (value == true) {
                  //           //_awaitReturnValueFromSecondScreen(context);
                  //         }
                  //       });
                  //     },
                  //     activeColor: Colors.blue,
                  //   ),
                  // ),
                  SizedBox(height: 5.0),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(
                  //     horizontal: size.width * (1 / 20),
                  //   ),
                  //   child: GestureDetector(
                  //     onTap: () {
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) {
                  //             return PaymentPlan();
                  //           },
                  //         ),
                  //       );
                  //     },
                  //     child: Row(
                  //       children: [
                  //         Text("Advanced Setting",
                  //             style: TextStyle(
                  //               fontSize: 12,
                  //               color: Colors.grey,
                  //             )),
                  //         Icon(Icons.keyboard_arrow_right),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // ListTile(
                  //   title: new Text('Select Page'),
                  //   trailing: new Icon(Icons.keyboard_arrow_right),
                  //   onTap: () {
                  //     print("Select Page Dialog Clicked........!");
                  //     //_selectPage();
                  //   },
                  // ),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

//   void _awaitReturnValueFromSecondScreen(BuildContext context) async {
//     // start the SecondScreen and wait for it to finish with a result
//     final result = await Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => Home(),
//         ));

//     // after the SecondScreen result comes back update the Text widget with it
//     setState(() {
//       text = result;
//       print(text);
//     });
//   }
//   @override
//   void debugFillProperties(DiagnosticPropertiesBuilder properties) {
//     super.debugFillProperties(properties);
//     properties.add(DiagnosticsProperty<File>('_image', _image));
//   }
// }

}
