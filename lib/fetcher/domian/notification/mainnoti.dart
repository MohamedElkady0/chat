// // main.dart
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // نهيئ الخدمة مرة واحدة هنا
//   final notificationService = NotificationService();
//   await notificationService.init();

//   runApp(MyApp(notificationService: notificationService));
// }

// class MyApp extends StatelessWidget {
//   final NotificationService notificationService;
//   const MyApp({super.key, required this.notificationService});

//   @override
//   Widget build(BuildContext context) {
//     // نوفر Cubit للتطبيق بأكمله ونمرر له الخدمة التي أنشأناها
//     return BlocProvider(
//       create: (context) => NotificationCubit(notificationService)..requestPermissions(), // طلب الأذونات عند بدء التشغيل
//       child: MaterialApp(
//         title: 'Flutter Notifications Demo',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//           useMaterial3: true,
//         ),
//         home: const NotificationDemoPage(),
//       ),
//     );
//   }
// }
