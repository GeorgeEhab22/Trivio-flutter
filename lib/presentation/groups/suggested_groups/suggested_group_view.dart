import 'package:auth/presentation/groups/suggested_groups/widgets/suggested_group_app_bar.dart';
import 'package:flutter/material.dart';

class SuggestedGroupView extends StatelessWidget {
  const SuggestedGroupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SuggestedGroupAppBar(),
      body: const Center(child: Text('Suggested Groups Content Here')),
    );
  }
}
