import 'package:growify/controller/home/homepage_controller.dart';
import 'package:growify/controller/home/homescreen_controller.dart';
import 'package:growify/main.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:growify/view/screen/homescreen/chat/chatpagemessages.dart';
import 'package:growify/view/screen/homescreen/notificationspages/notificationmainpage.dart';
import 'package:get/get.dart';

class NotificationService {
  
  static Future<void> initializeNotification(bool playSound) async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'high_importance_channel',
          channelKey: 'high_importance_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          onlyAlertOnce: true,
          playSound: playSound,
          criticalAlerts: true,
        )
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'high_importance_channel_group',
          channelGroupName: 'Group 1',
        )
      ],
      debug: true,
    );

    await AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) async {
        if (!isAllowed) {
          await AwesomeNotifications().requestPermissionToSendNotifications();
        }
      },
    );

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  /// Use this method to detect when a new notification or a schedule is created
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationCreatedMethod');
  }

  /// Use this method to detect every time that a new notification is displayed
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationDisplayedMethod');
  }

  /// Use this method to detect if the user dismissed a notification
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('onDismissActionReceivedMethod');
  }

  /// Use this method to detect when the user taps on a notification or action button
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('onActionReceivedMethod');
    final payload = receivedAction.payload ?? {};

    if (payload["navigate"] == "true") {
      if (payload["call"] == "true") {
        HomePageControllerImp controller =Get.put(HomePageControllerImp());
        HomeScreenControllerImp controller2 =Get.put(HomeScreenControllerImp());
        controller2.stopCallingSound();
        await controller.goToChat();

        Map<String, dynamic>? foundUser;
        for (Map<String, dynamic> user
            in controller.colleaguesPreviousmessages) {
          if (user['username'] == receivedAction.body!.split(' ')[0]) {
            foundUser = user;
            break; 
          }
        }

        if (foundUser != null) {
          MyApp.navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => ChatPageMessages(data: foundUser),
          ),
        );
        }
      } else {
        MyApp.navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => const NotificationsPage(),
          ),
        );
      }
    }
  }

  static Future<void> showNotification({
    required final String title,
    required final String body,
    final String? summary,
    final Map<String, String>? payload,
    final ActionType actionType = ActionType.Default,
    final NotificationLayout notificationLayout = NotificationLayout.Default,
    final NotificationCategory? category,
    final String? bigPicture,
    final List<NotificationActionButton>? actionButtons,
    final bool scheduled = false,
    final int? interval,
    final Duration? chronometer,
    final Duration? timeoutAfter,
  }) async {
    assert(!scheduled || (scheduled && interval != null));

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: -1,
        channelKey: 'high_importance_channel',
        title: title,
        body: body,
        actionType: actionType,
        notificationLayout: notificationLayout,
        summary: summary,
        category: category,
        payload: payload,
        bigPicture: bigPicture,
        chronometer:chronometer,
        timeoutAfter:timeoutAfter,
      ),
      actionButtons: actionButtons,
      schedule: scheduled
          ? NotificationInterval(
              interval: interval,
              timeZone:
                  await AwesomeNotifications().getLocalTimeZoneIdentifier(),
              preciseAlarm: true,
            )
          : null,
    );
  }
}
