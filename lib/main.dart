import 'package:cuetbus/data/models/booking_model.dart';
import 'package:flutter/material.dart';
import 'package:cuetbus/cuet_bus_app.dart';
import 'package:cuetbus/core/services/notification_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cuetbus/core/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(BookingAdapter());

  await Hive.openBox("notifications");
  await Hive.openBox<Booking>('bookings');
  await Hive.openBox('userBox');

  await NotificationService.initialize();
  await NotificationService.requestPermission(); // request permission for Android/iOS

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const CUETBusApp(),
    ),
  );
}
