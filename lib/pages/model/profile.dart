import 'package:diown/pages/model/achievement.dart';
import 'package:diown/pages/model/moodchart.dart';

class Profile {
  String? imgUrl;
  String? name;
  String? desc;
  int? following;
  int? follower;
  int? putdown;
  List<Achievement>? achieve;
  List<MoodChart>? mood;

  Profile({
    this.imgUrl,
    this.name,
    this.desc,
    this.following,
    this.follower,
    this.putdown,
    this.achieve,
    this.mood,
  });

  static Profile generateProfile() {
    return Profile(
        imgUrl: 'assets/avatar.jpg',
        name: 'Non Thanadon',
        desc:
            'Hello I love to write diary if you like diary writing too. nice to meet you Dont forget to follow me as I keep writing in my diary when I have free time.',
        following: 500,
        follower: 2000,
        putdown: 40,
        achieve: [
          Achievement(
              achUrl: 'images/profile.png',
              achName: 'achieve 1',
              detail:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas volutpat, nisi vel vehicula dapibus, nunc est sodales nulla, at viverra.',
              succeed: true),
          Achievement(
              achUrl: 'images/Make_A_Secret.png',
              achName: 'achieve 2',
              detail:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas volutpat, nisi vel vehicula dapibus, nunc est sodales nulla, at viverra.',
              succeed: true),
          Achievement(
              achUrl: 'images/Picture_Memory.png',
              achName: 'achieve 3',
              detail:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas volutpat, nisi vel vehicula dapibus, nunc est sodales nulla, at viverra.',
              succeed: true),
          Achievement(
              achUrl: 'images/4.png',
              achName: 'achieve 4',
              detail:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas volutpat, nisi vel vehicula dapibus, nunc est sodales nulla, at viverra.',
              succeed: false),
          Achievement(
              achUrl: 'images/5.png',
              achName: 'achieve 5',
              detail:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas volutpat, nisi vel vehicula dapibus, nunc est sodales nulla, at viverra.',
              succeed: false),
          Achievement(
              achUrl: 'images/6.png',
              achName: 'achieve 6',
              detail:
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas volutpat, nisi vel vehicula dapibus, nunc est sodales nulla, at viverra.',
              succeed: false),
        ],
        mood: [
          MoodChart(moodName: 'smiley', moodUrl: '😃', moodtotal: 6),
          MoodChart(
            moodName: 'joy',
            moodUrl: '😂',
            moodtotal: 8,
          ),
          MoodChart(moodName: 'cazy', moodUrl: ' 🤪', moodtotal: 5),
          MoodChart(moodName: 'exploding', moodUrl: '🤯 ', moodtotal: 8),
          MoodChart(moodName: 'flushed', moodUrl: '😳', moodtotal: 10),
          MoodChart(moodName: 'cry', moodUrl: '😭', moodtotal: 12),
          MoodChart(moodName: 'triumph', moodUrl: '😤', moodtotal: 7),
        ]);
  }
}
