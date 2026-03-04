import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/interests/widgets/interests_button_actions.dart';
import 'package:auth/presentation/interests/widgets/interests_grid_view.dart';
import 'package:auth/presentation/interests/widgets/interests_header.dart';
import 'package:auth/presentation/interests/widgets/search_box.dart';
import 'package:auth/presentation/manager/profile_cubit/interests/select_interests_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavouriteTeamsView extends StatefulWidget {
  final bool isEditTeams;
  const FavouriteTeamsView({super.key, this.isEditTeams = false});

  @override
  State<FavouriteTeamsView> createState() => _FavouriteTeamsViewState();
}

class _FavouriteTeamsViewState extends State<FavouriteTeamsView> {
  @override
  void initState() {
    super.initState();
    context.read<SelectInterestsCubit>().loadTeams(
      isEdit: widget.isEditTeams,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Column(
        children: [
          InterestsHeader(
            title: l10n.favTeamsTitle,
            subTitle: l10n.favTeamsDesc,
          ),
          const SearchBox(isTeams: true,),
          InterestsGridView(isTeams: true, isEdit: widget.isEditTeams),
          InterestsButtonActions(isTeams: true, isEdit: widget.isEditTeams),
        ],
      ),
    );
  }
}
