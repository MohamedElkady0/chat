// // (في ملف صفحة الواجهة)

// class NotificationDemoPage extends StatefulWidget {
//   const NotificationDemoPage({super.key});
//   // ... ( باقي الكود كما هو )
// }

// class _NotificationDemoPageState extends State<NotificationDemoPage> {
//    // ... ( المتغيرات ودوال اختيار الوقت كما هي ) ...

//    @override
//    Widget build(BuildContext context) {
//      return Scaffold(
//        appBar: AppBar(
//          title: const Text('جدولة إشعار (مع Cubit)'),
//        ),
//        // استخدم BlocListener للاستماع للتغيرات التي لا تتطلب إعادة بناء الواجهة
//        body: BlocListener<NotificationCubit, NotificationState>(
//          listener: (context, state) {
//            if (state is NotificationScheduledSuccess) {
//              ScaffoldMessenger.of(context).showSnackBar(
//                SnackBar(content: Text('تم جدولة الإشعار بنجاح! ID: ${state.notificationId}')),
//              );
//            } else if (state is NotificationCancelledSuccess) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                const SnackBar(content: Text('تم إلغاء جميع الإشعارات')),
//              );
//            } else if (state is NotificationError) {
//              ScaffoldMessenger.of(context).showSnackBar(
//                SnackBar(content: Text('خطأ: ${state.message}'), backgroundColor: Colors.red),
//              );
//            }
//          },
//          child: Padding(
//            padding: const EdgeInsets.all(16.0),
//            child: Column(
//              // ... ( جميع الحقول والأزرار كما هي )
//              // ولكن قم بتعديل onPressed للأزرار:
//              // ...
//              ElevatedButton(
//                onPressed: () {
//                  // ... (نفس التحقق من البيانات) ...
//                   if (_selectedDateTime == null || _titleController.text.isEmpty) {
//                     // ...
//                     return;
//                   }

//                  // استدعاء دالة الـ Cubit بدلاً من الخدمة مباشرة
//                  context.read<NotificationCubit>().scheduleNotification(
//                        title: _titleController.text,
//                        body: _bodyController.text,
//                        scheduledDateTime: _selectedDateTime!,
//                      );
//                },
//                child: const Text('جدولة الإشعار'),
//              ),
//              // ...
//              ElevatedButton(
//                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                onPressed: () {
//                  // استدعاء دالة الـ Cubit
//                  context.read<NotificationCubit>().cancelAllNotifications();
//                },
//                child: const Text('إلغاء جميع الإشعارات'),
//              ),
//            ),
//          ),
//        ),
//      );
//    }
// }
