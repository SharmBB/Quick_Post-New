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
    {"id": 3, "name": "Bob", "age": 5}
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
        backgroundColor: Colors.transparent,
        builder: (BuildContext bc) {
          return CupertinoActionSheet(
            actions: <Widget>[
              ListTile(
                  title: new Text('Gallery'),
                  trailing: new Icon(Icons.photo_library),
                  onTap: () {
                    _getFromGallery();
                    Navigator.of(context).pop();
                  }),
              ListTile(
                title: new Text('Camera'),
                trailing: new Icon(Icons.photo_camera),
                onTap: () {
                  _getFromCamera();
                  Navigator.of(context).pop();
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              isDefaultAction: true,
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
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
            onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Home();
                    },
                  ),
                )),
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
                                        padding: const EdgeInsets.only(
                                            right: 13, bottom: 5),
                                        child: FlatButton(
                                          color: kPrimaryDarkColor,
                                          textColor: Colors.white,
                                          onPressed: () {
                                            Navigator.pop(context, null);
                                          },
                                          child: Text('Select'),
                                        ),
                                      ),
                                    ],
                                    content: Container(
                                      width: size.width * (18 / 20),
                                      // height: size.height * 0.,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
