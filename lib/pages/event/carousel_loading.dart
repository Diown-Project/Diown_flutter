import 'package:carousel_slider/carousel_slider.dart';
import 'package:diown/pages/event/EventPage.dart';
import 'package:page_transition/page_transition.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CarouselLoading extends StatefulWidget {
  const CarouselLoading({ Key? key }) : super(key: key);

  @override
  _CarouselLoadingState createState() => _CarouselLoadingState();
}

class _CarouselLoadingState extends State<CarouselLoading> {
  int activeIndex = 0;
  final event = [
    'images/event.png',
    'images/event.png',
    'images/event.png',
    'images/event.png',
    'images/event.png'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Event',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: EventPage(),
                    ),
                  );
                },
                child: Container(
                  width: 80,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Color(0xff8b82ff),
                    borderRadius: BorderRadius.all(Radius.circular(25))
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text(
                          'More',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white
                          ),
                        ),
                        const Icon(
                          MdiIcons.chevronRight,
                          color: Colors.white,
                        )
                      ]
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        CarouselSlider.builder(
          itemCount: event.length,
          options: CarouselOptions(
            viewportFraction: 1,
            height: 270,
            enableInfiniteScroll: false,
            onPageChanged: (index , reason) =>
              setState(() => activeIndex = index)
          ),
          itemBuilder: (context, index, realIndex) {
            return Container(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
              decoration: const BoxDecoration(
                color: Color(0xfff1f3f4),
                borderRadius: BorderRadius.all(Radius.circular(15))
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset(
                        event[index],
                        // fit: BoxFit.cover,
                        height: 150,
                        width: double.infinity,
                      )
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'San, Dec 25',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Christmas & thanksgiving event',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              MdiIcons.mapMarker,
                              color: Colors.black54,
                            ),
                            const Text(
                              'central world',
                              style: TextStyle(
                                color: Colors.black54
                              ),
                            )
                          ],
                        ),
                        const Text(
                          '200+ putdown',
                          style: TextStyle(
                            color: Colors.black54
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            );
          }, 
        ),
        const SizedBox(height: 10),
        buildIndicator(),
      ],
    );
  } 

  Widget buildIndicator() => AnimatedSmoothIndicator(
    activeIndex: activeIndex,
    count: event.length,
    effect: const SlideEffect(
      dotWidth: 10,
      dotHeight: 10,
      activeDotColor: Colors.black54,
      dotColor: Colors.black12
    ),
  );

}


