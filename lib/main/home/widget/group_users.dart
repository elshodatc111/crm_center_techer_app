import 'package:flutter/material.dart';

class GroupUsers extends StatelessWidget {
  final List<dynamic> groupUsers;

  const GroupUsers({super.key, required this.groupUsers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Guruh Talabalari",
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // **Jadval sarlavhalari**
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 16.0),
              color: Colors.blue,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text("FIO", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,),textAlign: TextAlign.center,),),
                  SizedBox(width: 10),
                  Expanded(child: Text("Balans", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,),textAlign: TextAlign.center,),),
                  SizedBox(width: 10),
                  Expanded(child: Text("Telefon raqam", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,),textAlign: TextAlign.center,),),
                ],
              ),
            ),
            const SizedBox(height: 5),
            Expanded(
              child: ListView.builder(
                itemCount: groupUsers.length,
                itemBuilder: (context, index) {
                  var user = groupUsers[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 8.0),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(user["user_name"])),
                        SizedBox(width: 10),
                        Expanded(child: Text(user["balans"].toString()+' so\'m')),
                        SizedBox(width: 10),
                        Expanded(child: Text(user["phone1"])),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
