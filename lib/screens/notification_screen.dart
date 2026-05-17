import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  static const Color primaryColor = Color(0xFF1E3A8A);
  static const Color darkText = Color(0xFF1F2937);

  @override
  Widget build(BuildContext context) {
    final notifications = [
      ['New Property Added', 'Modern apartment in BKK1 is now available', '5 min ago', Icons.home_outlined],
      ['Price Update', 'Family House price changed from \$750 to \$700', '1 hour ago', Icons.local_offer_outlined],
      ['Saved Property Alert', 'One of your saved properties has new photos', '3 hours ago', Icons.bookmark_border],
      ['Rental Reminder', 'Check your favorite homes before they are rented', 'Yesterday', Icons.notifications_outlined],
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Notifications',
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: darkText),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.notifications, color: primaryColor, size: 30),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('4 Notifications', style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text('Rental updates and alerts', style: GoogleFonts.inter(fontSize: 14, color: Colors.white70)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _statCard(Icons.mark_email_unread_outlined, '3', 'Unread'),
              const SizedBox(width: 12),
              _statCard(Icons.done_all, '12', 'Read'),
            ],
          ),
          const SizedBox(height: 24),
          Text('Recent Notifications', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: darkText)),
          const SizedBox(height: 12),
          ...notifications.map((item) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: primaryColor.withValues(alpha: 0.08),
                    child: Icon(item[3] as IconData, color: primaryColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item[0] as String, style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: darkText)),
                        const SizedBox(height: 4),
                        Text(item[1] as String, style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600])),
                      ],
                    ),
                  ),
                  Text(item[2] as String, style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[500])),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _statCard(IconData icon, String number, String title) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: primaryColor, size: 28),
            const SizedBox(height: 8),
            Text(number, style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: darkText)),
            Text(title, style: GoogleFonts.inter(fontSize: 13, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}