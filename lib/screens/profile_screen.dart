

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
        begin: Colors.grey,
        end: Color(0xffFF6AD5),
      ),
    ),
    TweenSequenceItem(
      weight: 1,
      tween: ColorTween(
        begin: const Color(0xffFF6AD5),
        end: const Color(0xffC774E8),
      ),
    ),
    TweenSequenceItem(
      weight: 1,
      tween: ColorTween(
        begin: const Color(0xffC774E8),
        end: const Color(0xffAD8CFF),
      ),
    ),
    TweenSequenceItem(
      weight: 1,
      tween: ColorTween(
        begin: const Color(0xffAD8CFF),
        end: const Color(0xff8795E8),
      ),
    ),
    TweenSequenceItem(
      weight: 1,
      tween: ColorTween(
        begin: const Color(0xff8795E8),
        end: const Color(0xff94D0FF),
      ),
    ),
  ]).animate(_controller);

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds:10000),
      value: 0.0,
      lowerBound: 0.0,
      upperBound: 1.0,
    )..repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
          backgroundColor:  animation.value,
          body: AnimatedTextKit(
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
    );
  }
}
