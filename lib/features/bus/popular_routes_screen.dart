// import 'package:flutter/material.dart';
// import 'package:cuetbus/core/constants/colors.dart';
// import 'package:cuetbus/core/theme/app_text_styles.dart';

// class PopularRoutesScreen extends StatefulWidget {
//   const PopularRoutesScreen({super.key});

//   @override
//   State<PopularRoutesScreen> createState() => _PopularRoutesScreenState();
// }

// class _PopularRoutesScreenState extends State<PopularRoutesScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;

//   // Dummy popular routes data
//   final List<Map<String, dynamic>> popularRoutes = [
//     {"route": "Campus → Main Gate", "duration": "15 min"},
//     {"route": "SMT → CUET", "duration": "25 min"},
//     {"route": "Dorm → Library", "duration": "10 min"},
//     {"route": "Gate → Canteen", "duration": "8 min"},
//     {"route": "Admin → Lab", "duration": "12 min"},
//   ];

//   String searchQuery = "";

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 800),
//     );

//     _fadeAnimation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeOut,
//     );

//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final filteredRoutes = popularRoutes
//         .where(
//           (route) =>
//               route['route'].toLowerCase().contains(searchQuery.toLowerCase()),
//         )
//         .toList();

//     return Scaffold(
//       backgroundColor: AppColors.bgColor,
//       appBar: AppBar(
//         backgroundColor: AppColors.primary,
//         title: const Text("Popular Routes", style: AppTextStyles.whiteTitle),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         centerTitle: true,
//       ),
//       body: FadeTransition(
//         opacity: _fadeAnimation,
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             children: [
//               // Search Bar
//               TextField(
//                 onChanged: (value) => setState(() {
//                   searchQuery = value;
//                 }),
//                 decoration: InputDecoration(
//                   hintText: "Search routes...",
//                   prefixIcon: Icon(Icons.search, color: AppColors.primary),
//                   filled: true,
//                   fillColor: Colors.white,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(14),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // Popular Routes List
//               Expanded(
//                 child: filteredRoutes.isEmpty
//                     ? Center(
//                         child: Text(
//                           "No routes found",
//                           style: AppTextStyles.bodyMedium,
//                         ),
//                       )
//                     : ListView.separated(
//                         itemCount: filteredRoutes.length,
//                         separatorBuilder: (_, __) => const SizedBox(height: 16),
//                         itemBuilder: (context, index) {
//                           final route = filteredRoutes[index];
//                           return GestureDetector(
//                             onTap: () {
//                               // You can navigate to route details if needed
//                             },
//                             child: Container(
//                               padding: const EdgeInsets.all(18),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(22),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.06),
//                                     blurRadius: 12,
//                                     offset: const Offset(0, 6),
//                                   ),
//                                 ],
//                               ),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         route['route'],
//                                         style: AppTextStyles.titleMedium,
//                                       ),
//                                       const SizedBox(height: 6),
//                                       Row(
//                                         children: [
//                                           const Icon(
//                                             Icons.access_time,
//                                             size: 18,
//                                             color: Colors.grey,
//                                           ),
//                                           const SizedBox(width: 6),
//                                           Text(
//                                             route['duration'],
//                                             style: AppTextStyles.bodySmall
//                                                 .copyWith(
//                                                   color: Colors.grey[700],
//                                                 ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                   const Icon(
//                                     Icons.arrow_forward_ios_rounded,
//                                     size: 20,
//                                     color: Colors.grey,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
