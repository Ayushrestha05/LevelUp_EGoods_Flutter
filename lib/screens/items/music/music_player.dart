import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:levelup_egoods/screens/items/music/page_manager.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:levelup_egoods/widgets/buttons.dart';

class MusicPlayer extends StatefulWidget {
  final int id;
  final String url;
  final String trackName;
  final String albumName;
  final String image;
  MusicPlayer(
      {Key? key,
      required this.id,
      required this.url,
      required this.albumName,
      required this.trackName,
      required this.image})
      : super(key: key);

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  late final PageManager _pageManager;

  @override
  void initState() {
    super.initState();
    _pageManager = PageManager(widget.url);
  }

  @override
  void dispose() {
    _pageManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Container(
            margin: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                    alignment: Alignment.centerLeft,
                    child: buildBackButton(context)),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Hero(
                        tag: 'itemImage${widget.id}',
                        child: CachedNetworkImage(
                          imageUrl: widget.image,
                          placeholder: (context, url) => Container(
                            // height: 100,
                            // width: 100,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) {
                            if (error != null) {
                              print(error);
                            }
                            return const Icon(Icons.error);
                          },
                          imageBuilder: (context, imageProvider) => Container(
                            height: rWidth(270),
                            width: rWidth(270),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    fit: BoxFit.cover, image: imageProvider)),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: rWidth(20),
                      ),
                      Text(
                        widget.trackName,
                        style: TextStyle(
                            fontFamily: 'Gotham',
                            fontSize: rWidth(18),
                            color:
                                Theme.of(context).textTheme.bodyText1!.color),
                      ),
                      SizedBox(
                        height: rWidth(10),
                      ),
                      Text(
                        widget.albumName,
                        style: TextStyle(
                            fontFamily: 'Gotham',
                            fontSize: rWidth(12),
                            color:
                                Theme.of(context).textTheme.bodyText1!.color),
                      ),
                    ],
                  ),
                ),
                ValueListenableBuilder<ProgressBarState>(
                  valueListenable: _pageManager.progressNotifier,
                  builder: (_, value, __) {
                    return ProgressBar(
                      timeLabelTextStyle: TextStyle(
                          fontFamily: 'Gotham',
                          fontSize: 14,
                          color: Theme.of(context).textTheme.bodyText1!.color),
                      progress: value.current,
                      buffered: value.buffered,
                      total: value.total,
                      onSeek: _pageManager.seek,
                    );
                  },
                ),
                ValueListenableBuilder<ButtonState>(
                  valueListenable: _pageManager.buttonNotifier,
                  builder: (_, value, __) {
                    switch (value) {
                      case ButtonState.loading:
                        return Container(
                          margin: const EdgeInsets.all(8.0),
                          width: 32.0,
                          height: 32.0,
                          child: const CircularProgressIndicator(),
                        );
                      case ButtonState.paused:
                        return IconButton(
                          icon: Icon(Icons.play_arrow,
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color),
                          iconSize: rWidth(32.0),
                          onPressed: _pageManager.play,
                        );
                      case ButtonState.playing:
                        return IconButton(
                          icon: Icon(Icons.pause,
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color),
                          iconSize: rWidth(32.0),
                          onPressed: _pageManager.pause,
                        );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
