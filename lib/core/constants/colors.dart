// import 'package:flutter/material.dart';

// class AppColors {
//   AppColors._();

//   // Primary color stays the same for both modes
//   static const Color primary = Color(0xFF1B7743);

//   // Light mode text colors
//   static const Color darkText = Color(0xFF1A1A1A);
//   static const Color lightText = Color(0xFF7A7A7A);

//   // Backgrounds
//   static const Color bgColor = Color.fromARGB(255, 226, 250, 227);

//   // Dark mode background
//   static const Color scaffoldDark = Color(0xFF0D0D0D);

//   // Status Colors (can be used same for both)
//   static const Color success = Color(0xFF4CAF50);
//   static const Color warning = Color(0xFFFFC107);
//   static const Color danger = Color(0xFFFF5252);

//   // Overlay
//   static Color overlay = Colors.black.withOpacity(0.04);

//   // Glass effect gradient (you can make theme-aware too if needed)
//   static Gradient glassGradient = LinearGradient(
//     colors: [Colors.white.withOpacity(0.20), Colors.white.withOpacity(0.05)],
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//   );

//   // ------------------------------
//   // Theme-aware helpers
//   static Color primaryColor(BuildContext context) =>
//       Theme.of(context).brightness == Brightness.dark ? primary : primary;

//   static Color background(BuildContext context) =>
//       Theme.of(context).brightness == Brightness.dark ? scaffoldDark : bgColor;

//   static Color text(BuildContext context) =>
//       Theme.of(context).brightness == Brightness.dark ? Colors.white : darkText;

//   static Color subText(BuildContext context) =>
//       Theme.of(context).brightness == Brightness.dark
//       ? Colors.white70
//       : lightText;
// }

// import 'package:flutter/material.dart';

// class AppColors {
//   AppColors._();

//   // Brand color (same in light/dark)
//   static const Color primary = Color(0xFF1B7743);

//   // Light mode background
//   static const Color bgLight = Color.fromARGB(255, 226, 250, 227);

//   // Dark mode background
//   static const Color bgDark = Color(0xFF0D0D0D);

//   // Theme-aware helpers
//   static Color background(BuildContext context) =>
//       Theme.of(context).brightness == Brightness.dark ? bgDark : bgLight;

//   static Color text(BuildContext context) =>
//       Theme.of(context).brightness == Brightness.dark
//       ? Colors.white
//       : Colors.black87;

//   static Color subText(BuildContext context) =>
//       Theme.of(context).brightness == Brightness.dark
//       ? Colors.white70
//       : Colors.black54;
// }
