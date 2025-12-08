import 'package:auth/core/styels.dart';
import 'package:flutter/material.dart';


class ProfileInfoBox extends StatelessWidget {
  final String username;
  final String userAbout;
  final String? avatarUrl;

  const ProfileInfoBox({
    super.key,
    this.username = "Username",
    this.userAbout = "About",
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),

        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.height * 0.14,
                  height: MediaQuery.of(context).size.height * 0.14,
                  child: CircleAvatar(
                    backgroundColor: Colors.black,
                    backgroundImage: avatarUrl != null && avatarUrl!.isNotEmpty
                        ? NetworkImage(avatarUrl!)
                        : null,
                    child: (avatarUrl == null || avatarUrl!.isEmpty)
                        ? Center(
                          child: Text(
                              username[0].toUpperCase(),
                              style: Styles.textStyle25.copyWith(
                                color: Colors.white,
                              ),
                            ),
                        )
                        : null,
                  ),
                ),
                 Text(
                    username.length > 12 ? username.substring(0, 12): username, //preferably just make the username limited?
                    style: username.length <= 8
                      ? Styles.textStyle25
                      : Styles.textStyle20,
                  ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  userAbout, 
                  style: TextStyle(fontSize: 20),
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,),
              ),
            ),
          ],
        ),
    );
  }
}
