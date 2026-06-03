import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  static const Color primaryColor = Color(0xFF1E3A8A);
  static const Color darkText = Color(0xFF1F2937);

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        'title': 'New Property Added',
        'message': 'Modern apartment in BKK1 is now available',
        'time': '5 min ago',
        'icon': Icons.home_outlined,
        'detail':
        'A new modern apartment in BKK1 has been added. You can check the property details, price, location, and available facilities.',
      },
      {
        'title': 'Price Update',
        'message': 'Family House price changed from \$750 to \$700',
        'time': '1 hour ago',
        'icon': Icons.local_offer_outlined,
        'detail':
        'The Family House price has been updated. The new rental price is now \$700 per month instead of \$750.',
      },
      {
        'title': 'Saved Property Alert',
        'message': 'One of your saved properties has new photos',
        'time': '3 hours ago',
        'icon': Icons.bookmark_border,
        'detail':
        'One of your saved properties has new photos. Open the saved property page to review the latest images.',
      },
      {
        'title': 'Rental Reminder',
        'message': 'Check your favorite homes before they are rented',
        'time': 'Yesterday',
        'icon': Icons.notifications_outlined,
        'detail':
        'Some of your favorite rental homes may be rented soon. Review them again before they become unavailable.',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Notifications',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: darkText,
          ),
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
                  child: Icon(
                    Icons.notifications,
                    color: primaryColor,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${notifications.length} Notifications',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Rental updates and alerts',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
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

          Text(
            'Recent Notifications',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: darkText,
            ),
          ),

          const SizedBox(height: 12),

          ...notifications.map((item) {
            return InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationDetailScreen(
                      title: item['title'] as String,
                      message: item['message'] as String,
                      time: item['time'] as String,
                      detail: item['detail'] as String,
                      icon: item['icon'] as IconData,
                    ),
                  ),
                );
              },
              child: Container(
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
                      child: Icon(
                        item['icon'] as IconData,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title'] as String,
                            style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold,
                              color: darkText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['message'] as String,
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      children: [
                        Text(
                          item['time'] as String,
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ],
                ),
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
            Text(
              number,
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: darkText,
              ),
            ),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationDetailScreen extends StatelessWidget {
  final String title;
  final String message;
  final String time;
  final String detail;
  final IconData icon;

  const NotificationDetailScreen({
    super.key,
    required this.title,
    required this.message,
    required this.time,
    required this.detail,
    required this.icon,
  });

  static const Color primaryColor = NotificationScreen.primaryColor;
  static const Color darkText = NotificationScreen.darkText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Notification Detail',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: darkText,
          ),
        ),
        iconTheme: const IconThemeData(color: darkText),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: primaryColor.withValues(alpha: 0.08),
                child: Icon(
                  icon,
                  color: primaryColor,
                  size: 34,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                time,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.grey[500],
                ),
              ),

              const SizedBox(height: 20),

              Text(
                message,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: darkText,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                detail,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  height: 1.5,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}