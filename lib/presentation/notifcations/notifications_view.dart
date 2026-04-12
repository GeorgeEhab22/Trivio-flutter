import 'package:auth/l10n/app_localizations.dart';
import 'package:auth/presentation/manager/notifications_cubit/notifications_cubit.dart';
import 'package:auth/presentation/manager/notifications_cubit/notifications_state.dart';
import 'package:auth/presentation/notifcations/widgets/notificatio_card_type.dart';
import 'package:auth/domain/entities/notification_type.dart';
import 'package:auth/presentation/notifcations/widgets/notifications_app_bar.dart';
import 'package:auth/presentation/notifcations/widgets/notifications_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  final Color _primaryGreen = const Color(0xFF1DB954);
  int _selectedTabIndex = 0;
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
     _fetchAndMark();
  }
  Future<void> _fetchAndMark() async {
    await context.read<NotificationCubit>().fetchInitialNotifications();
    if (mounted) {
      context.read<NotificationCubit>().markAllAsSeen();
    }
  }


  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<NotificationCubit>().loadMoreNotifications();
    }
  }

  List<NotificationListItem> _getFilteredItems(
    List<NotificationListItem> allItems,
  ) {
    if (_selectedTabIndex == 0) return allItems;

    final filteredList = <NotificationListItem>[];
    NotificationHeaderItem? pendingHeader;

    for (final item in allItems) {
      if (item is NotificationHeaderItem) {
        pendingHeader = item;
      } else if (item is NotificationDataItem) {
        bool matches = false;

        if (_selectedTabIndex == 1 &&
            item.notification.type == NotificationType.matchAlert) {
          matches = true;
        } else if (_selectedTabIndex == 2 &&
            item.notification.type != NotificationType.matchAlert) {
          matches = true;
        }

        if (matches) {
          if (pendingHeader != null) {
            filteredList.add(pendingHeader);
            pendingHeader = null;
          }
          filteredList.add(item);
        }
      }
    }
    return filteredList;
  }

  String _getLocalizedHeader(String key, AppLocalizations l10n) {
    switch (key) {
      case 'today':
        return l10n.today;
      case 'yesterday':
        return l10n.yesterday;
      case 'earlier':
        return l10n.earlier;
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;
    final List<String> tabs = [l10n.all, l10n.matches, l10n.social];
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: const NotificationsAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NotificationsTabBar(
            tabs: tabs,
            selectedIndex: _selectedTabIndex,
            onTabChanged: (index) {
              setState(() => _selectedTabIndex = index);
            },
          ),

          // notifications list
          Expanded(
            child: BlocBuilder<NotificationCubit, NotificationState>(
              builder: (context, state) {
                if (state is NotificationLoading) {
                  return Center(
                    child: CircularProgressIndicator(color: _primaryGreen),
                  );
                } else if (state is NotificationError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: TextStyle(color: textColor),
                    ),
                  );
                } else if (state is NotificationLoaded) {
                  final filteredItems = _getFilteredItems(state.items);

                  if (filteredItems.isEmpty) {
                    return Center(
                      child: Text(
                        l10n.noNotificationsYet,
                        style: TextStyle(color: textColor),
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    physics: const BouncingScrollPhysics(),

                    itemCount: state.hasReachedMax
                        ? filteredItems.length
                        : filteredItems.length + 1,
                    itemBuilder: (context, index) {
                      if (index >= filteredItems.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: _primaryGreen,
                            ),
                          ),
                        );
                      }

                      final item = filteredItems[index];

                      if (item is NotificationHeaderItem) {
                        return Padding(
                          padding: EdgeInsets.only(
                            top: index > 0 ? 16.0 : 0,
                            bottom: 12.0,
                          ),
                          child: Text(
                            _getLocalizedHeader(item.title, l10n),
                            style: TextStyle(
                              color: textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      } else if (item is NotificationDataItem) {
                        return NotificationCardType(
                          notification: item.notification,
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
