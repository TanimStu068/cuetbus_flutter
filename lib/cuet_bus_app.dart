import 'package:cuetbus/core/routing/app_routes.dart';
import 'package:cuetbus/core/theme/theme.dart';
import 'package:cuetbus/core/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CUETBusApp extends StatelessWidget {
  const CUETBusApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: "CUET Bus Seat Booking",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,

      initialRoute: AppRoutes.splash,
      onGenerateRoute: (settings) => AppRoutes.generateRoute(settings),
    );
  }
}
