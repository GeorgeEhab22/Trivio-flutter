import 'package:auth/core/styels.dart';
import 'package:auth/presentation/stats/widgets/stats_bloc_builder.dart';
import 'package:flutter/material.dart';

class StatsScreenView extends StatelessWidget {
  const StatsScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text("Stats", style: Styles.textStyle30),
      ),
      body: StatsBlocBuilder(),
    );
  }
}
