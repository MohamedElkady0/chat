// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import '../notification_service.dart'; // استورد الخدمة

// part 'notification_state.dart';

// class NotificationCubit extends Cubit<NotificationState> {
//   // اجعل الـ Cubit يعتمد على الخدمة، ولا ينشئها بنفسه (Dependency Injection)
//   final NotificationService _notificationService;

//   NotificationCubit(this._notificationService) : super(NotificationInitial());

//   // دالة لجدولة إشعار
//   Future<void> scheduleNotification({
//     required String title,
//     required String body,
//     required DateTime scheduledDateTime,
//     String? payload,
//   }) async {
//     try {
//       emit(NotificationLoading()); // اختياري: إظهار مؤشر تحميل

//       // استخدم ID فريد
//       final int id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//       final String finalPayload = payload ?? 'task_id_$id';

//       await _notificationService.scheduleNotification(
//         id: id,
//         title: title,
//         body: body,
//         scheduledDateTime: scheduledDateTime,
//         payload: finalPayload,
//       );
      
//       emit(NotificationScheduledSuccess(id)); // أرسل حالة النجاح مع الـ ID
//     } catch (e) {
//       emit(NotificationError("فشل في جدولة الإشعار: ${e.toString()}"));
//     }
//   }

//   // دالة لإلغاء جميع الإشعارات كمثال
//   Future<void> cancelAllNotifications() async {
//     try {
//       emit(NotificationLoading());
//       await _notificationService.cancelAllNotifications();
//       emit(NotificationCancelledSuccess());
//     } catch (e) {
//       emit(NotificationError("فشل في إلغاء الإشعارات: ${e.toString()}"));
//     }
//   }

//   // دالة لطلب الأذونات وتحديث الحالة
//   // يمكنك استدعاؤها في بداية التطبيق
//   Future<void> requestPermissions() async {
//     try {
//       // الـ plugin نفسه يطلب الأذونات، لكننا يمكن أن نتحقق من حالتها
//       // في التطبيقات الحقيقية، قد تحتاج لمكتبة مثل `permission_handler` للحصول على حالة الإذن بدقة
//       // ولكن هنا سنكتفي باستدعاء الدالة فقط
//       await _notificationService.requestPermissions();
//       // للأسف، المكتبة لا تعيد حالة الإذن مباشرة، لذا هذا مثال توضيحي
//       // في تطبيقจริงي، ستستخدم `permission_handler` للتحقق من الحالة
//       emit(const NotificationPermissionState(true)); // نفترض النجاح للتوضيح
//     } catch (e) {
//        emit(const NotificationPermissionState(false));
//        emit(NotificationError("حدث خطأ أثناء طلب الأذونات: ${e.toString()}"));
//     }
//   }
// }