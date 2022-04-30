import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Achieve extends StatefulWidget {
  final String scrollKey;

  const Achieve(this.scrollKey, {Key? key}) : super(key: key);

  @override
  State<Achieve> createState() => _AchieveState();
}

class _AchieveState extends State<Achieve> {
  var ach_data, successAch, resultAch;
  List numForAch = [];
  asd() async {
    numForAch = [];
    ach_data = await findAch();
    ach_data.sort((a, b) => a['ach_id'].compareTo(b['ach_id']) as int);
    successAch = await findSuccessAch();
    for (int i = 0; i < ach_data.length; i++) {
      for (int j = 0; j < successAch.length; j++) {
        if (successAch[j]['ach_id'] == ach_data[i]['ach_id']) {
          numForAch.add(1);
          break;
        }
      }
      if (numForAch.length != i + 1) {
        numForAch.add(0);
      }
    }
    if (numForAch.where((e) => e == 1).toList().length == 11) {
      var check = await checkAchievement(7);
      if (check['message'] == 'success') {
        AwesomeDialog(
                context: context,
                dismissOnTouchOutside: false,
                dialogType: DialogType.SUCCES,
                customHeader: Container(
                  height: 100,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset('images/Superb.png')),
                ),
                title: 'congratulations',
                body: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 10, 10),
                    child: Column(
                      children: const [
                        Text(
                          'congratulations',
                          style: TextStyle(
                            fontSize: 20,
                            height: 1.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Congratulations to unlock this achievement (Superb).',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )),
                btnOk: ElevatedButton(
                    onPressed: () async {
                      await asd();
                      Navigator.pop(context);
                    },
                    child: const Text('Ok')))
            .show();
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    asd();
    if (mounted) {
      setState(() {});
    }
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
                  // print(numForAch[index]);
                  AwesomeDialog(
                    context: context,
                    animType: AnimType.SCALE,
                    dialogType: DialogType.NO_HEADER,
                    customHeader: Container(
                        height: 100,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: numForAch[index] == 1
                                ? Image.asset(
                                    'images/${ach_data![index]['ach_color_image']}',
                                  )
                                : Image.asset(
                                    'images/${ach_data![index]['ach_grey_image']}',
                                  ))),
                    showCloseIcon: true,
                    title: ach_data![index]['ach_name'],
                    body: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 10, 20),
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
                          child: numForAch[index] == 1
                              ? Image.asset(
                                  'images/${ach_data![index]['ach_color_image']}',
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'images/${ach_data![index]['ach_grey_image']}',
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
  var url = 'https://diown-app-server.herokuapp.com/achievement/getAll';
  final http.Response response = await http.get(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      });
  var result = jsonDecode(response.body);
  return result;
}

findSuccessAch() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var url = 'https://diown-app-server.herokuapp.com/achievement/allSuccess';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, dynamic>{'token': token}));
  var result = jsonDecode(response.body);
  return result;
}

checkAchievement(index) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var url = 'https://diown-app-server.herokuapp.com/achievement/checkSuccess';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, dynamic>{'token': token, 'index': index},
      ));
  var result = jsonDecode(response.body);
  return result;
}
