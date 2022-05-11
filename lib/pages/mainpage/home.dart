import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:badges/badges.dart';
import 'package:diown/pages/diary/local_write.dart';
import 'package:diown/pages/mainpage/calendar.dart';
import 'package:diown/pages/mainpage/home_page.dart';
import 'package:diown/pages/mainpage/map.dart';
import 'package:diown/pages/other_page.dart/drawer_details.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:showcaseview/showcaseview.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static String id = 'Home';
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var c;

  var pagepop, request;
  var _bottomNavIndex = 0;
  var _saveindex = 0;
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final iconList = <IconData>[
    MdiIcons.home,
    MdiIcons.earth,
    MdiIcons.calendarBlank,
    MdiIcons.menu,
  ];
  final textList = <String>['Home', 'Map', 'Calendar', 'Menu'];
  var pageList = [
    const HomePage(),
    const MapPage(),
    const CalendarPage(),
  ];
  setRequest() async {
    request = await findRequest();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setRequest();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpened = MediaQuery.of(context).viewInsets.bottom != 0.0;
    return KeyboardVisibilityProvider(
      child: Scaffold(
          // resizeToAvoidBottomInset: false,
          key: _drawerKey,
          endDrawer: const Drawer(
            child: DrawerDetails(),
          ),
          body: _bottomNavIndex != 3
              ? pageList[_bottomNavIndex]
              : pageList[_saveindex],
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: keyboardIsOpened
              ? null
              : FloatingActionButton(
                  elevation: 0,
                  child: const Icon(
                    Icons.add_rounded,
                    size: 40,
                  ),
                  backgroundColor: const Color(0xff8b82ff),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15)),
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
                                      trailing: const Icon(
                                          Icons.navigate_next_rounded),
                                      onTap: () async {
                                        var sult = await Navigator.of(context)
                                            .push(PageTransition(
                                                child: const LocalDiary(),
                                                type: PageTransitionType
                                                    .rightToLeft));
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
                                      title: const Text(
                                          'Write your diary for putdown.'),
                                      trailing: const Icon(
                                          Icons.navigate_next_rounded),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                child: const MapPage(),
                                                type: PageTransitionType
                                                    .rightToLeft));
                                      },
                                    )
                                  ],
                                )),
                          );
                        });
                  },
                ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                    top: BorderSide(color: Color(0xfff5f5f5), width: 3))),
            child: AnimatedBottomNavigationBar.builder(
              backgroundColor: const Color.fromRGBO(255, 248, 248, 1),
              elevation: 0,
              height: 60,
              itemCount: iconList.length,
              tabBuilder: (int index, bool isActive) {
                final color = isActive ? const Color(0xff8a7efd) : Colors.black;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    index == 3
                        ? request != null
                            ? request != 0
                                ? Badge(
                                    child: Icon(
                                      iconList[index],
                                      size: 24,
                                      color: color,
                                    ),
                                  )
                                : Icon(
                                    iconList[index],
                                    size: 24,
                                    color: color,
                                  )
                            : Icon(
                                iconList[index],
                                size: 24,
                                color: color,
                              )
                        : Icon(
                            iconList[index],
                            size: 24,
                            color: color,
                          ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        textList[index],
                        style: TextStyle(color: color, fontSize: 11),
                      ),
                    )
                  ],
                );
              },
              activeIndex: _bottomNavIndex,
              gapLocation: GapLocation.center,
              notchSmoothness: NotchSmoothness.defaultEdge,
              onTap: (index) {
                if (index == 3) {
                  _drawerKey.currentState!.openEndDrawer();
                  setRequest();
                  setState(() {});
                } else {
                  setRequest();
                  setState(() {
                    _bottomNavIndex = index;
                    _saveindex = index;
                  });
                }
              },

              //other params
            ),
          )),
    );
  }
}


// decoration: BoxDecoration(
//                           borderRadius:
//                               BorderRadius.only(topLeft: Radius.circular(10))),