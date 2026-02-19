import 'package:auth/core/styels.dart';
import 'package:auth/injection_container.dart' as di;
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/manager/stats_cubit/stats_cubit.dart';
import 'package:auth/presentation/stats/widgets/stats_bloc_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatsScreenView extends StatelessWidget {
  const StatsScreenView({super.key});

 @override
Widget build(BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  return BlocProvider(
    create: (context) => di.sl<StatsCubit>()..loadStats(), 
    child: Scaffold(
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: Text(l10n.matches, style: Styles.textStyle30),
      ),
      body: const StatsBlocBuilder(),
    ),
  );
}
}
