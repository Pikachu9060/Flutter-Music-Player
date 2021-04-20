import 'package:flutter/material.dart';
import 'package:flutter_app/Model/Music.dart';
import 'package:flutter_app/Screens/MusicScreen.dart';
import 'package:flutter_app/Widget/CustomIcon.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AudioPlayer _audioPlayer = new AudioPlayer();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void playNextSong(Music music) {
    if (music.songsList.length - 1 > music.songIndex) {
      music.isPlaying = false;
      _audioPlayer
          .play(music.songsList[music.songIndex + 1].path, isLocal: true)
          .whenComplete(() {
        music.songIndex += 1;
        music.path = music.songsList[music.songIndex].path;
        music.isPlaying = true;
      });
    } else {
      music.isPlaying = false;
      music.isPlaying;
    }
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<Music>(
      builder: (context, music, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 1,
            backgroundColor: Color(0xFFE5EEFC),
            centerTitle: true,
            title: Text(
              "My Music",
              style: TextStyle(
                letterSpacing: 1,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          backgroundColor: Color(0xFFE5EEFC),
          body: Container(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: FutureBuilder(
                future: music.Songs,
                builder: (context, snapshot) {
                  return ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (_, index) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: music.isPlaying && music.songIndex == index
                              ? Colors.blueGrey
                              : Colors.transparent,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${snapshot.data[index].path.toString().split('/').last}",
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  CustomIcon(
                                    height: 50,
                                    width: 50,
                                    child: music.isPlaying &&
                                            music.songIndex == index
                                        ? Icon(Icons.pause)
                                        : Icon(Icons.play_arrow),
                                    function: () async {
                                      music.path =
                                          music.songsList.elementAt(index).path;

                                      if (_audioPlayer.state ==
                                              AudioPlayerState.PLAYING &&
                                          music.songIndex == index) {
                                        music.isPlaying = false;
                                        await _audioPlayer.pause();
                                      } else {
                                        music.isPlaying = true;
                                        _audioPlayer
                                            .play(
                                                snapshot.data
                                                    .elementAt(index)
                                                    .path,
                                                isLocal: true)
                                            .then(
                                          (value) {
                                            music.songIndex = index;
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MusicScreen(
                                                  audioPlayer: _audioPlayer,
                                                  index: index,
                                                  songPath: music.path,
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
