import 'package:flutter/material.dart';

class Home extends StatefulWidget {

    @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  AnimationController _beamController;
  AnimationController _cowController;
  Animation<double> _cowAnimation;

  @override
  void initState() {
    super.initState();
    _beamController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    _beamController.addListener(() {
      if (_beamController.status == AnimationStatus.completed) {
        setState(() {
          _cowController.reset();
          _cowController.forward();
        });
      };
    });
    _cowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _cowController.addListener(() {
      if (_cowController.status == AnimationStatus.completed) {
        setState(() {
          _cowController.reset();
          _beamController.reset();
          _beamController.forward();
        });
      };
    });
    _cowAnimation = Tween<double>(begin: 0, end: 150).animate(_cowController);
    _beamController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AnimatedWidget"),),
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: <Widget>[
          Image.asset(
            'assets/images/stars.jpg',
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
          BeamTransition(animation: _beamController),
          AnimatedCow(animation: _cowAnimation),
          Image.asset('assets/images/ufo.png'),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _beamController.dispose();
    _cowController.dispose();
    super.dispose();
  }
}

class BeamTransition extends AnimatedWidget {
  BeamTransition({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);
  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return ClipPath(
      clipper: const BeamClipper(),
      child: Container(
        height: 1000,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            radius: 1.5,
            colors: [
              Colors.yellow,
              Colors.transparent,
            ],
            stops: [0, animation.value],
          ),
        ),
      ),
    );
  }
}

class BeamClipper extends CustomClipper<Path> {
  const BeamClipper();

  @override
  getClip(Size size) {
    return Path()
      ..lineTo(size.width / 2, size.height / 2)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..lineTo(size.width / 2, size.height / 2)
      ..close();
  }

  /// Return false always because we always clip the same area.
  @override
  bool shouldReclip(CustomClipper oldClipper) => false;
}

class AnimatedCow extends AnimatedWidget {
  AnimatedCow({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Positioned(
      bottom: animation.value*1.2,
      height: animation.value,
      width: animation.value,
      child: Image.asset('assets/images/cow.png',),
    );
  }
}