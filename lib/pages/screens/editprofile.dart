import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:diown/pages/extraPage/apigcloud.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ink_widget/ink_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {
  EditProfile({Key? key, required this.pro}) : super(key: key);
  final pro;
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  dynamic user, token;
  dynamic username, bio;
  CloudApi? api;
  File? _image;
  List<String>? _imageName;
  List<Uint8List>? _imageByte;
  final picker = ImagePicker();
  final _formkey = GlobalKey<FormState>();

  findUserForEditProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    var url = 'http://10.0.2.2:3000/auth/rememberMe';
    final http.Response response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(
          <String, String>{'token': token!},
        ));

    var result = jsonDecode(response.body);
    setState(() {
      user = result;
    });
  }

  _saveImage() async {
    final response = await api!.save(_imageName!, _imageByte!);
    print(response);
  }

  selectImageGallery() async {
    final XFile? selected = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = null;
      _imageByte = null;
      _imageName = null;
      if (selected != null) {
        _image = File(selected.path);
        _imageByte = [_image!.readAsBytesSync()];
        _imageName = [_image!.path.split('/').last];
      } else {}
    });
  }

  selectImageCamera() async {
    final XFile? selected = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = null;
      _imageByte = null;
      _imageName = null;
      if (selected != null) {
        _image = File(selected.path);
        _imageByte = [_image!.readAsBytesSync()];
        _imageName = [_image!.path.split('/').last];
      } else {}
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findUserForEditProfile();
    rootBundle.loadString('assets/credentials.json').then((value) {
      api = CloudApi(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.black,
            centerTitle: true,
            title: Text('Edit Profile'),
            actions: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: OutlinedButton(
                  onPressed: () async {
                    setState(() {
                      if (_formkey.currentState!.validate()) {
                        _formkey.currentState!.save();
                      }
                    });
                    CoolAlert.show(
                        barrierDismissible: false,
                        context: context,
                        type: CoolAlertType.confirm,
                        onConfirmBtnTap: () async {
                          var check;
                          CoolAlert.show(
                              context: context,
                              type: CoolAlertType.loading,
                              barrierDismissible: false);
                          if (_imageByte != null) {
                            await _saveImage();
                            check = await checkAchievement(8);
                          }
                          var checkResult = await updateUser(
                              token, username, bio, _imageName);
                          if (checkResult['message'] == 'success' &&
                              check != null) {
                            if (check['message'] == 'success') {
                              CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.success,
                                  barrierDismissible: false,
                                  onConfirmBtnTap: () {
                                    AwesomeDialog(
                                            context: context,
                                            dismissOnTouchOutside: false,
                                            dialogType: DialogType.SUCCES,
                                            customHeader: Container(
                                              height: 100,
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: Image.asset(
                                                      'images/profile.png')),
                                            ),
                                            title: 'congratulations',
                                            body: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        15, 0, 10, 10),
                                                child: Column(
                                                  children: const [
                                                    Text(
                                                      'congratulations',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        height: 1.5,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(height: 10),
                                                    Text(
                                                      'Congratulations to unlock this achievement (Identify yourself).',
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                )),
                                            btnOk: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('ok')))
                                        .show();
                                  });
                            } else {
                              CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.success,
                                  barrierDismissible: false,
                                  onConfirmBtnTap: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  });
                            }
                          } else if (checkResult['message'] == 'success') {
                            CoolAlert.show(
                                context: context,
                                type: CoolAlertType.success,
                                barrierDismissible: false,
                                onConfirmBtnTap: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                });
                          } else {
                            CoolAlert.show(
                                context: context,
                                type: CoolAlertType.error,
                                barrierDismissible: false,
                                onConfirmBtnTap: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                });
                          }
                        });
                  },
                  child:
                      const Text('save', style: TextStyle(color: Colors.white)),
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(65, 30),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    backgroundColor: Color(0xff945cfe),
                    side: BorderSide.none,
                  ),
                ),
              )
            ],
          ),
          body: user != null
              ? SingleChildScrollView(
                  child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                        child: Stack(
                          children: [
                            ClipOval(
                                child: Material(
                              color: Colors.transparent,
                              child: InkWidget(
                                  onTap: () async {
                                    showModalBottomSheet(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              topRight: Radius.circular(30)),
                                        ),
                                        context: context,
                                        builder: (context) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                                color: Colors.transparent,
                                                height: 200,
                                                child: ListView(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: ListTile(
                                                          title: const Text(
                                                            'Select to add images.',
                                                            style: TextStyle(
                                                                fontSize: 20),
                                                          ),
                                                          trailing: IconButton(
                                                            icon: const Icon(Icons
                                                                .highlight_remove_rounded),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          )),
                                                    ),
                                                    const Divider(
                                                      thickness: 0.8,
                                                    ),
                                                    ListTile(
                                                      leading: const Icon(
                                                        Icons.photo,
                                                        color: Color.fromRGBO(
                                                            148, 92, 254, 1),
                                                      ),
                                                      title: const Text(
                                                          'Pick images in gallery.'),
                                                      trailing: const Icon(Icons
                                                          .navigate_next_rounded),
                                                      onTap: () {
                                                        selectImageGallery();
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    ListTile(
                                                      leading: const Icon(
                                                        Icons.camera_alt,
                                                        color: Color.fromRGBO(
                                                            148, 92, 254, 1),
                                                      ),
                                                      title: const Text(
                                                          'Take a picture.'),
                                                      trailing: const Icon(Icons
                                                          .navigate_next_rounded),
                                                      onTap: () {
                                                        selectImageCamera();
                                                        Navigator.pop(context);
                                                      },
                                                    )
                                                  ],
                                                )),
                                          );
                                        });
                                  },
                                  child: _imageByte != null
                                      ? Image.memory(
                                          _imageByte![0],
                                          fit: BoxFit.cover,
                                          width: 180,
                                          height: 180,
                                        )
                                      : Image.network(
                                          'https://storage.googleapis.com/noseason/${user['profile_image']}',
                                          fit: BoxFit.cover,
                                          width: 180,
                                          height: 180,
                                        )),
                            )),
                            Positioned(
                              bottom: 0,
                              right: 4,
                              child: ClipOval(
                                child: Container(
                                  padding: const EdgeInsets.all(4.0),
                                  color: Colors.white,
                                  child: ClipOval(
                                    child: Container(
                                      padding: EdgeInsets.all(8.0),
                                      color: const Color(0xff945CFE),
                                      child: const Icon(
                                        Icons.edit,
                                        size: 20.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Form(
                          key: _formkey,
                          child: Column(
                            children: [
                              TextFormField(
                                maxLength: 20,
                                initialValue: user['username'],
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 10.0, 20.0, 10.0),
                                  filled: true,
                                  fillColor: Color(0xfff1f3f4),
                                  hintText: 'Topic',
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'You must to fill this field.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  setState(() {
                                    username = value;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              LayoutBuilder(builder: (context, constraints) {
                                return SizedBox(
                                  child: TextFormField(
                                    maxLength: 150,
                                    initialValue: user['bio'],
                                    decoration: const InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20.0, 10.0, 20.0, 10.0),
                                      hintText: 'Describe yourself here.',
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                    maxLines: 7,
                                    minLines: 4,
                                    onSaved: (value) {
                                      setState(() {
                                        bio = value;
                                      });
                                    },
                                  ),
                                );
                              })
                            ],
                          )),
                    )
                  ],
                ))
              : const Center(
                  child: CircularProgressIndicator(),
                )),
    );
  }
}

updateUser(token, username, bio, _imageName) async {
  var url = 'http://10.0.2.2:3000/auth/update';
  final http.Response response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, dynamic>{
          'token': token!,
          'username': username,
          'bio': bio,
          'profile_image': _imageName
        },
      ));
  var result = jsonDecode(response.body);
  return result;
}

checkAchievement(index) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  var url = 'http://10.0.2.2:3000/achievement/checkSuccess';
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
