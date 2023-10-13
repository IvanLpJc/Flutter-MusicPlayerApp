import 'package:flutter/material.dart';
import 'package:music_player_app/providers/player_provider.dart';
import 'package:music_player_app/themes/theme.dart';
import 'package:music_player_app/ui/pages/music_player_page.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AudioPlayerProvider(),
      child: MaterialApp(
          title: 'Music Player',
          debugShowCheckedModeBanner: false,
          theme: myTheme,
          home: const MusicPlayerPage()),
    );
  }
}
