import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:diown/pages/model/achievement.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Achieve extends StatefulWidget {
  final String scrollKey;
  final List<Achievement> list;
  const Achieve(this.scrollKey, this.list, {Key? key}) : super(key: key);

  @override
  State<Achieve> createState() => _AchieveState();
}

class _AchieveState extends State<Achieve> {
  var ach_data;
  var len;
  asd() async {
    ach_data = await findAch();
    len = ach_data.length;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    asd();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ach_data != null
        ? Container(
            margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
            padding: const EdgeInsets.all(15),
            child: GridView.builder(
              key: PageStorageKey(widget.scrollKey),
              itemCount: ach_data != null ? ach_data.length : 0,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.SCALE,
                    dialogType: DialogType.NO_HEADER,
                    customHeader: Container(
                        height: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            'images/${ach_data![index]['ach_grey_image']}',
                          ),
                        )),
                    showCloseIcon: true,
                    title: ach_data![index]['ach_name'],
                    body: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 10, 20),
                        child: Column(
                          children: [
                            Text(
                              ach_data![index]['ach_name'],
                              style: const TextStyle(
                                fontSize: 20,
                                height: 1.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              ach_data![index]['ach_detail'],
                              textAlign: TextAlign.center,
                            ),
                          ],
                        )),
                  ).show();
                },
                child: Column(
                  children: [
                    Container(
                      height: 70,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            'images/${ach_data![index]['ach_grey_image']}',
                            fit: BoxFit.cover,
                          )),
                    ),
                    SizedBox(height: 5),
                    RichText(
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          text: ach_data![index]['ach_name'],
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            height: 1.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ))
                  ],
                ),
              ),
            ),
          )
        : Center(
            child: CircularProgressIndicator(),
          );
  }
}

findAch() async {
  var url = 'http://10.0.2.2:3000/achievement/getAll';
  final http.Response response = await http.get(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      });
  var result = jsonDecode(response.body);
  return result;
}
