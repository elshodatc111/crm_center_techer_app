import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:crm_center_techer/const/constants.dart';
import 'package:crm_center_techer/main/home/AttendanceScreen.dart';
import 'package:crm_center_techer/main/home/widget/AttendanceHistoryList.dart';
import 'package:crm_center_techer/main/home/widget/GroupInfo.dart';
import 'package:crm_center_techer/main/home/widget/CustomButton.dart';
import 'package:crm_center_techer/main/home/widget/GroupImage.dart';

class GroupShow extends StatefulWidget {
  final int id;

  const GroupShow({super.key, required this.id});

  @override
  _GroupShowState createState() => _GroupShowState();
}

class _GroupShowState extends State<GroupShow> {
  late Future<Map<String, dynamic>> groupData;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() {
    setState(() {
      groupData = fetchGroupData();
    });
  }

  Future<Map<String, dynamic>> fetchGroupData() async {
    final box = GetStorage();
    final token = box.read('token');
    final baseUrl = AppConstants.apiUrl;
    final url = Uri.parse('$baseUrl/group/${widget.id}');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Ma\'lumotlarni yuklashda xatolik yuz berdi!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Guruh ma'lumotlari", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: groupData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Xatolik: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Ma'lumot topilmadi"));
          }

          final data = snapshot.data!;
          final group = data['group'];
          final users = data['users'] as List<dynamic>;
          final attendanceHistory = data['davomad_history'] as List<dynamic>;

          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Groupimage(),
                  const SizedBox(height: 16),
                  GroupInfo(group: group),
                  const SizedBox(height: 16),
                  group['davomad_day'] == true
                      ? CustomButton(
                    label: "Davomat olish",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AttendanceScreen(users: users, groupId: group['id']),
                        ),
                      ).then((value) {
                        if (value == true) {
                          _fetchData();
                        }
                      });
                    },
                  )
                      : const Text("Bugun dars kuni emas."),
                  const SizedBox(height: 16),
                  AttendanceHistoryList(attendanceHistory: attendanceHistory),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
