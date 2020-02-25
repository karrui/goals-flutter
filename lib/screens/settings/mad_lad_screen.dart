import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class MadLadScreen extends StatefulWidget {
  @override
  _MadLadScreenState createState() => _MadLadScreenState();
}

class _MadLadScreenState extends State<MadLadScreen> {
  ConfettiController _controller;

  @override
  void initState() {
    _controller = ConfettiController(duration: Duration(seconds: 30));
    _controller.play();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 80.0),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: ConfettiWidget(
                confettiController: _controller,
                blastDirection: -pi / 2,
                emissionFrequency: 0.01,
                numberOfParticles: 15,
                shouldLoop: true,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: ConfettiWidget(
                confettiController: _controller,
                blastDirection: -pi / 4,
                emissionFrequency: 0.02,
                numberOfParticles: 8,
                shouldLoop: true,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: ConfettiWidget(
                confettiController: _controller,
                blastDirection: (pi / 4) - pi,
                emissionFrequency: 0.02,
                numberOfParticles: 8,
                shouldLoop: true,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "You actually did it!",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "Seriously though, I really appreciate it. Thank you so much for supporting me!",
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(fontSize: 20, fontWeight: FontWeight.w400),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
