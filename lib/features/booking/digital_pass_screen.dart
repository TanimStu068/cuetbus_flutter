import 'dart:io';
import 'package:cuetbus/core/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

class DigitalPassScreen extends StatefulWidget {
  final String busNumber;
  final String route;
  final String seats;
  final String date;
  final String time;

  const DigitalPassScreen({
    super.key,
    required this.busNumber,
    required this.route,
    required this.seats,
    required this.date,
    required this.time,
  });

  @override
  State<DigitalPassScreen> createState() => _DigitalPassScreenState();
}

class _DigitalPassScreenState extends State<DigitalPassScreen> {
  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          "Digital Pass",
          style: TextStyle(color: theme.appBarTheme.foregroundColor),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: theme.appBarTheme.foregroundColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            /// -------------------------------
            /// MAIN TICKET CARD
            /// -------------------------------
            Screenshot(
              controller: screenshotController,

              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    /// ---------------- Top Section ----------------
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.95),

                        // color: AppColors.primary.withOpacity(0.95),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(22),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "CUETBus Pass",
                            style: theme.textTheme.titleMedium!.copyWith(
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Show this while boarding",
                            style: theme.textTheme.bodySmall!.copyWith(
                              color: theme.colorScheme.onPrimary.withOpacity(
                                0.9,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _ticketInfo("Bus", widget.busNumber),
                              _ticketInfo("Seat", widget.seats),
                              _ticketInfo("Time", widget.time),
                            ],
                          ),
                        ],
                      ),
                    ),

                    /// ---------------- Divider Dots ----------------
                    Container(
                      height: 18,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/ticket_cut.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    /// ---------------- Bottom Section ----------------
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          /// QR CODE
                          QrImageView(
                            data:
                                "BUS=${widget.busNumber}|SEAT=${widget.seats}|TIME=${widget.time}|DATE=${widget.date}|ROUTE=${widget.route}",
                            version: QrVersions.auto,
                            size: 180,
                            // Dynamic color for QR modules
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.onBackground,
                            // Optional: dynamic background
                            backgroundColor: Theme.of(
                              context,
                            ).scaffoldBackgroundColor,
                          ),

                          const SizedBox(height: 20),
                          _rowInfo("Route", widget.route),
                          const SizedBox(height: 10),
                          _rowInfo("Date", widget.date),

                          const SizedBox(height: 35),

                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Signed by",
                                  style: Theme.of(context).textTheme.bodySmall!
                                      .copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .color
                                            ?.withOpacity(0.6),
                                        fontStyle: FontStyle.italic,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Syed Masrur Ahmmad",
                                  style: Theme.of(context).textTheme.bodyMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                ),
                                Text(
                                  "Director, CUET Transport Section",
                                  style: Theme.of(context).textTheme.bodySmall!
                                      .copyWith(
                                        color: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium!.color,
                                      ),
                                ),

                                // Text(
                                //   "Signed by",
                                //   style: AppTextStyles.bodySmall.copyWith(
                                //     color: Colors.grey.shade600,
                                //     fontStyle: FontStyle.italic,
                                //   ),
                                // ),
                                // const SizedBox(height: 4),
                                // Text(
                                //   "Syed Masrur Ahmmad",
                                //   style: AppTextStyles.bodyMedium.copyWith(
                                //     fontWeight: FontWeight.w700,
                                //     fontSize: 16,
                                //   ),
                                // ),
                                // Text(
                                //   "Director, CUET Transport Section",
                                //   style: AppTextStyles.bodySmall.copyWith(
                                //     color: Colors.black87,
                                //   ),
                                // ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 35),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            /// Download & Share buttons
            Row(
              children: [
                Expanded(
                  child: _secondaryButton(
                    title: "Share",
                    icon: Icons.share,
                    onTap: () {
                      final ticketInfo =
                          """
                                        CUETBus Digital Pass
                                        Bus: ${widget.busNumber}
                                        Seat: ${widget.seats}
                                        Route: ${widget.route}
                                        Date: ${widget.date}
                                        Time: ${widget.time}
                                      """;

                      Share.share(ticketInfo, subject: "CUETBus Ticket");
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _primaryButton(
                    title: "Download",
                    icon: Icons.download_rounded,
                    onTap: () async {
                      // 1. Request permission
                      var status = await Permission.storage.request();
                      if (!status.isGranted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Permission denied")),
                        );
                        return;
                      }

                      // Capture the screenshot
                      final imageBytes = await screenshotController.capture();
                      if (imageBytes != null) {
                        // Save using gallery_saver_plus
                        final tempDir = await getTemporaryDirectory();
                        final filePath =
                            '${tempDir.path}/CUETBus_${DateTime.now().millisecondsSinceEpoch}.png';

                        // Save bytes to a temporary file first
                        final file = await File(
                          filePath,
                        ).writeAsBytes(imageBytes);

                        // Save to gallery and check result
                        bool? saved = await GallerySaver.saveImage(
                          file.path,
                          albumName: "CUETBus",
                        );
                        if (saved == true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Ticket saved to gallery!"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Failed to save ticket!"),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }

                        Navigator.pushNamed(
                          context,
                          AppRoutes.bookingConfirmation,
                          arguments: {
                            'busName': widget.busNumber,
                            'route': widget.route,
                            'date': widget.date,
                            'selectedSeats': widget.seats,
                            'time': widget.time,
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            /// Note
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "Keep this QR code visible at all times while boarding.",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ----------------------------
  /// SINGLE TICKET INFO (TOP CARD)
  /// ----------------------------
  Widget _ticketInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  /// ----------------------------
  /// ROW ITEM (Route / Date)
  /// ----------------------------
  Widget _rowInfo(String label, String value) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.textTheme.bodyMedium?.color,
            ),
            softWrap: true,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// ----------------------------
  /// BUTTONS
  /// ----------------------------
  Widget _primaryButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: theme.colorScheme.onPrimary, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 17,
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _secondaryButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.colorScheme.primary.withOpacity(0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: theme.colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
