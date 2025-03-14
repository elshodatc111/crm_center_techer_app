import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../const/constants.dart';

class AttendanceScreen extends StatefulWidget {
  final List<dynamic> users;
  final int groupId;

  const AttendanceScreen({super.key, required this.users, required this.groupId});

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late Map<int, int?> attendanceStatus;

  @override
  void initState() {
    super.initState();
    attendanceStatus = {for (var user in widget.users) user['id'] ?? 0: null};
  }

  void _submitAttendance() async {
    if (attendanceStatus.values.any((status) => status == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Barcha foydalanuvchilar uchun davomat tanlanishi shart!")),
      );
      return;
    }

    final box = GetStorage();
    final token = box.read('token') ?? '';
    final baseUrl = AppConstants.apiUrl;
    final url = Uri.parse('$baseUrl/davomad');

    if (token.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Token topilmadi!")),
      );
      return;
    }

    final attendanceList = {
      "attendances": attendanceStatus.entries.map((entry) {
        return {
          "user_id": entry.key,
          "group_id": widget.groupId,
          "status": entry.value
        };
      }).toList()
    };

    final body = jsonEncode(attendanceList);

    // Konsolga yuborilayotgan JSON body-ni chiqaramiz
    print("Yuborilayotgan JSON ma'lumot:");
    print(body);

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    print("Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Davomat muvaffaqiyatli saqlandi!")),
      );
      if (mounted) {
        Navigator.pop(context, true);
        Navigator.pop(context, true);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Xatolik yuz berdi! Kod: ${response.statusCode}, Javob: ${response.body}")),
      );
    }
  }

  bool get isAllSelected => !attendanceStatus.values.any((status) => status == null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Davomat olish",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pop(context, true);
        },
      ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.users.length,
              itemBuilder: (context, index) {
                final user = widget.users[index];
                final userName = user['user_name'] ?? "Ism yo'q";
                final userId = user['id'] ?? 0;
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Center(child: Text(userName, style: const TextStyle(fontWeight: FontWeight.bold))),
                    subtitle: const Center(child: Text("Bugun darsda bormi?")),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _attendanceButton(userId, "Yo‘q", 0, Colors.red),
                        const SizedBox(width: 8),
                        _attendanceButton(userId, "Bor", 1, Colors.blue),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          widget.users.isNotEmpty?Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isAllSelected ? _submitAttendance : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isAllSelected ? Colors.blue : Colors.grey,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Davomatni yuborish"),
              ),
            ),
          ): const Center(
            child: Text("Guruh talabalari mavjud emas."),
          )
        ],
      ),
    );
  }

  Widget _attendanceButton(int userId, String text, int status, Color color) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          attendanceStatus[userId] = status;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: attendanceStatus[userId] == status ? color : Colors.grey,
        minimumSize: const Size(70, 40),
      ),
      child: Text(text),
    );
  }
}
