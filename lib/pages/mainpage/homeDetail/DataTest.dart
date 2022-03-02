class DataTest {
  String eventImg;
  String date;
  String eventName;
  String location;
  String putDown;

  DataTest(this.eventImg, this.date, this.eventName, this.location, this.putDown);

  static List<DataTest> generateCourses(){
    return [
      DataTest('images/event.png', 'San, Dec 25', 'christmas event', 'central world', '200 + put down'),
      DataTest('images/event.png', 'San, Dec 26', 'christmas event', 'central world', '200 + put down'),
      DataTest('images/event.png', 'San, Dec 27', 'christmas event', 'central world', '200 + put down'),
      DataTest('images/event.png', 'San, Dec 28', 'christmas event', 'central world', '200 + put down'),
      DataTest('images/event.png', 'San, Dec 29', 'christmas event', 'central world', '200 + put down'),
    ];
  }


}