import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:levelup_egoods/screens/items/music/page_manager.dart';
import 'package:levelup_egoods/widgets/buttons.dart';

class MusicPlayer extends StatefulWidget {
  dynamic itemData;
  final String url;
  final String trackName;
  MusicPlayer(
      {Key? key,
      required this.url,
      required this.itemData,
      required this.trackName})
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
                        tag: 'itemImage${widget.itemData['id']}',
                        child: CachedNetworkImage(
                          imageUrl: widget.itemData['item_image'],
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
                            height: 300,
                            width: 300,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    fit: BoxFit.cover, image: imageProvider)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        widget.trackName,
                        style: TextStyle(
                            fontFamily: 'Gotham',
                            fontSize: 18,
                            color:
                                Theme.of(context).textTheme.bodyText1!.color),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.itemData['item_name'],
                        style: TextStyle(
                            fontFamily: 'Gotham',
                            fontSize: 14,
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
                          iconSize: 32.0,
                          onPressed: _pageManager.play,
                        );
                      case ButtonState.playing:
                        return IconButton(
                          icon: Icon(Icons.pause,
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color),
                          iconSize: 32.0,
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
