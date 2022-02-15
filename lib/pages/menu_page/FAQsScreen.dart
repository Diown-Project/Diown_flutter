import 'package:flutter/material.dart';
import 'package:expandable/expandable.dart';

class FAQsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffeff2f5),
      body: ListView(
        children: [
          Card1(),
          Card2(),
          Card3(),
          Card4(),
        ],
      ),
    );
  }
}

class Card1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 15),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),

          // child: Card(
          //   elevation: 0.2,
          //   color: Color.fromRGBO(248, 248, 248, 30),
          child: Column(
            children: [
              ScrollOnExpand(
                child: ExpandablePanel(
                  theme: const ExpandableThemeData(
                    tapBodyToCollapse: true,
                    tapBodyToExpand: true,
                  ),
                  header: const Padding(
                    padding: EdgeInsets.all(10),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://cdn-icons-png.flaticon.com/512/1271/1271292.png"),
                      ),
                      title: Text(
                          "How to set a Diary Lock to protect my secrests ?",
                          style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontFamily: 'Readex Pro',
                              fontSize: 14,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1.1428571428571428)),
                    ),
                  ),
                  expanded: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          "ํ- With the Lock, you can make sure that others will not see entries without your permission\n\n"
                          "- If you want to set a lock, please go to the menu, then press the word Setting, you will find the Pin Password lock setting. The methods are as follows. Users must set a pin password with 4 digits and finally confirm the pin password that was pressed a while ago again.\n\n"
                          "- If you want to change your password, please go to the Menu, then press Settings, you will see the Pin Password change. The methods are as follows. User can change pin password by pressing the current password pin If the user presses the correct pin password, the system will show a page to set a new pin password. The user must set a pin password with 4 digits and finally confirm the pin password that was pressed a while ago again. The system will change the pin password successfully\n\n"
                          "- If the user forgets their password, click “Forgot Password?” and then go to reset the password. by having to confirm “Security Code” that we are the owner of this DIOWN or not via email, the system will ask us to choose what to reset through, click to send “Security Code” via email (the mail used to register for DIOWN) continue.",
                          softWrap: true,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Readex Pro',
                              fontSize: 10,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1.6),
                        ),
                      ),
                    ],
                  ),
                  collapsed: const Text(
                    "- With the Lock, you can make sure that others will not see entries without your permission\n",
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Readex Pro',
                        fontSize: 10,
                        letterSpacing:
                            0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.normal,
                        height: 1.6),
                  ),
                  builder: (_, collapsed, expanded) {
                    return Padding(
                      padding: EdgeInsets.only(left: 30, right: 30, bottom: 20),
                      child: Expandable(
                        collapsed: collapsed,
                        expanded: expanded,
                        theme: const ExpandableThemeData(crossFadePoint: 0),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Card2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      child: Padding(
        padding: const EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 15),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),

          // child: Card(
          //   elevation: 0.2,
          //   color: Color.fromRGBO(248, 248, 248, 30),
          child: Column(
            children: [
              ScrollOnExpand(
                child: ExpandablePanel(
                  theme: const ExpandableThemeData(
                    tapBodyToCollapse: true,
                    tapBodyToExpand: true,
                  ),
                  header: const Padding(
                    padding: EdgeInsets.all(10),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://cdn-icons-png.flaticon.com/512/1271/1271292.png"),
                      ),
                      title: Text("How to drop my Diary ?",
                          style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontFamily: 'Readex Pro',
                              fontSize: 14,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1.1428571428571428)),
                    ),
                  ),
                  expanded: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          "ํUsers can put down a diary in a number of ways, mainly as follows:\n\n"
                          "- Method 1 Press the plus icon below and press the word “Put down your diary”. Users can choose by themselves whether to put down from an existing location or add a new location. (In the case of adding a new location, it can only be done once a day). After that, users can write a diary. It can also be stated that Put down diary is public, follower only or private, user press put on top right hand corner, put down diary is successful.\n\n"
                          "- Method 2 Users can press the globe icon from the bottom. by after pressing will show up on the map page that can put down diary if we press the map pin It will be possible to put down the diary as well. The put down procedure is the same as Step 1, but with a slightly different approach.",
                          softWrap: true,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Readex Pro',
                              fontSize: 10,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1.6),
                        ),
                      ),
                    ],
                  ),
                  collapsed: const Text(
                    "Users can put down a diary in a number of ways, mainly as follows:",
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Readex Pro',
                        fontSize: 10,
                        letterSpacing:
                            0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.normal,
                        height: 1.6),
                  ),
                  builder: (_, collapsed, expanded) {
                    return Padding(
                      padding: EdgeInsets.only(left: 30, right: 30, bottom: 20),
                      child: Expandable(
                        collapsed: collapsed,
                        expanded: expanded,
                        theme: const ExpandableThemeData(crossFadePoint: 0),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Card3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      child: Padding(
        padding: const EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 15),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),

          // child: Card(
          //   elevation: 0.2,
          //   color: Color.fromRGBO(248, 248, 248, 30),
          child: Column(
            children: [
              ScrollOnExpand(
                child: ExpandablePanel(
                  theme: const ExpandableThemeData(
                    tapBodyToCollapse: true,
                    tapBodyToExpand: true,
                  ),
                  header: const Padding(
                    padding: EdgeInsets.all(10),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://cdn-icons-png.flaticon.com/512/1271/1271292.png"),
                      ),
                      title: Text(
                          "How do I know when and where the event will be held ?",
                          style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontFamily: 'Readex Pro',
                              fontSize: 14,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1.1428571428571428)),
                    ),
                  ),
                  expanded: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          "ํUsers can know the events organized by the main page, where the developer will update the events regularly:\n\n"
                          "- when the user is on the main page There will be a show almost every event. which users can press to see if there are any places at the moment with an event What events are organized, where are they held, and how many people are interested in putting down each place ?",
                          softWrap: true,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Readex Pro',
                              fontSize: 10,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1.6),
                        ),
                      ),
                    ],
                  ),
                  collapsed: const Text(
                    "Users can know the events organized by the main page, where the developer will update the events regularly:",
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Readex Pro',
                        fontSize: 10,
                        letterSpacing:
                            0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.normal,
                        height: 1.6),
                  ),
                  builder: (_, collapsed, expanded) {
                    return Padding(
                      padding: EdgeInsets.only(left: 30, right: 30, bottom: 20),
                      child: Expandable(
                        collapsed: collapsed,
                        expanded: expanded,
                        theme: const ExpandableThemeData(crossFadePoint: 0),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Card4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpandableNotifier(
      child: Padding(
        padding: const EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 15),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),

          // child: Card(
          //   elevation: 0.2,
          //   color: Color.fromRGBO(248, 248, 248, 30),
          child: Column(
            children: [
              ScrollOnExpand(
                child: ExpandablePanel(
                  theme: const ExpandableThemeData(
                    tapBodyToCollapse: true,
                    tapBodyToExpand: true,
                  ),
                  header: const Padding(
                    padding: EdgeInsets.all(10),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            "https://cdn-icons-png.flaticon.com/512/1271/1271292.png"),
                      ),
                      title: Text("How can I add emojis or activities ?",
                          style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 1),
                              fontFamily: 'Readex Pro',
                              fontSize: 14,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1.1428571428571428)),
                    ),
                  ),
                  expanded: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          "ํAs for adding emojis or activities, it's easy to do as follows:\n\n"
                          "- In case of adding an emoji When in the diary writing page or the writing page for the put down diary below will have the word emoji displayed, users can press to select an emoji of interest\n\n"
                          "- In case of adding an event When in the diary writing page Or the writing page for put down diary below will have the word activity displayed. to select an activity Or you can add or edit activities that you are interested in. which in the case of adding activities Users can select an icon. and can add the name of the event itself",
                          softWrap: true,
                          overflow: TextOverflow.fade,
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Readex Pro',
                              fontSize: 10,
                              letterSpacing:
                                  0 /*percentages not used in flutter. defaulting to zero*/,
                              fontWeight: FontWeight.normal,
                              height: 1.6),
                        ),
                      ),
                    ],
                  ),
                  collapsed: const Text(
                    "As for adding emojis or activities, it's easy to do as follows:",
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Readex Pro',
                        fontSize: 10,
                        letterSpacing:
                            0 /*percentages not used in flutter. defaulting to zero*/,
                        fontWeight: FontWeight.normal,
                        height: 1.6),
                  ),
                  builder: (_, collapsed, expanded) {
                    return Padding(
                      padding: EdgeInsets.only(left: 30, right: 30, bottom: 20),
                      child: Expandable(
                        collapsed: collapsed,
                        expanded: expanded,
                        theme: const ExpandableThemeData(crossFadePoint: 0),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
