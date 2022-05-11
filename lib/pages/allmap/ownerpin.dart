import 'dart:convert';

import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OwnerPin extends StatefulWidget {
  const OwnerPin({Key? key, required this.newlocation}) : super(key: key);
  final newlocation;
  @override
  State<OwnerPin> createState() => _OwnerPinState();
}

class _OwnerPinState extends State<OwnerPin> {
  var ownMarker, textInput;
  findOwn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    ownMarker = await findAllOwnMarker(token);
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findOwn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your own pin.'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
<<<<<<< Updated upstream
=======
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: const Text('Add new pin location name'),
                            content: TextField(
                              onChanged: (value) {
                                setState(() {
                                  textInput = value;
                                });
                              },
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () async {
                                    CoolAlert.show(
                                        barrierDismissible: false,
                                        context: context,
                                        type: CoolAlertType.loading);
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    var token = prefs.getString('token');
                                    var checkDelay = await checkDelayPin(token);
                                    if (checkDelay['message'] ==
                                            'add success' ||
                                        checkDelay['message'] == 'success') {
                                      var e = await addUserMarker(
                                          token,
                                          textInput,
                                          widget.newlocation.latitude as double,
                                          widget.newlocation.longitude
                                              as double);
                                      if (e['message'] == 'success') {
                                        CoolAlert.show(
                                            barrierDismissible: false,
                                            context: context,
                                            type: CoolAlertType.success,
                                            title: 'Add pin was success.',
                                            onConfirmBtnTap: () {
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            });
                                      } else if (e['message'] ==
                                          'already have') {
                                        CoolAlert.show(
                                            barrierDismissible: false,
                                            context: context,
                                            type: CoolAlertType.warning,
                                            title:
                                                'Your pin location already have.',
                                            onConfirmBtnTap: () {
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            });
                                      } else {
                                        CoolAlert.show(
                                            barrierDismissible: false,
                                            context: context,
                                            type: CoolAlertType.error,
                                            title: 'Something wrong.',
                                            onConfirmBtnTap: () {
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            });
                                      }
                                    } else {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.error,
                                          title:
                                              'You cannot add Pin right now.',
                                          text:
                                              'Because you need to wait for cooldown 1 day after add pin to add another one.',
                                          onConfirmBtnTap: () {
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          });
                                    }
                                  },
                                  child: const Text('Submit'))
                            ],
                          )).then((_) {
                    findOwn();
                    setState(() {});
                  });
                },
                icon: Icon(Icons.add_location_alt))
          ],
>>>>>>> Stashed changes
        ),
        body: ownMarker != null
            ? SingleChildScrollView(
                child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: ownMarker
                      .map<Widget>((e) => ListTile(
                            leading: Icon(Icons.location_on),
                            title: Text(e['marker_id']),
                            subtitle: Text('${e['number_putdown']} Diary'),
                            trailing: IconButton(
                                onPressed: () async {
                                  CoolAlert.show(
                                      barrierDismissible: false,
                                      context: context,
                                      type: CoolAlertType.confirm,
                                      onConfirmBtnTap: () async {
                                        CoolAlert.show(
                                            barrierDismissible: false,
                                            context: context,
                                            type: CoolAlertType.loading);
                                        var c = await deletePin(e['_id']);
                                        if (c['message'] == 'success') {
                                          CoolAlert.show(
                                              barrierDismissible: false,
                                              context: context,
                                              type: CoolAlertType.success,
                                              onConfirmBtnTap: () async {
                                                await findOwn();
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                setState(() {});
                                              });
                                        } else {
                                          CoolAlert.show(
                                              barrierDismissible: false,
                                              context: context,
                                              type: CoolAlertType.error,
                                              onConfirmBtnTap: () async {
                                                await findOwn();
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                                setState(() {});
                                              });
                                        }
                                      });
                                },
                                icon: const Icon(Icons.delete_rounded)),
                          ))
                      .toList(),
                ),
              ))
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}

deletePin(id) async {
  var url = 'https://diown-app-server.herokuapp.com/putdown/deletePin';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, dynamic>{
          'id': id,
        },
      ));
  var result = jsonDecode(response.body);
  return result;
}

findAllOwnMarker(token) async {
  var url = 'https://diown-app-server.herokuapp.com/putdown/findAllOwnMarker';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, dynamic>{
          'token': token,
        },
      ));
  var result = jsonDecode(response.body);
  return result;
}

addUserMarker(token, pin, lag, lng) async {
  var url = 'https://diown-app-server.herokuapp.com/putdown/addPin';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, dynamic>{'token': token, 'pin': pin, 'lag': lag, 'lng': lng},
      ));
  var result = jsonDecode(response.body);
  return result;
}

checkDelayPin(token) async {
  var url = 'https://diown-app-server.herokuapp.com/delay/addOrDeleteDelay';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, dynamic>{'token': token},
      ));
  var result = jsonDecode(response.body);
  return result;
}
