

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin{

  late AnimationController _controller;

  late final Animation<Color?> animation = TweenSequence<Color?>([
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: Colors.red,
        end: Colors.green,
      ) as Animatable<Color?>,
    ),
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: Colors.green,
        end: Colors.blue,
      ) as Animatable<Color?>,
    ),
    TweenSequenceItem(
      weight: 1.0,
      tween: ColorTween(
        begin: Colors.blue,
        end: Colors.pink,
      ) as Animatable<Color?>,
    ),
  ]).animate(_controller);

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 1000),
      value: 0.0,
      lowerBound: 0.0,
      upperBound: 1.0,
    )..forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.black38,
      body: AnimatedBuilder(
        builder: (context, child) {
          return Container(
            width: 150,
            height: 150,
            color: animation.value,
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Hello world!',
                  textStyle: const TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                  speed: const Duration(milliseconds:300),
                ),
                TypewriterAnimatedText(
                  'TEST1234!',
                  textStyle: const TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                  speed: const Duration(milliseconds: 300),
                )
              ],


              pause: const Duration(milliseconds: 1000),
              displayFullTextOnTap: true,
              stopPauseOnTap: true,
            ),
          );
        },
        animation: _controller,

      ),
    );
  }
}
