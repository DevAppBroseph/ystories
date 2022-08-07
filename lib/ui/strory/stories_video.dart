import 'dart:async';

import 'package:cached_video_player/cached_video_player.dart';
import 'package:circle_progress_bar/circle_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:story_time/story_page_view/story_page_view.dart';
import 'package:y_storiers/bloc/story/story_bloc.dart';
import 'package:y_storiers/bloc/story/story_event.dart';
import 'package:y_storiers/bloc/story/story_state.dart';
import 'package:y_storiers/services/constants.dart';

class StoriesVideo extends StatefulWidget {
  StoriesVideo({
    Key? key,
    required this.url,
    required this.pause,
    required this.loaded,
    required this.duration,
    required this.indicatorAnimationController,
    this.main,
  }) : super(key: key);

  String url;
  Function() pause;
  Function(Duration) loaded;
  Function(Duration) duration;
  ValueNotifier<IndicatorAnimationCommand> indicatorAnimationController;
  bool? main;

  @override
  State<StoriesVideo> createState() => _StoriesVideoState();
}

class _StoriesVideoState extends State<StoriesVideo> {
  CachedVideoPlayerController? _controller;
  @override
  void initState() {
    widget.pause();
    _setController();
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _setController() {
    widget.pause();
    // print('indicator: ' +
    //     widget.indicatorAnimationController.value.pause.toString());

    BlocProvider.of<StoryBloc>(context).add(LoadStory());
    // print(widget.url);
    _controller = CachedVideoPlayerController.network(mediaUrl + widget.url)
      ..initialize().then((_) {
        widget.pause();
        _controller!.play();
        _controller!.setVolume(1);
        widget.duration(_controller!.value.duration);
        // setState(() {});
      }).onError((error, stackTrace) {});
    // print(_controller?.dataSource);

    _controller?.addListener(() {
      if (mediaUrl + widget.url != _controller?.dataSource) {
        _controller?.dispose();
        _setController();
      }
    });
    _addListener();
  }

  void _addListener() {
    _controller?.addListener(() async {
      if (_controller != null) {
        if (_controller!.value.isPlaying &&
            _controller!.value.position.inMilliseconds != 0) {
          if (widget.indicatorAnimationController.value.pause == true) {
            widget.loaded(_controller!.value.duration);
            BlocProvider.of<StoryBloc>(context).add(LoadedStory(
              duration: _controller!.value.duration,
            ));
          }
        }
      } else {
        widget.pause();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _postVideo(
      context,
    );
  }

  Widget _postVideo(BuildContext context) {
    if (_controller != null) {
      return BlocBuilder<StoryBloc, StoryState>(builder: (context, snapshot) {
        if (snapshot is StoryPaused) {
          _controller?.pause();
        }
        if (snapshot is StoryResumed) {
          _controller?.play();
        }
        return Container(
          color: Colors.grey[900],
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Center(
                child: GestureDetector(
                  onTap: () {
                    if (_controller!.value.volume > 0) {
                      _controller!.setVolume(0);
                    } else {
                      _controller!.setVolume(1.0);
                    }
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: FittedBox(
                      clipBehavior: Clip.antiAlias,
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: _controller!.value.size.width,
                        height: _controller!.value.size.height,
                        child: CachedVideoPlayer(_controller!),
                      ),
                    ),
                  ),
                ),
              ),
              if (!_controller!.value.isInitialized ||
                  _controller!.value.isBuffering)
                Center(
                  child: Container(
                    height: 80,
                    width: 80,
                    // decoration: BoxDecoration(
                    //   shape: BoxShape.circle,
                    //   border: Border.all(
                    //     width: 2,
                    //     color: Colors.grey[800]!,
                    //   ),
                    // ),
                    child: CircleProgressBar(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.grey[400],
                      strokeWidth: 3,
                      value: 0.8,
                    ),
                  ),
                ),
            ],
          ),
        );
      });
    } else {
      return Container();
    }
  }
}
