import 'package:afn_test/app/app_widgets/theme/app_themes.dart';
import 'package:afn_test/app/routes/app_pages.dart';
import 'package:afn_test/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

  
void main() async{
    WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(

    );
    print('Firebase initialized successfully');
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // Design size (width, height)
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'AFN Test App',
          theme: AppTheme.lightTheme,
          initialRoute: AppRoutes.onboard,
          getPages: AppPages.routes,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
