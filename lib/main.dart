import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Animated Image Slideshow',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => ImageSlideshow(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class ImageSlideshow extends StatefulWidget {
  @override
  _ImageSlideshowState createState() => _ImageSlideshowState();
}

class _ImageSlideshowState extends State<ImageSlideshow>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late Timer _timer;
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _showCard = false;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.elasticInOut,
      ),
    );
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _showCard = true;
        // _gameLogic.speakWord(widget.question.word);
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _delayedStartSlideShow();
    });
  }

  @override
  void didUpdateWidget(covariant ImageSlideshow oldWidget) {
    super.didUpdateWidget(oldWidget);
    _delayedStartSlideShow();
  }

  // void _startSlideShow() {
  //   _timer = Timer.periodic(Duration(seconds: 5), (timer) {
  //     if (_currentIndex < imagePaths.length - 1) {
  //       setState(() {
  //         _currentIndex++;
  //         setState(() {
  //           _showCard = false;
  //         });
  //         Future.delayed(Duration(milliseconds: 500), () {
  //           setState(() {
  //             _showCard = true;
  //           });
  //         });
  //       });
  //     } else {
  //       _timer.cancel();
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => EndScreen()),
  //       );
  //     }
  //   });
  // }
  void _startSlideShow() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_currentIndex < imagePaths.length - 1) {
        setState(() {
          _currentIndex++;
        });
      } else {
        _timer.cancel();
        _animationController.stop();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EndScreen()),
        );
      }
    });
  }

/**
 void _startSlideShow() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_currentIndex < imagePaths.length - 1) {
        setState(() {
          _currentIndex++;
          setState(() {
            _showCard = false;
          });
          Future.delayed(Duration(milliseconds: 500), () {
            setState(() {
              _showCard = true;
            });
          });
        });
      } else {
        _timer.cancel();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EndScreen()),
        );
      }
    });
  }
 */
// */
  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _delayedStartSlideShow() async {
    await Future.delayed(Duration(seconds: 2));
    _startSlideShow();
  }

  List<String> imagePaths = [
    "assets/images/apples.png",
    "assets/images/bear.png",
    "assets/images/key.png",
    "assets/images/dog.png",
    "assets/images/pen.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animated Image Slideshow'),
      ),
      body: Center(
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              top: _showCard ? 15 : -400,
              left: 20,
              right: 20,
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(
                      scale: animation,
                      child: child,
                    ),
                  );
                },
                child: Card(
                  key: ValueKey<String>(imagePaths[_currentIndex]),
                  shadowColor: Colors.grey.shade800,
                  elevation: 10,
                  margin: EdgeInsets.all(5),
                  // color: _color ?? Colors.grey.shade50,
                  child: Container(
                    height: 200,
                    width: double.maxFinite,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return ScaleTransition(
                            scale: _animation,
                            child: child,
                          );
                        },
                        child: Image.asset(imagePaths[_currentIndex]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EndScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('End of Slideshow'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('End of Slideshow'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageSlideshow(),
                  ),
                );
              },
              child: Text('Restart'),
            ),
          ],
        ),
      ),
    );
  }
}

/*
"assets/images/apples.png",
    "assets/images/bear.png",
    "assets/images/key.png",
    "assets/images/dog.png",
    "assets/images/pen.png",

import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated Image Slideshow',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => ImageSlideshow(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class ImageSlideshow extends StatefulWidget {
  @override
  _ImageSlideshowState createState() => _ImageSlideshowState();
}

class _ImageSlideshowState extends State<ImageSlideshow> {
  int _currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _delayedStartSlideShow();
    });
  }

  @override
  void didUpdateWidget(covariant ImageSlideshow oldWidget) {
    super.didUpdateWidget(oldWidget);
   _delayedStartSlideShow();
  }

  void _startSlideShow() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_currentIndex < imagePaths.length - 1) {
        setState(() {
          _currentIndex++;
        });
      } else {
        _timer.cancel();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EndScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _delayedStartSlideShow() async {
    await Future.delayed(Duration(seconds: 2));
    _startSlideShow();
  }

  List<String> imagePaths = [
    "assets/images/apples.png",
    "assets/images/bear.png",
    "assets/images/key.png",
    "assets/images/dog.png",
    "assets/images/pen.png",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animated Image Slideshow'),
      ),
      body: Center(
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: Duration(seconds: 2),
              curve: Curves.easeInOut,
              top: _currentIndex == 0 ? 15 : -400,
              left: 20,
              right: 20,
              child: Card(
                shadowColor: Colors.grey.shade800,
                elevation: 10,
                margin: EdgeInsets.all(25),
                color: Colors.grey.shade50,
                child: Container(
                  height: 150,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Image.asset(imagePaths[_currentIndex]),
                  ),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: Duration(seconds: 2),
              curve: Curves.easeInOut,
              top: _currentIndex == 0 ? -400 : 15,
              left: 20,
              right: 20,
              child: Card(
                shadowColor: Colors.grey.shade800,
                elevation: 10,
                margin: EdgeInsets.all(25),
                color: Colors.grey.shade50,
                child: Container(
                  height: 150,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Image.asset(
                        imagePaths[(_currentIndex + 1) % imagePaths.length]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EndScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('End of Slideshow'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('End of Slideshow'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageSlideshow(),
                  ),
                );
              },
              child: Text('Restart'),
            ),
          ],
        ),
      ),
    );
  }
}




 */