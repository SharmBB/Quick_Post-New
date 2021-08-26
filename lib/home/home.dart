import 'package:flutter/material.dart';
import 'package:post/schedules/scheduler/addUserFirebase.dart';
import 'package:post/schedules/new_schedule.dart';
import 'package:post/schedules/past_schedule.dart';
import 'package:post/schedules/paymentPlan.dart';
import 'package:post/schedules/selectFbPage.dart';
import 'package:post/schedules/upcoming_schedule.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentTab = 3; // to keep track of active tab index
  final List<Widget> screens = [
    PaymentPlan(),
    SelectFbPage(),
    PastSchedule(),
    // Upcoming()
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen =
      PaymentPlan(); //PaymentPlan(); // Our first view in viewport

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        height: size.height,
        width: size.width,
        child: Scaffold(
          // appBar: AppBar(
          //   centerTitle: true,
          //   title: Text("Profile", style: TextStyle(color: kPrimaryDarkColor, fontWeight: FontWeight.w600),),
          //   backgroundColor: Colors.transparent,
          //   automaticallyImplyLeading: false,
          //    elevation: 0.0,
          // ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return NewSchedule(
                      date: '',
                      title: '',
                      date2: '',
                      time: '',
                    );
                  },
                ),
              );
            },
            // backgroundColor: Colors.red,
            // elevation: 10,
            shape: CircleBorder(
              side: BorderSide(
                  color: Colors.white, width: 4, style: BorderStyle.solid),
            ),
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
              padding: const EdgeInsets.all(3.0),
              child: Icon(
                Icons.add,
                size: 50.0,
                color: Colors.white,
              ),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            // notchMargin: 15,
            elevation: 15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // IconButton(
                //   icon: Icon(Icons.calendar_today),
                //   color: currentTab == 0 ? Colors.purple : Colors.grey,
                //   onPressed: () {
                //     setState(() {
                //       currentScreen = Upcoming(); // if user taps on this dashboard tab will be active
                //       currentTab = 0;
                //     });
                //   },
                // ),
                IconButton(
                  icon: Icon(Icons.schedule),
                  color: currentTab == 1 ? Colors.purple : Colors.grey,
                  onPressed: () {
                    setState(() {
                      currentScreen =
                          PastSchedule(); // if user taps on this dashboard tab will be active
                      currentTab = 1;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.account_circle),
                  color: currentTab == 2 ? Colors.purple : Colors.grey,
                  onPressed: () {
                    setState(() {
                      currentScreen =
                          SelectFbPage(); // if user taps on this dashboard tab will be active
                      currentTab = 2;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.payment),
                  color: currentTab == 3 ? Colors.purple : Colors.grey,
                  onPressed: () {
                    setState(() {
                      currentScreen =
                          PaymentPlan(); // if user taps on this dashboard tab will be active
                      currentTab = 3;
                    });
                  },
                ),
                SizedBox(width: size.width * 0.1),
              ],
            ),
          ),

          //     bottomNavigationBar: BottomNavigationBar(
          //     backgroundColor: Colors.white,
          //     selectedLabelStyle:
          //         TextStyle(fontWeight: FontWeight.w500, fontFamily: "Soleil"),
          //     unselectedLabelStyle: TextStyle(fontFamily: "Soleil"),
          //     items: <BottomNavigationBarItem>[
          //       BottomNavigationBarItem(
          //           icon: Icon(Icons.home), title: Text('Home')),
          //       BottomNavigationBarItem(
          //           icon: Icon(Icons.home), title: Text('Tamil')),
          //       BottomNavigationBarItem(
          //           icon: Icon(Icons.home), title: Text('Job')),
          //       BottomNavigationBarItem(
          //           icon: Icon(Icons.search), title: Text('Search')),
          //     ],
          //     currentIndex: currentTab,
          //     fixedColor: Colors.purpleAccent,
          //     onTap: _onItemTapped,
          //     type: BottomNavigationBarType.fixed
          //  ),
          //  body: Center(
          //   child: screens.elementAt(currentTab),
          // ),
          body: PageStorage(
            child: currentScreen,
            bucket: bucket,
          ),
        ));
  }

  void _onItemTapped(int index) {
    setState(() {
      currentTab = index;
    });
  }
}
