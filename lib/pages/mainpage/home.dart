import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:diown/pages/diary/local_write.dart';
import 'package:diown/pages/mainpage/calendar.dart';
import 'package:diown/pages/mainpage/home_page.dart';
import 'package:diown/pages/mainpage/map.dart';
import 'package:diown/pages/other_page.dart/drawer_details.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static String id = 'Home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var c;
  var pagepop;
  var _bottomNavIndex = 0;
  var _saveindex = 0;
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final iconList = <IconData>[
    Icons.home,
    Icons.map_rounded,
    Icons.calendar_today_rounded,
    Icons.menu_rounded,
  ];
  var pageList = [
    const HomePage(),
    const MapPage(),
    const CalendarPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: _drawerKey,
          endDrawer: const Drawer(
            child: DrawerDetails(),
          ),
          body: _bottomNavIndex != 3
              ? pageList[_bottomNavIndex]
              : pageList[_saveindex],
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            child: const Icon(
              Icons.add_rounded,
              size: 40,
            ),
            backgroundColor: const Color.fromRGBO(148, 92, 254, 1),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                  ),
                  useRootNavigator: false,
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          color: Colors.transparent,
                          height: 220,
                          child: ListView(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                    title: const Text(
                                      'Diary',
                                      style: TextStyle(fontSize: 25),
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(
                                          Icons.highlight_remove_rounded),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    )),
                              ),
                              const Divider(
                                thickness: 0.8,
                              ),
                              ListTile(
                                leading: const Icon(
                                  Icons.book,
                                  color: Color.fromRGBO(148, 92, 254, 1),
                                ),
                                title: const Text('Write your diary.'),
                                trailing:
                                    const Icon(Icons.navigate_next_rounded),
                                onTap: () async {
                                  var sult = await Navigator.of(context).push(
                                      PageTransition(
                                          child: const LocalDiary(),
                                          type:
                                              PageTransitionType.rightToLeft));
                                  if (sult != null) {
                                    setState(() {
                                      _bottomNavIndex = 0;
                                    });
                                  }
                                },
                              ),
                              ListTile(
                                leading: const Icon(
                                  Icons.pin_drop,
                                  color: Color.fromRGBO(148, 92, 254, 1),
                                ),
                                title:
                                    const Text('Write your diary for putdown.'),
                                trailing:
                                    const Icon(Icons.navigate_next_rounded),
                                onTap: () {},
                              )
                            ],
                          )),
                    );
                  });
            },
          ),
          bottomNavigationBar: AnimatedBottomNavigationBar(
            icons: iconList,
            activeIndex: _bottomNavIndex,
            activeColor: const Color.fromRGBO(148, 92, 254, 1),
            gapLocation: GapLocation.center,
            notchSmoothness: NotchSmoothness.defaultEdge,
            iconSize: 25,
            onTap: (index) {
              if (index == 3) {
                _drawerKey.currentState!.openEndDrawer();
                setState(() {});
              } else {
                setState(() {
                  _bottomNavIndex = index;
                  _saveindex = index;
                });
              }
            },

            //other params
          )),
    );
  }
}
// decoration: BoxDecoration(
//                           borderRadius:
//                               BorderRadius.only(topLeft: Radius.circular(10))),