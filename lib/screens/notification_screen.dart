import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _selectedIndex = 2; // Notifikasi is active

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Notifikasi'),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            const SizedBox(height: 8),
            _buildNotificationItem(
              context,
              icon: Icons.assignment,
              iconColor: Colors.blue,
              backgroundColor: Colors.blue.shade100,
              title:
                  'Anda telah mengirimkan pengajuan tugas untuk Pengumpulan Laporan Akhir Assessment 3 (Tugas Besar)',
              time: '3 Hari 9 Jam Yang Lalu',
            ),
            _buildNotificationItem(
              context,
              icon: Icons.quiz,
              iconColor: Colors.purple,
              backgroundColor: Colors.purple.shade100,
              title:
                  'Anda telah mengirimkan pengajuan tugas untuk Pengumpulan Laporan Akhir Assessment 3 (Tugas Besar)',
              time: '3 Hari 9 Jam Yang Lalu',
            ),
            _buildNotificationItem(
              context,
              icon: Icons.assignment,
              iconColor: Colors.blue,
              backgroundColor: Colors.blue.shade100,
              title:
                  'Anda telah mengirimkan pengajuan tugas untuk Pengumpulan Laporan Akhir Assessment 3 (Tugas Besar)',
              time: '3 Hari 9 Jam Yang Lalu',
            ),
            _buildNotificationItem(
              context,
              icon: Icons.quiz,
              iconColor: Colors.purple,
              backgroundColor: Colors.purple.shade100,
              title:
                  'Anda telah mengirimkan pengajuan tugas untuk Pengumpulan Laporan Akhir Assessment 3 (Tugas Besar)',
              time: '3 Hari 9 Jam Yang Lalu',
            ),
            Opacity(
              opacity: 0.7,
              child: _buildNotificationItem(
                context,
                icon: Icons.campaign,
                iconColor: Colors.orange,
                backgroundColor: Colors.orange.shade100,
                title:
                    'Pengumuman: Jadwal Ujian Tengah Semester telah diperbarui.',
                time: '4 Hari 2 Jam Yang Lalu',
              ),
            ),
            const SizedBox(height: 32),
            const Center(
              child: Text(
                'Semua notifikasi telah ditampilkan',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFB93A3D),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 20,
              offset: Offset(0, -4),
            ),
          ],
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + 8,
          top: 12,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(0, Icons.home, 'Home'),
            _buildNavItem(1, Icons.school, 'Kelas Saya'),
            _buildNavItem(2, Icons.notifications, 'Notifikasi'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () {
        if (index == 0 || index == 1) {
          Navigator.of(context).pop(); // Go back to home
        } else {
          setState(() => _selectedIndex = index);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 28,
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required String title,
    required String time,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade800
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.transparent),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.schedule, size: 10, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
