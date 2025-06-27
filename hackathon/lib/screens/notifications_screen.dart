import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationModel {
  final String id;
  final String type;
  final String message;
  final DateTime timestamp;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.type,
    required this.message,
    required this.timestamp,
    this.isRead = false,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Sample notification data
  final List<NotificationModel> notifications = [
    NotificationModel(
      id: '1',
      type: 'Loan Approved',
      message: 'Your loan application for 1500 has been approved.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: false,
    ),
    NotificationModel(
      id: '2',
      type: 'Repayment Due',
      message: 'Your loan repayment of 500 is due on May 10, 2025.',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: false,
    ),
    NotificationModel(
      id: '3',
      type: 'Custom Alert',
      message: 'Please submit your yield report by May 15, 2025.',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
    ),
  ];

  void _toggleReadStatus(String id) {
    setState(() {
      final notification = notifications.firstWhere((n) => n.id == id);
      notification.isRead = !notification.isRead;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[600]!, Colors.green[100]!],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifications',
                  style: GoogleFonts.roboto(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: notifications.isEmpty
                      ? Center(
                          child: Text(
                            'No notifications available',
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                              color: Colors.green[900],
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            final notification = notifications[index];
                            return AnimatedOpacity(
                              opacity: 1.0,
                              duration: const Duration(milliseconds: 300),
                              child: GestureDetector(
                                onTap: () => _toggleReadStatus(notification.id),
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  margin: const EdgeInsets.only(bottom: 16.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          _getIconForType(notification.type),
                                          color: Colors.green[800],
                                          size: 30,
                                        ),
                                        const SizedBox(width: 16.0),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                notification.type,
                                                style: GoogleFonts.roboto(
                                                  fontSize: 18,
                                                  fontWeight: notification.isRead
                                                      ? FontWeight.normal
                                                      : FontWeight.bold,
                                                  color: Colors.green[900],
                                                ),
                                              ),
                                              const SizedBox(height: 4.0),
                                              Text(
                                                notification.message,
                                                style: GoogleFonts.roboto(
                                                  fontSize: 14,
                                                  color: Colors.grey[800],
                                                ),
                                              ),
                                              const SizedBox(height: 8.0),
                                              Text(
                                                _formatTimestamp(
                                                    notification.timestamp),
                                                style: GoogleFonts.roboto(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          notification.isRead
                                              ? Icons.check_circle_outline
                                              : Icons.circle,
                                          color: notification.isRead
                                              ? Colors.green[600]
                                              : Colors.green[900],
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'Loan Approved':
        return Icons.check_circle;
      case 'Repayment Due':
        return Icons.payment;
      case 'Custom Alert':
        return Icons.warning;
      default:
        return Icons.info;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    }
  }
}
