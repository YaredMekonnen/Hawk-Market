import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hawk_app/commons/widgets/circular_profile.dart';
import 'package:hawk_app/commons/widgets/custom_network_image.dart';
import 'package:hawk_app/home/blocs/load_story_bloc/load_story_bloc.dart';
import 'package:hawk_app/home/models/story.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoryPage extends StatefulWidget {
  final String id;
  final String from;

  StoryPage({required this.id, required this.from});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  late Story story;
  late int storyIndex;
  PageController? _pageController;
  Timer? _timer;
  int _currentPage = 0;
  bool _isPaused = false;
  Timer? _progressTimer;
  double progressVal = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    storyIndex = context
        .read<LoadStoryBloc>()
        .stories
        .indexWhere((element) => element.id == widget.id);
    story = context.read<LoadStoryBloc>().stories[storyIndex];
    _startTimer();
    _progress();
  }

  @override
  void dispose() {
    _pageController!.dispose();
    _timer?.cancel();
    _progressTimer?.cancel();
    super.dispose();
  }

  void _findNextStory() {
    if (storyIndex < context.read<LoadStoryBloc>().stories.length - 1) {
      story = context.read<LoadStoryBloc>().stories[storyIndex + 1];
    } else {
      GoRouter.of(context).go(widget.from);
    }

    setState(() {
      storyIndex++;
    });
  }

  void _progress() {
    progressVal = 0;
    if (_progressTimer != null) {
      _progressTimer!.cancel();
    }
    _progressTimer = Timer.periodic(
      Duration(milliseconds: 100),
      (timer) {
        if (!_isPaused) {
          if (_currentPage <= story.photos.length - 1) {
            setState(
              () {
                progressVal = progressVal + 1;
              },
            );
          }
        }
      },
    );
  }

  void _startTimer() {
    _timer = Timer.periodic(
      Duration(seconds: 5),
      (timer) {
        if (!_isPaused) {
          if (_currentPage < story.photos.length - 1) {
            _currentPage++;
            _pageController!.animateToPage(
              _currentPage,
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
            _progress();
          } else if (_currentPage == story.photos.length - 1) {
            _findNextStory();
            _timer?.cancel();
            _startTimer();
            _progress();
            _currentPage = 0;
          } else {
            _progress();
            _progressTimer!.cancel();
            _timer!.cancel();
          }
        }
      },
    );
  }

  void _pause() {
    setState(() {
      _isPaused = true;
      _timer?.cancel();
    });
  }

  void _resume() {
    setState(() {
      _isPaused = false;
      _startTimer();
    });
  }

  void _nextStory() {
    if (_currentPage < story.photos.length - 1) {
      setState(() {
        _currentPage++;
        _pageController!.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _timer?.cancel();
        _startTimer();
        _progress();
      });
    }
  }

  void _previousStory() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
        _pageController!.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _timer?.cancel();
        _startTimer();
        _progress();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: GestureDetector(
        onTapDown: (details) {
          if (details.globalPosition.dx <
              MediaQuery.of(context).size.width / 2) {
            _previousStory();
          } else {
            _nextStory();
          }
        },
        onLongPress: _pause,
        onLongPressUp: _resume,
        child: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
                controller: _pageController,
                itemCount: story.photos.length,
                itemBuilder: (context, index) {
                  return CustomeNetworkImage(imageUrl: story.photos[index]);
                },
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                    _timer?.cancel();
                    _startTimer();
                  });
                }),
            Positioned(
              top: 40,
              left: 10,
              right: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(story.photos.length, (indicatorIndex) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: LinearProgressIndicator(
                        value: indicatorIndex < _currentPage
                            ? 1.0
                            : indicatorIndex == _currentPage
                                ? (progressVal / 50)
                                : 0.0,
                        backgroundColor: Colors.grey,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Positioned(
              top: 60,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      RoudndedSquareProfile(
                          length: 12, profileUrl: story.owner.profileUrl),
                      SizedBox(width: 2.4.w),
                      Text(
                        story.owner.username,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      GoRouter.of(context).go(widget.from);
                    },
                    icon: Icon(Icons.close),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
