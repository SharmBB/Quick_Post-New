import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:http/http.dart' as http;
import 'package:post/home/home.dart';
import 'package:post/schedules/scheduler/calendar.dart';
import 'package:post/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dio/dio.dart' as dio;

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

  final List<Map<String, dynamic>> _allUsers = [];

  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 50
            // maxWidth: 1800,
            // maxHeight: 1800,
            );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        uploadFile();
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
        print(_image);
        print('------');
        print(pickedFile);
        uploadFile();
      });
    }
  }

  Future uploadFile() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("image1" + DateTime.now().toString());
    UploadTask uploadTask = ref.putFile(_image!);
    uploadTask.then((res) {
      setState(() {
        _uploadedFileURL = res.ref.getDownloadURL() as String?;
        print(_uploadedFileURL);
      });
    });
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

  Future<void> createCampaign(String name) async {
    try {
      await uploadFile();
      SharedPreferences prefs = await SharedPreferences.getInstance();

      final userId = prefs.getString('userId');
      final AD_ACCOUNT_ID = prefs.getString('pageId');

      final accountId = prefs.getString('accountId');
      final ACCESS_TOKEN = prefs.getString('pageToken');
      String? selectedTime = prefs.getString('selectedTime');
      String finalDateTime =
          text.substring(0, 10) + " " + selectedTime!.substring(1, 6);

      var dateTime = DateTime.parse(finalDateTime);
      print("Local " + dateTime.toString());
      print("UTC " + dateTime.toUtc().toString());
      //var parsedDate = DateFormat("yyyy-MM-dd HH:mm:ss").format(dateTime);
      int fbTime = (dateTime.toUtc().millisecondsSinceEpoch / 1000).round();
      print(fbTime);
      //print(userId);

      if (AD_ACCOUNT_ID == null) {
        Fluttertoast.showToast(
            msg: 'No Page Selected',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.blueGrey,
            textColor: Colors.white);
        return;
      }

      final formData = dio.FormData.fromMap({
        "published": "false",
        "scheduled_publish_time": fbTime,
        "a": name,
        "url": _uploadedFileURL,
        "access_token": ACCESS_TOKEN
      });

      final response = await dio.Dio().post(
        'https://graph.facebook.com/v9.0/$AD_ACCOUNT_ID/photos',
        data: formData,
      );
      final profile = jsonDecode(response.data);
      print(profile);
      print(_uploadedFileURL);
      Fluttertoast.showToast(
          msg: 'Post sheduled Successfully!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white);

      ///addPosts(userId,accountId,dateTime,name,AD_ACCOUNT_ID,_uploadedFileURL);
    } on Exception catch (e) {
      print(e);
    }
    //ignore: dead_code_on_catch_subtype
    on dio.DioError {
      throw Exception('Failed to create Campaign.');
    }
  }

  Future<void> getAllAvailablePages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accountId = prefs.getString('accountId');
    final accessToken = prefs.getString('userToken');

    if (accountId == null) {
      Fluttertoast.showToast(
          msg: 'Select An Account First',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.blueGrey,
          textColor: Colors.white);
    }
    // radio button dialog
    //List<String> ringTone = [];
    final responsePage = await http.get(Uri.parse(
        'https://graph.facebook.com/v9.0/$accountId/accounts?fields=id,name,access_token& access_token=${accessToken}'));
    final page = jsonDecode(responsePage.body);
    //print(accountId);
    //print("accessToken");
    //print(accessToken);
    //print(page);

    for (var i = 0; i < page['data'].length; i++) {
      _allUsers.add(page['data'][i]);
    }

    print(_allUsers);
  }

  @override
  void initState() {
    getAllAvailablePages();
    super.initState();
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
                createCampaign(description);
                //createCampaign
                print(myTextController.text);
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
                            text,
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
                            _awaitReturnValueFromSecondScreen(context);
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

  void _awaitReturnValueFromSecondScreen(BuildContext context) async {
    // start the SecondScreen and wait for it to finish with a result
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Calendar(),
        ));

    // after the SecondScreen result comes back update the Text widget with it
    setState(() {
      text = result;
      print(text);
    });
  }
}
