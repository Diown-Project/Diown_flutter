import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class visitorAchieve extends StatefulWidget {
  final String scrollKey;
  const visitorAchieve(this.scrollKey, {Key? key, required this.user_id})
      : super(key: key);
  final user_id;
  @override
  State<visitorAchieve> createState() => _visitorAchieveState();
}

class _visitorAchieveState extends State<visitorAchieve> {
  var ach_data, successAch, resultAch;
  List numForAch = [];
  asd() async {
    numForAch = [];
    ach_data = await findAch();
    ach_data.sort((a, b) => a['ach_id'].compareTo(b['ach_id']) as int);
    successAch = await findSuccessAchId(widget.user_id);
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
  var url = 'http://ec2-175-41-169-93.ap-southeast-1.compute.amazonaws.com:3000/achievement/getAll';
  final http.Response response = await http.get(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      });
  var result = jsonDecode(response.body);
  return result;
}

findSuccessAchId(id) async {
  var url = 'http://ec2-175-41-169-93.ap-southeast-1.compute.amazonaws.com:3000/achievement/allSuccessUser';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, dynamic>{'user_id': id}));
  var result = jsonDecode(response.body);
  return result;
}
