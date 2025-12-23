// import 'package:cuetbus/core/constants/colors.dart';
// import 'package:cuetbus/core/theme/app_text_styles.dart';
// import 'package:flutter/material.dart';

// class EditProfileScreen extends StatefulWidget {
//   final String studentName;
//   final String department;
//   final String email;

//   const EditProfileScreen({
//     super.key,
//     this.studentName = "Md. Fahim",
//     this.department = "Computer Science & Engineering",
//     this.email = "fahim@cuet.ac.bd",
//   });

//   @override
//   State<EditProfileScreen> createState() => _EditProfileScreenState();
// }

// class _EditProfileScreenState extends State<EditProfileScreen>
//     with TickerProviderStateMixin {
//   late TextEditingController nameController;
//   late TextEditingController deptController;
//   late TextEditingController emailController;

//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _slideAnimation;

//   @override
//   void initState() {
//     super.initState();

//     nameController = TextEditingController(text: widget.studentName);
//     deptController = TextEditingController(text: widget.department);
//     emailController = TextEditingController(text: widget.email);

//     // Animation
//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 700),
//     );

//     _fadeAnimation = CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeOut,
//     );

//     _slideAnimation =
//         Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(
//           CurvedAnimation(
//             parent: _animationController,
//             curve: Curves.easeOutBack,
//           ),
//         );

//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     nameController.dispose();
//     deptController.dispose();
//     emailController.dispose();
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.bgColor,
//       body: Column(
//         children: [
//           // Header
//           Container(
//             height: 170,
//             width: double.infinity,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   AppColors.primary,
//                   AppColors.primary.withOpacity(0.85),
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: const BorderRadius.vertical(
//                 bottom: Radius.circular(28),
//               ),
//             ),
//             padding: const EdgeInsets.only(top: 65, left: 20),
//             child: Row(
//               children: [
//                 GestureDetector(
//                   onTap: () => Navigator.pop(context),
//                   child: const CircleAvatar(
//                     radius: 20,
//                     backgroundColor: Colors.white24,
//                     child: Icon(
//                       Icons.arrow_back_ios_new_rounded,
//                       size: 18,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 18),
//                 Text(
//                   "Edit Profile",
//                   style: AppTextStyles.titleLarge.copyWith(color: Colors.white),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 25),

//           Expanded(
//             child: FadeTransition(
//               opacity: _fadeAnimation,
//               child: SlideTransition(
//                 position: _slideAnimation,
//                 child: ListView(
//                   padding: const EdgeInsets.symmetric(horizontal: 22),
//                   children: [
//                     // Card --------------------------------------------------
//                     Container(
//                       padding: const EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(20),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.06),
//                             blurRadius: 12,
//                             offset: const Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         children: [
//                           _buildField(
//                             label: "Full Name",
//                             controller: nameController,
//                             icon: Icons.person_rounded,
//                           ),
//                           const SizedBox(height: 20),
//                           _buildField(
//                             label: "Department",
//                             controller: deptController,
//                             icon: Icons.school_rounded,
//                           ),
//                           const SizedBox(height: 20),
//                           _buildField(
//                             label: "Email",
//                             controller: emailController,
//                             icon: Icons.email_rounded,
//                           ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 40),

//                     // Update button ---------------------------------------
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: _saveChanges,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: AppColors.primary,
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                           elevation: 5,
//                         ),
//                         child: const Text(
//                           "Update Profile",
//                           style: TextStyle(
//                             fontSize: 17,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 14),

//                     // Cancel button ----------------------------------------
//                     SizedBox(
//                       width: double.infinity,
//                       child: OutlinedButton(
//                         onPressed: () => Navigator.pop(context),
//                         style: OutlinedButton.styleFrom(
//                           side: BorderSide(
//                             color: AppColors.primary,
//                             width: 1.4,
//                           ),
//                           padding: const EdgeInsets.symmetric(vertical: 15),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(16),
//                           ),
//                         ),
//                         child: Text(
//                           "Cancel",
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: AppColors.primary,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 35),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ------------------- Input Field Widget ------------------- //
//   Widget _buildField({
//     required String label,
//     required TextEditingController controller,
//     required IconData icon,
//   }) {
//     return TextField(
//       controller: controller,
//       style: const TextStyle(
//         color: Colors.black87,
//         fontSize: 16,
//         fontWeight: FontWeight.w500,
//       ),
//       decoration: InputDecoration(
//         labelText: label,
//         prefixIcon: Icon(icon, color: AppColors.primary),
//         filled: true,
//         fillColor: Colors.grey.shade100,
//         contentPadding: const EdgeInsets.symmetric(
//           horizontal: 20,
//           vertical: 18,
//         ),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(18),
//           borderSide: BorderSide.none,
//         ),
//       ),
//     );
//   }

//   // ------------------- Save Function ------------------- //
//   void _saveChanges() {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: const Text("Profile updated successfully!"),
//         backgroundColor: AppColors.primary,
//         behavior: SnackBarBehavior.floating,
//       ),
//     );

//     Navigator.pop(context);
//   }
// }
