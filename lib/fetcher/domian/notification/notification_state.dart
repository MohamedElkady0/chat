// part of 'notification_cubit.dart'; // سننشئ هذا الملف تاليًا

// abstract class NotificationState extends Equatable {
//   const NotificationState();

//   @override
//   List<Object> get props => [];
// }

// // الحالة الابتدائية
// class NotificationInitial extends NotificationState {}

// // حالة لإظهار أن عملية ما قيد التنفيذ (اختياري ولكن مفيد)
// class NotificationLoading extends NotificationState {}

// // حالة نجاح جدولة الإشعار
// class NotificationScheduledSuccess extends NotificationState {
//   final int notificationId;
//   const NotificationScheduledSuccess(this.notificationId);

//   @override
//   List<Object> get props => [notificationId];
// }

// // حالة نجاح إلغاء الإشعار
// class NotificationCancelledSuccess extends NotificationState {}

// // حالة خاصة بحالة الأذونات
// class NotificationPermissionState extends NotificationState {
//   final bool isGranted;
//   const NotificationPermissionState(this.isGranted);

//   @override
//   List<Object> get props => [isGranted];
// }

// // حالة حدوث خطأ
// class NotificationError extends NotificationState {
//   final String message;
//   const NotificationError(this.message);

//   @override
//   List<Object> get props => [message];
// }
