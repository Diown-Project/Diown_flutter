import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MoodSelected extends StatefulWidget {
  const MoodSelected({Key? key}) : super(key: key);
  static var resultMood = '';
  @override
  _MoodSelectedState createState() => _MoodSelectedState();
}

class _MoodSelectedState extends State<MoodSelected> {
  List<Map<String, String>> moodList = [
    {'emoji': '😄', 'mood': 'Happy'},
    {'emoji': '😭', 'mood': 'Sadly'},
    {'emoji': '😑', 'mood': 'Boring'},
    {'emoji': '😪', 'mood': 'Tired'},
    {'emoji': '😎', 'mood': 'Cool'},
    {'emoji': '😜', 'mood': 'Nonsense'},
    {'emoji': '😞', 'mood': 'Disappointed'},
    {'emoji': '😌', 'mood': 'Relax'},
    {'emoji': '😤', 'mood': 'Angry'},
    {'emoji': '😡', 'mood': 'Furious'},
    {'emoji': '😵', 'mood': 'Confused'},
    {'emoji': '😳', 'mood': 'Shy'},
    {'emoji': '🥰', 'mood': 'Lovely'},
    {'emoji': '😒', 'mood': 'Annoyed'},
    {'emoji': '☺', 'mood': ' Thankful'},
  ];

  @override
  Widget build(BuildContext context) {
    return makeDismissible(
      child: DraggableScrollableSheet(
        initialChildSize: 0.85,
        builder: (_, controller) => Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25))),
              foregroundColor: Colors.black,
              title: const Text(
                'Feeling',
                style: TextStyle(fontSize: 24),
              ),
              centerTitle: true,
            ),
            body: Container(
              height: double.maxFinite,
              color: Colors.white,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      CupertinoSearchTextField(
                        onChanged: (value) {
                          if (value == '') {
                            setState(() {
                              moodList = [
                                {'emoji': '😄', 'mood': 'Happy'},
                                {'emoji': '😭', 'mood': 'Sadly'},
                                {'emoji': '😑', 'mood': 'Boring'},
                                {'emoji': '😪', 'mood': 'Tired'},
                                {'emoji': '😎', 'mood': 'Cool'},
                                {'emoji': '😜', 'mood': 'Nonsense'},
                                {'emoji': '😞', 'mood': 'Disappointed'},
                                {'emoji': '😌', 'mood': 'Relax'},
                                {'emoji': '😤', 'mood': 'Angry'},
                                {'emoji': '😡', 'mood': 'Furious'},
                                {'emoji': '😵', 'mood': 'Confused'},
                                {'emoji': '😳', 'mood': 'Shy'},
                                {'emoji': '🥰', 'mood': 'Lovely'},
                                {'emoji': '😒', 'mood': 'Annoyed'},
                                {'emoji': '☺', 'mood': ' Thankful'},
                              ];
                            });
                          } else {
                            setState(() {
                              moodList = [
                                {'emoji': '😄', 'mood': 'Happy'},
                                {'emoji': '😭', 'mood': 'Sadly'},
                                {'emoji': '😑', 'mood': 'Boring'},
                                {'emoji': '😪', 'mood': 'Tired'},
                                {'emoji': '😎', 'mood': 'Cool'},
                                {'emoji': '😜', 'mood': 'Nonsense'},
                                {'emoji': '😞', 'mood': 'Disappointed'},
                                {'emoji': '😌', 'mood': 'Relax'},
                                {'emoji': '😤', 'mood': 'Angry'},
                                {'emoji': '😡', 'mood': 'Furious'},
                                {'emoji': '😵', 'mood': 'Confused'},
                                {'emoji': '😳', 'mood': 'Shy'},
                                {'emoji': '🥰', 'mood': 'Lovely'},
                                {'emoji': '😒', 'mood': 'Annoyed'},
                                {'emoji': '☺', 'mood': ' Thankful'},
                              ];
                              moodList = moodList
                                  .where((e) => e['mood']!
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                                  .toList();
                            });
                          }
                        },
                      ),
                      moodList.isEmpty
                          ? Container()
                          : Container(
                              child: Column(
                                children: moodList.map((e) {
                                  return ListTile(
                                    leading: Text(
                                      '${e['emoji']}',
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                    title: Text('${e['mood']}'),
                                    onTap: () {
                                      setState(() {
                                        MoodSelected.resultMood =
                                            '${e['emoji']} ${e['mood']}';
                                      });

                                      Navigator.pop(context);
                                    },
                                  );
                                }).toList(),
                              ),
                            )
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }

  Widget makeDismissible({required Widget child}) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).pop(),
        child: GestureDetector(
            onTap: FocusScope.of(context).unfocus, child: child),
      );
}
