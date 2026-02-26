import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/interests/widgets/interests_button_actions.dart';
import 'package:auth/presentation/interests/widgets/interests_grid_view.dart';
import 'package:auth/presentation/interests/widgets/interests_header.dart';
import 'package:auth/presentation/interests/widgets/search_box.dart';
import 'package:auth/presentation/manager/profile_cubit/interests/select_interests_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavouritePlayersView extends StatefulWidget {
  final bool isEditPlayers;
  const FavouritePlayersView({super.key, this.isEditPlayers = false});

  @override
  State<FavouritePlayersView> createState() => _FavouritePlayersViewState();
}

class _FavouritePlayersViewState extends State<FavouritePlayersView> {
  @override
  void initState() {
    super.initState();
    print('--> View: initState started');
    context.read<SelectInterestsCubit>().loadPlayers(
      isEdit: widget.isEditPlayers,
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
            title: l10n.favPlayersTitle,
            subTitle: l10n.favPlayersDesc,
          ),
          const SearchBox(),
          InterestsGridView(isTeams: false, isEdit: widget.isEditPlayers),
          InterestsButtonActions(isTeams: false, isEdit: widget.isEditPlayers),
        ],
      ),
    );
  }
}
