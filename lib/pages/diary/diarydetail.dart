import 'dart:convert';
import 'package:card_swiper/card_swiper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:diown/pages/diary/choosediary.dart';
import 'package:diown/pages/diary/editlocaldiary.dart';
import 'package:diown/pages/mainpage/calendar.dart';
import 'package:flutter/cupertino.dart';
import 'package:ink_widget/ink_widget.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:badges/badges.dart';
import 'package:page_transition/page_transition.dart';
import 'package:extended_image/extended_image.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:photo_view/photo_view.dart';

class DiaryDetail extends StatefulWidget {
  const DiaryDetail({Key? key, required this.id}) : super(key: key);
  final id;
  @override
  _DiaryDetailState createState() => _DiaryDetailState();
}

class _DiaryDetailState extends State<DiaryDetail> {
  dynamic diary;
  var time;
  var isFav;
  findDetail(id) async {
    var url = 'http://ec2-175-41-169-93.ap-southeast-1.compute.amazonaws.com:3000/localDiary/findDetail';
    final http.Response response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(
          <String, String>{'id': id},
        ));
    var result = jsonDecode(response.body);
    if (result == null) {
      diary = {};
      diary['message'] = 'This diary was deleted.';
      isFav = false;
      setState(() {});
    } else {
      setState(() {
        diary = result;
        time = DateFormat('EEE. MMM d / yyyy')
            .format(DateTime.parse(diary['date']));
        isFav = diary['favorite'];
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: diary != null
              ? diary.containsKey('message')
                  ? Text('This diary was deleted.')
                  : Text('${time}')
              : Text('wait. . .'),
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          actions: [
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: isFav != null
                    ? diary.containsKey('message')
                        ? Container()
                        : StarButton(
                            iconSize: 40,
                            isStarred: isFav,
                            valueChanged: (value) async {
                              setState(() {
                                isFav = value;
                              });
                              var d = await favorite(widget.id, isFav);
                            })
                    : const Center(
                        child: CircularProgressIndicator(),
                      )),
            diary != null
                ? diary.containsKey('message')
                    ? Container()
                    : PopupMenuButton(
                        itemBuilder: (context) => [
                              PopupMenuItem(
                                  onTap: () {
                                    Future.delayed(
                                        const Duration(seconds: 0),
                                        () => Navigator.push(
                                                    context,
                                                    PageTransition(
                                                        child: EditLocalDiary(
                                                            id: widget.id,
                                                            diary: diary),
                                                        type: PageTransitionType
                                                            .rightToLeft))
                                                .then((_) async {
                                              findDetail(widget.id);
                                              setState(() {});
                                            }));
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.edit,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 25,
                                      ),
                                      Text(
                                        'edit',
                                        style: TextStyle(fontSize: 14),
                                      )
                                    ],
                                  )),
                              PopupMenuItem(
                                  onTap: () {
                                    Future.delayed(
                                        const Duration(seconds: 0),
                                        () => CoolAlert.show(
                                            barrierDismissible: false,
                                            context: context,
                                            type: CoolAlertType.confirm,
                                            title: 'Are you sure?',
                                            text:
                                                'Do you want to delete this diary.',
                                            confirmBtnColor: Colors.red,
                                            onConfirmBtnTap: () async {
                                              CoolAlert.show(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  type: CoolAlertType.loading);
                                              var re =
                                                  await deleteLocaldiary(diary);
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            }));
                                  },
                                  padding: EdgeInsets.all(2),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.delete_forever_rounded,
                                        size: 20,
                                        color: Colors.red,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'remove',
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.red),
                                      )
                                    ],
                                  ))
                            ])
                : Container()
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              diary != null && diary['imageLocation'] != null
                  ? Container(
                      height: 300,
                      child: Swiper(
                        loop: false,
                        itemHeight: 300,
                        itemCount: diary['imageLocation'].length,
                        pagination: const SwiperPagination(
                            margin: EdgeInsets.all(15),
                            builder: DotSwiperPaginationBuilder(
                                activeColor: Colors.black,
                                color: Colors.white)),
                        layout: SwiperLayout.DEFAULT,
                        itemBuilder: (context, index) {
                          return Container(
                            alignment: Alignment.center,
                            child: InkWell(
                              child: Ink.image(
                                image: NetworkImage(
                                  'https://storage.googleapis.com/noseason/${diary['imageLocation'][index]}',
                                ),
                                height: 300,
                                fit: BoxFit.cover,
                              ),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => GalleryWidget(
                                    diary: diary,
                                    index: index,
                                  ),
                                ));
                              },
                            ),
                          );
                        },
                      ),
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 0, 5),
                child: Row(
                  children: [
                    Flexible(
                      child: diary != null && diary['mood_emoji'] != null
                          ? Chip(
                              padding: EdgeInsets.all(0),
                              backgroundColor: Colors.grey[100],
                              label: Text(
                                  '${diary['mood_emoji']} ${diary['mood_detail']}',
                                  style: TextStyle(color: Colors.black)),
                            )
                          : Container(),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Flexible(
                        flex: 2,
                        child: diary != null && diary['activity'] != null
                            ? Chip(
                                padding: EdgeInsets.all(0),
                                backgroundColor: Colors.grey[100],
                                label: Text('${diary['activity']}',
                                    style: TextStyle(color: Colors.black)),
                              )
                            : Container()),
                  ],
                ),
              ),
              diary != null && diary['topic'] != null
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(23, 0, 8, 5),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '${diary['topic']}',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : Container(),
              diary != null && diary['detail'] != null
                  ? Padding(
                      padding: const EdgeInsets.fromLTRB(23, 0, 8, 5),
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${diary['detail']}',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  favorite(id, isFav) async {
    var url = 'http://ec2-175-41-169-93.ap-southeast-1.compute.amazonaws.com:3000/localDiary/fav';
    final http.Response response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(
          <String, dynamic>{'id': id, 'fav': isFav!},
        ));
    var result = jsonDecode(response.body);
    return result;
  }

  deleteLocaldiary(diary) async {
    var url = 'http://ec2-175-41-169-93.ap-southeast-1.compute.amazonaws.com:3000/localDiary/deleteLocalDiary';
    final http.Response response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(
          <String, dynamic>{'diary': diary},
        ));
    var result = jsonDecode(response.body);
    return result;
  }
}

class GalleryWidget extends StatefulWidget {
  dynamic diary;
  final int index;
  final PageController pageController;

  GalleryWidget({required this.diary, this.index = 0})
      : pageController = PageController(initialPage: index);

  @override
  _GalleryWidgetState createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  late int index = widget.index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.cancel, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '${index + 1} from ${widget.diary['imageLocation'].length}',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: PhotoViewGallery.builder(
        pageController: widget.pageController,
        itemCount: widget.diary['imageLocation'].length,
        builder: (context, index) {
          final diary = widget.diary[index];

          return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(
                  'https://storage.googleapis.com/noseason/${widget.diary['imageLocation'][index]}'),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.contained * 4);
        },
        onPageChanged: (index) => setState(() => this.index = index),
      ),
    );
  }
}
