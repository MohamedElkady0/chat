// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// // أزل: import 'package:flutter_native_timezone/flutter_native_timezone.dart';

// class NotificationService {
//   static final NotificationService _notificationService = NotificationService._internal();

//   factory NotificationService() {
//     return _notificationService;
//   }

//   NotificationService._internal();

//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   bool _android13PermissionRequested = false;

//   Future<void> init() async {
//     await _configureLocalTimeZone();

//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     final DarwinInitializationSettings initializationSettingsDarwin =
//         DarwinInitializationSettings(
//       requestAlertPermission: false,
//       requestBadgePermission: false,
//       requestSoundPermission: false,
//       onDidReceiveLocalNotification: onDidReceiveLocalNotification,
//     );

//     final InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsDarwin,
//       macOS: initializationSettingsDarwin,
//     );

//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
//       onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse,
//     );
//   }

//   void onDidReceiveLocalNotification(
//       int id, String? title, String? body, String? payload) async {
//     print('onDidReceiveLocalNotification: id $id, title $title, body $body, payload $payload');
//   }

//   void onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
//     final String? payload = notificationResponse.payload;
//     if (notificationResponse.payload != null) {
//       debugPrint('Notification payload: $payload');
//     }
//   }

//   @pragma('vm:entry-point')
//   static void onDidReceiveBackgroundNotificationResponse(NotificationResponse notificationResponse) {
//      debugPrint('(Background) Notification payload: ${notificationResponse.payload}');
//   }

//   Future<void> _configureLocalTimeZone() async {
//     tz.initializeTimeZones(); // تهيئة قاعدة بيانات المناطق الزمنية أولاً
//     try {
//       // 'LOCAL' هو اسم خاص تستخدمه مكتبة timezone لمحاولة اكتشاف المنطقة المحلية
//       // يتم تعيين tz.local أثناء initializeTimeZones() إذا أمكن
//       final String detectedLocalTimeZoneName = tz.local.name;
//       print("Timezone package detected local timezone as: $detectedLocalTimeZoneName");

//       // لا حاجة لـ setLocalLocation إذا كان tz.local قد تم تعيينه بشكل صحيح بالفعل
//       // ولكن للتأكيد، أو إذا أردنا استخدام اسم محدد تم اكتشافه بطريقة أخرى:
//       // tz.setLocalLocation(tz.getLocation(detectedLocalTimeZoneName));
//       // في معظم الحالات، مجرد الاعتماد على tz.local بعد initializeTimeZones() كافٍ.

//     } catch (e) {
//       print("Error during timezone configuration (e.g., getting tz.local.name): $e.");
//       print("Will rely on the default tz.local or fallback to UTC if scheduling fails.");
//       // إذا أردت فرض UTC في حالة أي خطأ هنا:
//       // tz.setLocalLocation(tz.getLocation('Etc/UTC'));
//       // print("Defaulted to UTC due to error.");
//     }
//     // للتحقق من المنطقة الزمنية المستخدمة فعليًا:
//     print("Using timezone: ${tz.local.name} for scheduling notifications.");
//     print("Current DateTime.now().timeZoneName: ${DateTime.now().timeZoneName}");
//     print("Current DateTime.now().timeZoneOffset: ${DateTime.now().timeZoneOffset}");
//   }


//   Future<void> requestPermissions() async {
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             IOSFlutterLocalNotificationsPlugin>()
//         ?.requestPermissions(
//           alert: true,
//           badge: true,
//           sound: true,
//         );

//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             MacOSFlutterLocalNotificationsPlugin>()
//         ?.requestPermissions(
//           alert: true,
//           badge: true,
//           sound: true,
//         );

//     if (!_android13PermissionRequested) {
//       final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
//           flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
//               AndroidFlutterLocalNotificationsPlugin>();
//       if (androidImplementation != null) {
//         final bool? granted = await androidImplementation.requestNotificationsPermission();
//         _android13PermissionRequested = true;
//         print("Android 13+ Notification Permission Granted: $granted");
//       }
//     }
//   }

//   Future<void> scheduleNotification({
//     required int id,
//     required String title,
//     required String body,
//     required DateTime scheduledDateTime,
//     String? payload,
//   }) async {
//     await requestPermissions();

//     // التأكد من أن tz.local تم تهيئته بشكل ما
//     if (tz.local.name.isEmpty || tz.local.name == 'GMT' && scheduledDateTime.timeZoneOffset.inSeconds == 0) {
//         // هذا يعني أن تهيئة المنطقة الزمنية قد تكون غير موثوقة أو عادت إلى GMT/UTC
//         // قد ترغب في إعادة محاولة التهيئة أو إظهار تحذير
//         print("Warning: tz.local might not be accurately set. Current tz.local.name: ${tz.local.name}");
//         // يمكنك محاولة إعادة التهيئة هنا كإجراء احترازي، أو الاعتماد على ما هو موجود
//         // await _configureLocalTimeZone(); // كن حذرًا من الاستدعاءات المتكررة غير الضرورية
//     }


//     final tz.TZDateTime tzScheduledDate = tz.TZDateTime.from(scheduledDateTime, tz.local);

//     if (tzScheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
//       print("Scheduled date $tzScheduledDate is in the past. Notification not scheduled.");
//       return;
//     }

//     const AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//       'your_channel_id',
//       'Your Channel Name',
//       channelDescription: 'Your channel description',
//       importance: Importance.max,
//       priority: Priority.high,
//       ticker: 'ticker',
//       playSound: true,
//     );

//     const DarwinNotificationDetails darwinNotificationDetails =
//         DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );

//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidNotificationDetails,
//       iOS: darwinNotificationDetails,
//       macOS: darwinNotificationDetails,
//     );

//     try {
//       await flutterLocalNotificationsPlugin.zonedSchedule(
//         id,
//         title,
//         body,
//         tzScheduledDate,
//         notificationDetails,
//         androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime,
//         payload: payload ?? 'Default payload (ID: $id)',
//         // matchDateTimeComponents: DateTimeComponents.time, // أزل أو علّق هذا للجدولة لمرة واحدة
//       );
//       print("Notification (ID: $id) scheduled for $tzScheduledDate (in ${tz.local.name} timezone)");
//     } catch (e) {
//       print("Error scheduling notification (ID: $id): $e");
//       print("ScheduledDateTime: $scheduledDateTime, TZScheduledDate: $tzScheduledDate, tz.local: ${tz.local.name}");
//       // إذا حدث خطأ هنا، قد يكون بسبب مشكلة في تحويل الوقت أو عدم قدرة النظام على جدولة الإشعار
//     }
//   }

//   Future<void> showSimpleNotification({
//     required int id,
//     required String title,
//     required String body,
//     String? payload,
//   }) async {
//      await requestPermissions();
//     const AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//       'simple_channel_id',
//       'Simple Notifications',
//       channelDescription: 'Channel for simple instant notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//       ticker: 'ticker');
//     const DarwinNotificationDetails darwinNotificationDetails =
//         DarwinNotificationDetails(
//       presentAlert: true,
//       presentBadge: true,
//       presentSound: true,
//     );
//     const NotificationDetails notificationDetails = NotificationDetails(
//         android: androidNotificationDetails, iOS: darwinNotificationDetails, macOS: darwinNotificationDetails);
//     await flutterLocalNotificationsPlugin.show(id, title, body, notificationDetails,
//         payload: payload ?? 'Simple Payload (ID: $id)');
//      print("Simple Notification (ID: $id) shown.");
//   }

//   Future<void> cancelNotification(int id) async {
//     await flutterLocalNotificationsPlugin.cancel(id);
//     print("Notification (ID: $id) cancelled.");
//   }

//   Future<void> cancelAllNotifications() async {
//     await flutterLocalNotificationsPlugin.cancelAll();
//     print("All notifications cancelled.");
//   }
// }