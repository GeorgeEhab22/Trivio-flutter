import 'package:auth/constants/colors.dart';
import 'package:auth/core/styels.dart';
import 'package:auth/data/models/stats_dart/matches.dart';
import 'package:auth/presentation/manager/stats_cubit/stats_cubit.dart';
import 'package:auth/presentation/stats/widgets/match_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StatsBlocBuilder extends StatelessWidget {
  const StatsBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StatsCubit, StatsState>(
      builder: (context, state) {
        if (state is StatsLoading) {
          return Skeletonizer(
            enabled: true,
            effect: PulseEffect(
              from: AppColors.customGrey.withValues(alpha: .1),

              to: AppColors.primary.withValues(alpha: 0.2),
              duration: const Duration(milliseconds: 1500),
            ),
            child: ListView.builder(
              itemCount: 5,
              itemBuilder: (context, index) =>
                  const MatchTile(match: Matches()),
            ),
          );
        } else if (state is StatsLoaded) {
          final matches = state.matches;
          if (matches.isEmpty) {
            return Center(
              child: Text("No matches found", style: Styles.textStyle16),
            );
          }
          return ListView.builder(
            itemCount: matches.length,
            itemBuilder: (context, index) {
              return MatchTile(match: matches[index]);
            },
          );
        } else if (state is StatsError) {
          return Center(child: Text(state.message, style: Styles.textStyle16));
        }
        return const SizedBox.shrink();
      },
    );
  }
}
