import 'package:flutter/material.dart';
import 'package:crm_center_techer/main/home/widget/InfoRow.dart';

class GroupInfo extends StatelessWidget {
  final Map<String, dynamic> group;

  const GroupInfo({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoRow(label: "Guruh nomi:", value: group['group_name']),
        InfoRow(label: "Guruh narxi:", value: "${group['price']} so'm"),
        InfoRow(label: "Boshlanish vaqti:", value: group['lessen_start']),
        InfoRow(label: "Tugash vaqti:", value: group['lessen_end']),
        InfoRow(label: "Darslar soni:", value: "${group['lessen_count']}"),
        InfoRow(label: "Dars xonasi:", value: group['room']),
      ],
    );
  }
}
