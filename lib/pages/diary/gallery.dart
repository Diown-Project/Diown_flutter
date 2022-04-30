import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:photo_view/photo_view.dart';

class GalleryWidget extends StatefulWidget {
  final dynamic diary;
  final int index;

  const GalleryWidget({Key? key, required this.diary, this.index = 0})
      : super(key: key);
// pageController = PageController(initialPage: index);
  @override
  _GalleryWidgetState createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  var numpic;
  dynamic diary;
  PageController? pageController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController(initialPage: widget.index);
    numpic = widget.index;
    diary = widget.diary;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.cancel, color: Colors.white),
            onPressed: () {
              Navigator.pop(context, 'eiei');
            },
          ),
          title: Text(
            '${numpic + 1} from ${diary['imageLocation'].length}',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          centerTitle: true,
        ),
        body: diary != null
            ? Container(
                child: PhotoViewGallery.builder(
                  pageController: pageController,
                  itemCount: diary != null ? diary['imageLocation'].length : 0,
                  builder: (context, index) {
                    return PhotoViewGalleryPageOptions(
                        imageProvider: NetworkImage(
                            'https://storage.googleapis.com/noseason/${diary['imageLocation'][index]}'),
                        minScale: PhotoViewComputedScale.contained,
                        maxScale: PhotoViewComputedScale.contained * 4);
                  },
                  onPageChanged: (index) => setState(() => numpic = index),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
