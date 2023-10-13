import 'package:animate_do/animate_do.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_player_app/helpers/helpers.dart';
import 'package:music_player_app/providers/player_provider.dart';
import 'package:music_player_app/ui/widgets/widgets.dart';
import 'package:provider/provider.dart';

class MusicPlayerPage extends StatelessWidget {
  const MusicPlayerPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _Background(),
          const Column(
            children: [
              CustomAppBar(),
              _PlayerProgress(),
              _TitleAndPlay(),
              Expanded(child: _Lyrics())
            ],
          ),
        ],
      ),
    );
  }
}

class _Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      width: double.infinity,
      height: height * 0.75,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50)),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.center,
          colors: [
            Color(0xff33333E),
            Color(0xff201E28),
          ],
        ),
      ),
    );
  }
}

class _PlayerProgress extends StatelessWidget {
  const _PlayerProgress();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
      ),
      margin: const EdgeInsets.only(top: 70),
      child: const Row(
        children: [
          _DiskImage(),
          SizedBox(
            width: 40,
          ),
          _ProgressBar(),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }
}

class _DiskImage extends StatelessWidget {
  const _DiskImage();

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioPlayerProvider>(context);
    return Container(
      padding: const EdgeInsets.all(20),
      width: 230,
      height: 230,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          colors: [
            Color(0xff484750),
            Color(0xff1E1C24),
          ],
        ),
        borderRadius: BorderRadius.circular(200),
      ),
      child: SpinPerfect(
        duration: const Duration(seconds: 8),
        infinite: true,
        controller: (controller) => audioProvider.controller = controller,
        manualTrigger: true,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(200),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Image(
                  image: AssetImage('assets/images/aurora.jpg'),
                ),
                Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(100)),
                ),
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                      color: const Color(0xff1C1C25),
                      borderRadius: BorderRadius.circular(100)),
                ),
              ],
            )),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar();

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioPlayerProvider>(context);
    final percentage = audioProvider.percentage;
    return Column(
      children: [
        Text(
          audioProvider.songTotalDuration,
          style: TextStyle(color: Colors.white.withOpacity(0.4)),
        ),
        const SizedBox(
          height: 5,
        ),
        Stack(
          children: [
            Container(
              width: 3,
              height: 230,
              color: Colors.white.withOpacity(0.1),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: 3,
                height: 230 * percentage,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          audioProvider.currentSecond,
          style: TextStyle(color: Colors.white.withOpacity(0.4)),
        )
      ],
    );
  }
}

class _TitleAndPlay extends StatefulWidget {
  const _TitleAndPlay();

  @override
  State<_TitleAndPlay> createState() => _TitleAndPlayState();
}

class _TitleAndPlayState extends State<_TitleAndPlay>
    with SingleTickerProviderStateMixin {
  bool isPlaying = false;
  bool firstTime = true;
  late AnimationController controller;

  final assetAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void open() {
    final audioProvider =
        Provider.of<AudioPlayerProvider>(context, listen: false);

    assetAudioPlayer.open(Audio('assets/sounds/Breaking-Benjamin-Far-Away.mp3'),
        showNotification: true, autoStart: true);

    assetAudioPlayer.currentPosition.listen((duration) {
      /*
        This is a stream and will be providing us the moment in 
        which the song is playing. 
      */
      audioProvider.current = duration;
    });

    assetAudioPlayer.current.listen((duration) {
      /*
        Here we get the total duration of the song
      */

      audioProvider.songDuration =
          duration?.audio.duration ?? const Duration(seconds: 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      margin: const EdgeInsets.only(top: 40),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                'Far away',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              Text(
                '- Breaking Benjamin -',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ],
          ),
          const Spacer(),
          FloatingActionButton(
            elevation: 0,
            highlightElevation: 0,
            onPressed: () {
              final audioProvider =
                  Provider.of<AudioPlayerProvider>(context, listen: false);

              if (isPlaying) {
                controller.reverse();
                isPlaying = false;
                audioProvider.controller.stop();
              } else {
                controller.forward();
                isPlaying = true;
                audioProvider.controller.repeat();
              }

              if (firstTime) {
                open();
                firstTime = false;
              } else {
                assetAudioPlayer.playOrPause();
              }
            },
            backgroundColor: const Color(0xffF8CB51),
            child: AnimatedIcon(
                icon: AnimatedIcons.play_pause, progress: controller),
          )
        ],
      ),
    );
  }
}

class _Lyrics extends StatelessWidget {
  const _Lyrics();

  @override
  Widget build(BuildContext context) {
    final lyrics = getLyrics();
    return ListWheelScrollView(
      physics: const BouncingScrollPhysics(),
      diameterRatio: 1.5,
      itemExtent: 42,
      children: lyrics
          .map((verse) => Text(
                verse,
                style: TextStyle(
                    fontSize: 20, color: Colors.white.withOpacity(0.6)),
              ))
          .toList(),
    );
  }
}
