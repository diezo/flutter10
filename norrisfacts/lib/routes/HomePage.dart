import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void Function()? genBtnOnPressed;
  bool linkedInPressed = false;

  String fact = "...";

  @override
  void initState() {
    super.initState();
    updateFact();
  }

  Future<void> updateFact() async {
    setState(() => genBtnOnPressed = null);

    final url = Uri.parse("https://api.chucknorris.io/jokes/random?category=animal,career,dev,fashion,food,money,movie,music,science,sport,travel");
    bool success = false;

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        success = true;

        setState(() {
          fact = jsonDecode(response.body)["value"];
        });
      }
    } catch (e) {
      /**/
    }

    // Request Failed
    if (!success) setState(() => fact = "Ahh... Something Went Wrong!");

    // Generate Button Visibility
    setState(() => genBtnOnPressed = updateFact);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffb6cdcf),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 100),
              child: Image.asset("assets/images/logo.png"),
            ),
            Container(
              margin: EdgeInsets.only(top: 60),
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              decoration: BoxDecoration(
                color: Color(0xff2b696d),
                border: Border(
                  left: BorderSide(
                    color: Color(0xff244647),
                    width: 15,
                  ),
                  top: BorderSide(color: Color(0xff244647), width: 5),
                  right: BorderSide(color: Color(0xff244647), width: 5),
                  bottom: BorderSide(color: Color(0xff244647), width: 5),
                ),
              ),
              child: Text(
                fact,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Opacity(
              opacity: genBtnOnPressed == null ? 0.25 : 1,
              child: GestureDetector(
                onTap: genBtnOnPressed,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  margin: EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: genBtnOnPressed == null
                        ? Color(0xff000000)
                        : Color(0xffe95925),
                    boxShadow: genBtnOnPressed == null
                        ? null
                        : [
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 0,
                              spreadRadius: 3,
                              offset: Offset(6, 6),
                            ),
                          ],
                    border: Border.all(color: Colors.black, width: 3),
                  ),
                  child: Text(
                    "GENERATE",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Arbutus",
                    ),
                  ),
                ),
              ),
            ),
            Spacer(),
            GestureDetector(
              onTapDown: (_) => setState(() => linkedInPressed = true),
              onTapUp: (_) => setState(() => linkedInPressed = false),
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 100),
                opacity: linkedInPressed ? 0.3 : 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/linkedin.png",
                      width: 20,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5),
                      child: Text(
                        "/deepaksonii",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
