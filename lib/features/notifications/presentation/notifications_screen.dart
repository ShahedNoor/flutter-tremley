import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../common_widgets/custom_back_app_bar.dart';
import '../../../../common_widgets/not_found_widget.dart';
import '../../../../networks/api_acess.dart';
import '../../../../gen/colors.gen.dart';
import '../../../../helpers/ui_helpers.dart';
import '../../../../helpers/time_converter.dart';
import '../../../../helpers/loading_helper.dart';
import 'widgets/notification_item_card.dart';
import 'widgets/notifications_shimmer.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    getPushNotificationRxObj.fetchPushNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cFFFFFF,
      appBar: const CustomBackAppBar(title: "Notifications"),
      body: SafeArea(
        child: StreamBuilder(
          stream: getPushNotificationRxObj.fileData,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              final model = snapshot.data!;
              final items = model.data ?? [];

              if (items.isEmpty) {
                return Center(
                  child: Text("No Notifications",
                      style: TextStyle(fontSize: 16.sp)),
                );
              }

              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                itemCount: items.length,
                separatorBuilder: (context, index) =>
                    UIHelper.verticalSpace(12.h),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return InkWell(
                    onTap: () async {
                      if (item.readAt == null && item.id != null) {
                        bool success = await getReadNotificationRxObj
                            .readNotification(item.id!)
                            .waitingForFutureWithoutBg();
                        if (success) {
                          getPushNotificationRxObj.fetchPushNotification();
                        }
                      }
                    },
                    borderRadius: BorderRadius.circular(12.r),
                    child: NotificationItemCard(
                      title: item.data?.title ?? "Notification",
                      subtitle: item.data?.body ?? "",
                      time: TimeConverter.timeAgoFR(item.createdAt),
                      icon: Icons.notifications_outlined,
                      isUnread: item.readAt == null,
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return const NotFoundWidget();
            }
            return const NotificationsShimmer();
          },
        ),
      ),
    );
  }
}
