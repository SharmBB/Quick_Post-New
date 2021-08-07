// // import 'package:flutter/material.dart';
// // import '../constants.dart';
// // import 'package:flutter/cupertino.dart';

// // class HomeBody extends StatefulWidget {
// //   HomeBody({Key key}) : super(key: key);
// //   @override
// //   _HomeBodyState createState() => _HomeBodyState();
// // }

// // class _HomeBodyState extends State<HomeBody> with TickerProviderStateMixin {
// //   @override
// //   Widget build(BuildContext context) {
// //     Size size = MediaQuery.of(context).size;
// //     return Scaffold(
// //        appBar: AppBar(
// //         leading: IconButton(
// //           icon: Icon(Icons.arrow_back_ios, color: Colors.black),
// //           onPressed: () => Navigator.of(context).pop(),
// //         ),
// //         centerTitle: true,
// //         title: Text('Home Body', style: TextStyle(color: kPrimaryDarkColor, fontSize: 18),),
// //         backgroundColor: Colors.transparent,
// //         automaticallyImplyLeading: false,
// //         elevation: 0,
// //       ),
// //       body: Container(
// //         child: Center(child: Text("Home Body Works")),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'dart:async';

// import 'package:multi_image_picker/multi_image_picker.dart';

// // void main() => runApp(new MyApp());

// class HomeBody extends StatefulWidget {
//   @override
//   _HomeBodyState createState() => new _HomeBodyState();
// }

// class _HomeBodyState extends State<HomeBody> {
//   List<Asset> images = List<Asset>();
//   String _error = 'Pick your images';

//   @override
//   void initState() {
//     super.initState();
//   }

//   Widget buildGridView() {
//     return GridView.count(
//       scrollDirection: Axis.horizontal,
//       crossAxisCount: 1,
//       children: List.generate(images.length, (index) {
//         Asset asset = images[index];
//         return Padding(
//           padding: const EdgeInsets.all(3.0),
//           child: AssetThumb(
//             asset: asset,
//             width: 300,
//             height: 300,
//           ),
//         );
//       }),
//     );
//   }

//   Future<void> loadAssets() async {
//     List<Asset> resultList = List<Asset>();
//     String error = 'No Error Dectected';

//     try {
//       resultList = await MultiImagePicker.pickImages(
//         maxImages: 10,
//         enableCamera: true,
//         selectedAssets: images,
//         cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
//         materialOptions: MaterialOptions(
//           actionBarColor: "#abcdef",
//           actionBarTitle: "Example App",
//           allViewTitle: "All Photos",
//           useDetailsView: false,
//           selectCircleStrokeColor: "#000000",
//         ),
//       );
//     } on Exception catch (e) {
//       error = e.toString();
//     }

//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;

//     setState(() {
//       images = resultList;
//       _error = error;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return new MaterialApp(
//       home: new Scaffold(
//         appBar: new AppBar(
//           title: const Text('Plugin example app'),
//         ),
//         body: Column(
//           children: <Widget>[
//             Center(child: Text('Error: $_error')),
//             RaisedButton(
//               child: Text("Pick images"),
//               onPressed: loadAssets,
//             ),
//             Container(
//               height: 100,
//               child: buildGridView(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
