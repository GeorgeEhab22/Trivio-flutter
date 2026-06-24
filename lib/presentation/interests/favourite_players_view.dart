import 'package:auth/core/styels.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/interests/widgets/interests_button_actions.dart';
import 'package:auth/presentation/interests/widgets/interests_grid_view.dart';
import 'package:auth/presentation/interests/widgets/search_box.dart';
import 'package:auth/presentation/manager/profile_cubit/interests/select_interests_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        leading: widget.isEditPlayers
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () => context.pop(),
              )
            : null,
        title: Text(
          l10n.favPlayersTitle,
          style: Styles.textStyle20.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 10,
              top: 60,
            ),
            child: Text(
              l10n.favPlayersDesc,
              style: Styles.textStyle14.copyWith(color: Colors.grey),
            ),
          ),

          const SearchBox(isTeams: false),
          InterestsGridView(isTeams: false, isEdit: widget.isEditPlayers),
          InterestsButtonActions(isTeams: false, isEdit: widget.isEditPlayers),
        ],
      ),
    );
  }
}
