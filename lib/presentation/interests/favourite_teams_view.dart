import 'package:auth/core/styels.dart';
import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/interests/widgets/interests_button_actions.dart';
import 'package:auth/presentation/interests/widgets/interests_grid_view.dart';
import 'package:auth/presentation/interests/widgets/search_box.dart';
import 'package:auth/presentation/manager/profile_cubit/interests/select_interests_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
    context.read<SelectInterestsCubit>().loadTeams(isEdit: widget.isEditTeams);
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
        leading: 
          widget.isEditTeams ?
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => context.pop(),
          ):null
        ,
        title: Text(l10n.favTeamsTitle, style: Styles.textStyle20.copyWith(fontWeight: FontWeight.bold, )),
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
              l10n.favTeamsDesc,
              style: Styles.textStyle14.copyWith(color: Colors.grey),
            ),
          ),

          const SearchBox(isTeams: true),
          InterestsGridView(isTeams: true, isEdit: widget.isEditTeams),
          InterestsButtonActions(isTeams: true, isEdit: widget.isEditTeams),
        ],
      ),
    );
  }
}
