// import 'package:flutter/material.dart';
// import 'package:cuetbus/core/constants/colors.dart';
// import 'package:cuetbus/core/theme/app_text_styles.dart';

// class LiveBusTrackerScreen extends StatefulWidget {
//   const LiveBusTrackerScreen({super.key});

//   @override
//   State<LiveBusTrackerScreen> createState() => _LiveBusTrackerScreenState();
// }

// class _LiveBusTrackerScreenState extends State<LiveBusTrackerScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _fadeAnimation;

//   final List<Map<String, dynamic>> buses = [
//     {
//       "busNo": "Bus 1",
//       "route": "Campus → Gate",
//       "arrival": "5 min",
//       "seatsAvailable": 12,
//     },
//     {
//       "busNo": "Bus 2",
//       "route": "Gate → Hostel",
//       "arrival": "12 min",
//       "seatsAvailable": 7,
//     },
//     {
//       "busNo": "Bus 3",
//       "route": "Library → Hostel",
//       "arrival": "20 min",
//       "seatsAvailable": 18,
//     },
//   ];

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
//     return Scaffold(
//       backgroundColor: AppColors.bgColor,
//       appBar: AppBar(
//         backgroundColor: AppColors.primary,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         centerTitle: true,
//         title: Text(
//           'Live Bus Tracker',
//           style: TextStyle(color: Colors.white, fontSize: 22),
//         ),
//       ),
//       body: SafeArea(
//         child: FadeTransition(
//           opacity: _fadeAnimation,
//           child: Column(
//             children: [
//               // -------------------- APP BAR -------------------- //
//               // Padding(
//               //   padding: const EdgeInsets.symmetric(
//               //     horizontal: 20,
//               //     vertical: 12,
//               //   ),
//               //   child: Row(
//               //     children: [
//               //       InkWell(
//               //         onTap: () => Navigator.pop(context),
//               //         borderRadius: BorderRadius.circular(12),
//               //         child: Container(
//               //           padding: const EdgeInsets.all(8),
//               //           decoration: BoxDecoration(
//               //             color: Colors.white,
//               //             borderRadius: BorderRadius.circular(12),
//               //             boxShadow: [
//               //               BoxShadow(
//               //                 color: Colors.black.withOpacity(0.06),
//               //                 blurRadius: 6,
//               //                 offset: const Offset(0, 3),
//               //               ),
//               //             ],
//               //           ),
//               //           child: const Icon(
//               //             Icons.arrow_back_rounded,
//               //             color: AppColors.primary,
//               //           ),
//               //         ),
//               //       ),
//               //       const SizedBox(width: 16),
//               //       Text(
//               //         "Live Bus Tracker",
//               //         style: AppTextStyles.titleLarge.copyWith(
//               //           fontWeight: FontWeight.w700,
//               //         ),
//               //       ),
//               //     ],
//               //   ),
//               // ),
//               const SizedBox(height: 16),

//               // -------------------- SEARCH BAR -------------------- //
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: TextField(
//                   decoration: InputDecoration(
//                     hintText: "Search buses or routes",
//                     prefixIcon: Icon(Icons.search, color: AppColors.primary),
//                     filled: true,
//                     fillColor: Colors.white,
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(16),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 16),

//               // -------------------- MAP PLACEHOLDER -------------------- //
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(22),
//                     child: Image.asset(
//                       "assets/images/map_image.png", // <-- your image path
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               ),

//               // Expanded(
//               //   child: Padding(
//               //     padding: const EdgeInsets.symmetric(horizontal: 20),
//               //     child: ClipRRect(
//               //       borderRadius: BorderRadius.circular(22),
//               //       child: Container(
//               //         color: Colors.grey.shade200,
//               //         child: Center(
//               //           child: Column(
//               //             mainAxisAlignment: MainAxisAlignment.center,
//               //             children: const [
//               //               Icon(
//               //                 Icons.map_rounded,
//               //                 size: 80,
//               //                 color: Colors.grey,
//               //               ),
//               //               SizedBox(height: 12),
//               //               Text(
//               //                 "Map will appear here",
//               //                 style: TextStyle(color: Colors.grey),
//               //               ),
//               //             ],
//               //           ),
//               //         ),
//               //       ),
//               //     ),
//               //   ),
//               // ),
//               const SizedBox(height: 23),

//               // -------------------- LIVE BUSES LIST -------------------- //
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Buses on Route",
//                         style: AppTextStyles.titleMedium.copyWith(
//                           fontWeight: FontWeight.w700,
//                           color: Colors.grey[900],
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       SizedBox(
//                         height: 180,
//                         child: ListView.separated(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: buses.length,
//                           separatorBuilder: (_, __) =>
//                               const SizedBox(width: 16),
//                           itemBuilder: (context, index) {
//                             final bus = buses[index];
//                             return GestureDetector(
//                               onTap: () {
//                                 // Navigate to seat selection or bus detail
//                               },
//                               child: Container(
//                                 width: 200,
//                                 height: 300,
//                                 padding: const EdgeInsets.all(18),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(22),
//                                   boxShadow: [
//                                     BoxShadow(
//                                       color: Colors.black.withOpacity(0.08),
//                                       blurRadius: 12,
//                                       offset: const Offset(0, 6),
//                                     ),
//                                   ],
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       bus["busNo"],
//                                       style: AppTextStyles.titleMedium.copyWith(
//                                         fontWeight: FontWeight.w700,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 6),
//                                     Text(
//                                       bus["route"],
//                                       style: AppTextStyles.bodySmall,
//                                     ),
//                                     const SizedBox(height: 12),

//                                     Row(
//                                       children: [
//                                         const Icon(
//                                           Icons.access_time,
//                                           size: 16,
//                                           color: Colors.grey,
//                                         ),
//                                         const SizedBox(width: 6),
//                                         Text(
//                                           "Arrives in ${bus["arrival"]}",
//                                           style: AppTextStyles.bodySmall,
//                                         ),
//                                       ],
//                                     ),
//                                     const SizedBox(height: 6),
//                                     LinearProgressIndicator(
//                                       value: bus["seatsAvailable"] / 40,
//                                       color: Colors.greenAccent,
//                                       backgroundColor: Colors.grey.shade200,
//                                       minHeight: 8,
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Text(
//                                       "${bus["seatsAvailable"]}/40 seats available",
//                                       style: AppTextStyles.bodySmall,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 24),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
