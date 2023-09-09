import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationController {
  static NotificationChannel walkPrimaryNotificationChannel =
      NotificationChannel(
          channelKey: "PrimaryChannel",
          channelName: "WALK Notification Channel",
          channelDescription:
              "This is the primary notification channel of WALK application");
  static NotificationChannel walkServiceNotificationChannel = NotificationChannel(
      channelKey: "PrimaryServiceChannel",
      channelName: "WALK Service Notification Channel",
      channelDescription:
          "This is the primary service notification channel of WALK application ");

  static initNotificationController() {
    AwesomeNotifications().initialize(
      "",
      [
        walkPrimaryNotificationChannel,
        walkServiceNotificationChannel,
      ],
      debug: true,
    );
  }

  static sendNotification(
      {String? channelkey,
      int? id,
      String? title,
      String? body,
      List<NotificationActionButton>? actionButtons}) {
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        channelKey: channelkey!,
        id: id!,
        title: title,
        body: body,
      ),
      actionButtons: actionButtons,
    );
  }

  static startListeningToNotifications() {}
}
