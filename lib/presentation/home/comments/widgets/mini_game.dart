import 'package:flutter/material.dart';
import 'dart:math';

class MiniGame extends StatefulWidget {
  const MiniGame({super.key});

  @override
  State<MiniGame> createState() => _MiniGameState();
}

class _MiniGameState extends State<MiniGame>
    with SingleTickerProviderStateMixin {
  double _ballX = 0;
  double _ballY = 0;
  bool _goalScored = false;
  double _goalieX = 0;
  bool _isShooting = false;

  @override
  void initState() {
    super.initState();
    _startGoalieMovement();
  }

  void _startGoalieMovement() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(milliseconds: 700));
      if (!mounted) return false;
      setState(() {
        _goalieX = (Random().nextDouble() * 2 - 1) * 0.8; // يتحرك يمين وشمال
      });
      return !_goalScored;
    });
  }

  void _shootBall() {
    if (_isShooting) return;
    setState(() => _isShooting = true);

    Future.microtask(() async {
      for (double y = _ballY; y <= 1.0; y += 0.05) {
        await Future.delayed(const Duration(milliseconds: 16));
        if (!mounted) return;
        setState(() => _ballY = y);
      }

      if ((_ballX - _goalieX).abs() < 0.3) {
        setState(() {
          _goalScored = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("😢 Saved by the goalkeeper!")),
        );

        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return;
        setState(() {
          _ballY = 0;
          _ballX = 0;
          _isShooting = false;
        });
      } else {
        setState(() {
          _goalScored = true;
        });
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.green[100],
      insetPadding: const EdgeInsets.all(30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: GestureDetector(
        onPanUpdate: (details) {
          if (_isShooting) return;
          setState(() {
            _ballX += details.delta.dx / 150;
            _ballX = _ballX.clamp(-1.0, 1.0);
          });
        },
        onTap: _shootBall,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          width: 300,
          height: 500,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [Colors.greenAccent, Colors.green],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 🥅 Goal
              const Positioned(
                top: 40,
                child: Text("🥅", style: TextStyle(fontSize: 50)),
              ),

              // 🧤 Goalie
              AnimatedPositioned(
                duration: const Duration(milliseconds: 500),
                top: 80,
                left: 150 + _goalieX * 100,
                child: const Icon(
                  Icons.sports_handball,
                  size: 40,
                  color: Colors.white,
                ),
              ),

              // ⚽ Ball
              AnimatedPositioned(
                duration: const Duration(milliseconds: 16),
                top: (1 - _ballY) * 320,
                left: 150 + _ballX * 100,
                child: const Icon(
                  Icons.sports_soccer,
                  size: 36,
                  color: Colors.black,
                ),
              ),

              // 🎯 Goal text
              if (_goalScored)
                const Positioned(
                  top: 130,
                  child: Text(
                    "GOAL!!! ⚽🔥",
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              // 💬 Instructions
              if (!_isShooting && !_goalScored)
                const Positioned(
                  bottom: 20,
                  child: Text(
                    "Drag to aim, tap to shoot ⚽",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
