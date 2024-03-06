import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_portfolio/common/colors.dart';
import 'package:flutter_web_portfolio/components/bottom_control_pad.dart';
import 'package:flutter_web_portfolio/constants/file_path.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  Size get _size => MediaQuery.sizeOf(context);

  late AnimationController _controller;

  late final Animation<Color?> animation = TweenSequence<Color?>([
    TweenSequenceItem(
      weight: 1,
      tween: ColorTween(
        begin: AppColor.toneGray,
        end: AppColor.tweenFirst,
      ),
    ),
    TweenSequenceItem(
      weight: 1,
      tween: ColorTween(
        begin: AppColor.tweenFirst,
        end: AppColor.tweenSecond,
      ),
    ),
    TweenSequenceItem(
      weight: 1,
      tween: ColorTween(
        begin: AppColor.tweenSecond,
        end: AppColor.tweenThird,
      ),
    ),
    TweenSequenceItem(
      weight: 1,
      tween: ColorTween(
        begin: AppColor.tweenThird,
        end: AppColor.tweenFourth,
      ),
    ),
    TweenSequenceItem(
      weight: 1,
      tween: ColorTween(
        begin: AppColor.tweenFourth,
        end: AppColor.tweenFifth,
      ),
    ),
  ]).animate(_controller);

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 20000),
      value: 0,
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
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Scaffold(
              backgroundColor: animation.value,
              body: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      backgroundBlendMode: BlendMode.darken,
                      color: Colors.black54,
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          '$TEXTURE/ag-square.png',
                        ),
                        repeat: ImageRepeat.repeat,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        const BottomControlPanel()
      ],
    );
  }
}
