import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Widget/ScrollingText.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:flutter_app/Model/Music.dart';

// ignore: must_be_immutable
class MusicScreen extends StatefulWidget {
  MusicScreen({Key key, this.audioPlayer, this.songPath, this.index})
      : super(key: key);
  @required
  AudioPlayer audioPlayer;

  int index;
  Music music;
  @required
  String songPath;

  @override
  _MusicScreenState createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  double _width;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 20))
          ..repeat();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animationController.dispose();
    super.dispose();
  }

  void playNextSong(Music music) {
    if (music.songsList.length - 1 > music.songIndex) {
      music.isPlaying = false;
      widget.audioPlayer
          .play(music.songsList[music.songIndex + 1].path)
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

  void playPreviousSong(Music music) {
    if (music.songIndex + 1 > 0) {
      music.isPlaying = false;
      widget.audioPlayer
          .play(
        music.songsList[music.songIndex - 1].path,
        isLocal: true,
      )
          .whenComplete(() {
        music.path = music.songsList[music.songIndex - 1].path;
        music.songIndex -= 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        _width = MediaQuery.of(context).size.width;
        return Consumer<Music>(
          builder: (context, music, child) {
            return SafeArea(
              child: Scaffold(
                backgroundColor: Color(0xFFE5EEFC),
                body: Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Flexible(
                        flex: 1,
                        child: ScrollingText(
                          text: "${music.path.split('/').last}",
                          textStyle: TextStyle(fontFamily: "Mon"),
                        ),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      // musicLogoContainer(),
                      AnimatedBuilder(
                        animation: _animationController,
                        child: musicLogoContainer(),
                        builder: (BuildContext context, Widget child) {
                          return Transform.rotate(
                            angle: math.pi * _animationController.value * 2.0,
                            child: child,
                          );
                        },
                      ),
                      Spacer(),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            StreamBuilder(
                              stream: widget.audioPlayer.onAudioPositionChanged,
                              builder: (context, stream) {
                                if (mounted) {
                                  music.songCurrentLength = stream.data;
                                }
                                return Text(
                                  "${(double.parse(music.songCurrentLength?.inSeconds?.toString() ?? "00") / 60).toStringAsFixed(0)}:${(int.parse(music.songCurrentLength?.inSeconds?.toString() ?? "00") % 60)}",
                                  style: TextStyle(fontFamily: "Mon"),
                                );
                              },
                            ),
                            StreamBuilder(
                              stream: widget.audioPlayer.onAudioPositionChanged,
                              builder: (context, stream) {
                                if (mounted) {
                                  music.songCurrentLength = stream.data;
                                }
                                return Slider(
                                  activeColor: Colors.black.withOpacity(0.8),
                                  inactiveColor: Colors.black12,
                                  max: double.parse(music.songLength.inSeconds
                                              ?.toString() ??
                                          "00") ??
                                      1.0,
                                  min: 0,
                                  value: music.songCurrentLength != null
                                      ? double.parse(music
                                          .songCurrentLength?.inSeconds
                                          .toString())
                                      : 0,
                                  onChanged: (double value) {
                                    Duration duration =
                                        Duration(seconds: int.parse('$value'));
                                    widget.audioPlayer.seek(duration);
                                    music.songCurrentLength = duration;
                                  },
                                );
                              },
                            ),
                            StreamBuilder(
                              stream: widget.audioPlayer.onDurationChanged,
                              builder: (context, stream) {
                                if (mounted) {
                                  music.songLength = stream.data;
                                }
                                return Text(
                                  "${(double.parse(music.songLength?.inSeconds?.toString() ?? "00") ~/ 60).toStringAsFixed(0)}:${(int.parse(music.songLength?.inSeconds?.toString() ?? "00") % 60)}",
                                  style: TextStyle(fontFamily: "Mon"),
                                  overflow: TextOverflow.clip,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      StreamBuilder(
                          stream: widget.audioPlayer.onPlayerStateChanged,
                          builder: (context, stream) {
                            if (stream.data == AudioPlayerState.COMPLETED) {
                              playNextSong(music);
                            }

                            if (stream.data == AudioPlayerState.PLAYING) {
                              music.isPlaying = true;
                            }

                            return Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Spacer(),
                                InkWell(
                                  child: myIcon(Icon(Icons.skip_previous), 50),
                                  onTap: () {
                                    playPreviousSong(music);
                                  },
                                ),
                                Spacer(),
                                InkWell(
                                  onTap: () async {
                                    music.isPlaying
                                        ? await widget.audioPlayer
                                            .pause()
                                            .whenComplete(
                                                () => music.isPlaying = false)
                                        : await widget.audioPlayer
                                            .resume()
                                            .whenComplete(
                                                () => music.isPlaying = true);
                                  },
                                  child: myIcon(
                                    music.isPlaying
                                        ? Icon(Icons.pause)
                                        : Icon(Icons.play_arrow),
                                    80,
                                  ),
                                ),
                                Spacer(),
                                InkWell(
                                  child: myIcon(Icon(Icons.skip_next), 50),
                                  onTap: () {
                                    playNextSong(music);
                                  },
                                ),
                                Spacer(),
                              ],
                            );
                          }),
                      Spacer(),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget myIcon(Widget child, double size) {
    return Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Color(0xFF92AEFF),
              Colors.white,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xAA92AEFF).withOpacity(0.7),
              offset: Offset(10, 10),
              spreadRadius: 4,
              blurRadius: 30,
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.7),
              offset: Offset(-10, -10),
              spreadRadius: 2,
              blurRadius: 30,
            )
          ],
        ),
        alignment: Alignment.center,
        child: child);
  }

  Widget musicLogoContainer() {
    return Container(
      height: _width / 4 > 200 ? _width / 4 : 200,
      width: _width / 4 > 200 ? _width / 4 : 200,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/i.jpg'), fit: BoxFit.cover),
        color: Colors.white,
        shape: BoxShape.circle,
        /*border: Border.all(
          color: Color(0xff555555),
          width: 5,
        ),*/
        gradient: LinearGradient(
          colors: [
            Color(0xFFE5EEFC),
            Colors.white,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xff090010).withOpacity(0.7),
            offset: Offset(10, 10),
            spreadRadius: 10,
            blurRadius: 30,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.7),
            offset: Offset(-10, -10),
            spreadRadius: 10,
            blurRadius: 30,
          )
        ],
      ),
      alignment: Alignment.center,
      /*child: Image.asset(
        'assets/zakire.jpg',
        fit: BoxFit.fill,
      ),*/
    );
  }
}
