import 'package:flutter/material.dart';

class AttendanceHistoryList extends StatelessWidget {
  final List<dynamic> attendanceHistory;

  const AttendanceHistoryList({super.key, required this.attendanceHistory});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "📅 Dars Kunlari",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8), // Matn bilan list orasiga joy tashlash

        Wrap(
          spacing: 16, // Elementlar orasidagi gorizontal bo'shliq
          runSpacing: 8, // Qatorlar orasidagi vertikal bo'shliq
          children: List.generate(
            (attendanceHistory.length / 2).ceil(), // Ikkitadan qo'shish
                (index) {
              int firstIndex = index * 2;
              int secondIndex = firstIndex + 1;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildAttendanceItem(attendanceHistory[firstIndex]),
                  secondIndex < attendanceHistory.length
                      ? _buildAttendanceItem(attendanceHistory[secondIndex])
                      : const SizedBox(), // Agar ikkinchi element bo'lmasa bo'sh joy
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceItem(Map<String, dynamic> day) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),

          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              day['data'],
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              day['status'] == 'pedding'
                  ? "⏳ Davomat kutilmoqda"
                  : day['status'] == 'false'
                  ? "❌ Davomat olinmadi"
                  :"✅ Davomat olindi",
              style: TextStyle(
                color: day['status'] == 'true'
                    ? Colors.green
                    : day['status'] == 'false'
                    ? Colors.red
                    : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
