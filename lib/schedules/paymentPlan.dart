import 'package:flutter/material.dart';
import 'package:post/utils/constants.dart';

class RadioModel {
  bool isSelected;
  final String buttonText;
  final String text;
  final String subText;
  RadioModel(this.isSelected, this.buttonText, this.text, this.subText);
}

class PaymentPlan extends StatefulWidget {
  @override
  createState() {
    return new PaymentPlanState();
  }
}

class PaymentPlanState extends State<PaymentPlan> {
  List<RadioModel> sampleData = [];

  @override
  void initState() {
    super.initState();
    sampleData.add(new RadioModel(true, 'FREE', '10 post/Month', ''));
    sampleData.add(new RadioModel(
        false, '4.39\$/Month', '30 post/Month', '(one account)'));
    sampleData.add(new RadioModel(
        false, '7.39\$/Month', 'Unlimited posts/Month', '(one account)'));
    sampleData.add(new RadioModel(
        false, '12.39\$/Month', 'Unlimited posts/Month', '(Three account)'));
    sampleData.add(new RadioModel(
        false, '19.39\$/Month', 'Unlimited posts/Month', '(Five account)'));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return new Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Choose your payment Plan',
          style: TextStyle(
              color: kPrimaryDarkColor,
              fontSize: 18,
              fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: [
                new ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: sampleData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new InkWell(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          sampleData
                              .forEach((element) => element.isSelected = false);
                          sampleData[index].isSelected = true;
                          print(sampleData[index].isSelected);
                          print(index);
                        });
                      },
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                    width: 0.5, color: Colors.black26),
                              ),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Container(
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    height: 70.0,
                                    // width: 30.0,
                                    child: sampleData[index].isSelected
                                        ? Icon(
                                            Icons.check,
                                            size: 30.0,
                                            color: Colors.white,
                                          )
                                        : Icon(
                                            Icons.account_circle,
                                            size: 30.0,
                                            color: Colors.transparent,
                                          ),
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: sampleData[index].isSelected
                                          ? LinearGradient(
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
                                            )
                                          : LinearGradient(
                                              begin: Alignment.bottomRight,
                                              end: Alignment.topLeft,
                                              colors: [
                                                Colors.transparent,
                                                Colors.transparent,
                                              ],
                                            ),
                                      // color: sampleData[index].isSelected
                                      //     ? Colors.blueAccent
                                      //     : Colors.transparent,
                                      border: new Border.all(
                                          width: 1.0,
                                          color: sampleData[index].isSelected
                                              ? Colors.transparent
                                              : Colors.grey),
                                    ),
                                  ),
                                  new Container(
                                    margin: new EdgeInsets.only(left: 2.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              sampleData[index].text,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600),
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                            ),
                                            Text(
                                              sampleData[index].subText,
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              sampleData[index].buttonText,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black26),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 35.0),
                Container(
                  alignment: Alignment.center,
                  width: 380.0,
                  child: GestureDetector(
                    child: ButtonTheme(
                        minWidth: 350.0,
                        height: 52.0,
                        buttonColor: Colors.blue[500],
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          onPressed: () {},
                          child: Text(
                            'Continue to payment ',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        )),
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Cancle",
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
