import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = TextEditingController();
  List<String> items = ["🛏️ Make your bed", "🧘‍♂️ Meditate for 5 minutes", "🚶‍♂️ Walk 5,000 steps", "🛌 Sleep on time 🕙"];

  void add() {
    String name = controller.text.trim();

    if (name.isNotEmpty) {
      setState(() => items.add(controller.text));
      controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff543A14),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 15, bottom: 25),
              decoration: BoxDecoration(
                color: Color(0xff543A14),
                border: Border(
                  bottom: BorderSide(color: Colors.black, width: 5),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            offset: Offset(8, 8),
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      margin: EdgeInsets.only(left: 10),
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: Colors.black),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 40,
                          ),
                          hintText: "YOUR TASK",
                          fillColor: Color(0xffFFF0DC),
                          filled: true,
                          hintStyle: TextStyle(
                            color: Color(0xff543A14),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: add,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: null,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black,
                              offset: Offset(8, 8),
                              spreadRadius: 1)
                        ],
                        color: Color(0xffFFF0DC),
                      ),
                      child: const Text(
                        "ADD",
                        style: TextStyle(
                          color: Color(0xff543A14),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Color(0xffd6b88b),
                padding: EdgeInsets.only(top: 15),
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xfff2d9b8),
                        border: Border.all(color: Colors.black, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            offset: Offset(8, 8),
                            spreadRadius: 1,
                          )
                        ],
                      ),
                      child: Text(
                        items[index],
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
