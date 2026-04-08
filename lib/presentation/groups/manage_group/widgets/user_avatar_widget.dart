import 'package:auth/injection_container.dart' as di;
import 'package:auth/presentation/manager/profile_cubit/get_user_profile_by_id_cubit.dart';
import 'package:auth/presentation/manager/profile_cubit/get_user_profile_by_id_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserAvatarWidget extends StatelessWidget {
  final String userId;
  final double radius;

  const UserAvatarWidget({super.key, required this.userId, this.radius = 22});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          di.sl<GetUserProfileByIdCubit>()..loadUserProfileById(userId),
      child: BlocBuilder<GetUserProfileByIdCubit, GetUserProfileByIdState>(
        builder: (context, state) {
          if (state is GetUserProfileByIdLoading) {
            return CircleAvatar(
              radius: radius,
              backgroundColor: Colors.grey[200],
              child: Icon(Icons.person, color: Colors.grey[350]),
            );
          }

          if (state is GetUserProfileByIdLoaded) {
            final imageUrl = state.user.avatar;
            return CircleAvatar(
              radius: radius,
              backgroundColor: Colors.grey[100],
              backgroundImage: imageUrl.isNotEmpty
                  ? NetworkImage(imageUrl)
                  : null,
              child: imageUrl.isEmpty
                  ? const Icon(Icons.person, color: Colors.grey)
                  : null,
            );
          }

          return CircleAvatar(
            radius: radius,
            backgroundColor: Colors.grey[100],
            child: const Icon(Icons.person, color: Colors.grey),
          );
        },
      ),
    );
  }
}
