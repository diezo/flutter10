import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const int moneyIncrement = 30;

  @override
  State<StatefulWidget> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  bool loggedToday = true;

  bool smokedPressed = false;
  bool notSmokedPressed = false;

  int streak = 0;
  int moneySaved = 0;

  @override
  void initState() {
    super.initState();

    loadValues();
  }

  void loadValues() async {
    // Load Values
    String storedStreak = "0";
    String storedMoneySaved = "0";

    try {
      storedStreak = await secureStorage.read(key: "streak") ?? "0";
    } catch (e) {}

    try {
      storedMoneySaved = await secureStorage.read(key: "moneySaved") ?? "0";
    } catch (e) {}

    setState(() {
      streak = int.parse(storedStreak);
      moneySaved = int.parse(storedMoneySaved);
    });

    // Logged In Today?
    DateTime now = DateTime.now();
    String lastLogged = "";

    try {
      lastLogged = await secureStorage.read(key: "lastLogged") ?? "";
    } catch (e) {}

    setState(() {
      loggedToday = (lastLogged == DateFormat("yyyy-MM-dd").format(now));
    });
  }

  void setStreak(int value) async {
    try {
      await secureStorage.write(key: "streak", value: value.toString());
    } catch (e) {}

    try {
      await secureStorage.read(key: "streak");
    } catch (e) {}

    setState(() => streak = value);
  }

  void setMoneySaved(int value) async {
    try {
      await secureStorage.write(key: "moneySaved", value: value.toString());
    } catch (e) {}

    try {
      await secureStorage.read(key: "moneySaved");
    } catch (e) {}

    setState(() => moneySaved = value);
  }

  Future<int> getStreak() async {
    String storedStreak = "0";

    try {
      storedStreak = await secureStorage.read(key: "streak") ?? "0";
    } catch (e) {}

    return int.parse(storedStreak);
  }

  Future<int> getMoneySaved() async {
    String storedMoneySaved = "0";

    try {
      storedMoneySaved = await secureStorage.read(key: "moneySaved") ?? "0";
    } catch (e) {}

    return int.parse(storedMoneySaved);
  }

  void clearStreak() async {
    setStreak(0);
  }

  void incrementStreak() async {
    setStreak(await getStreak() + 1);
  }

  void incrementMoneySaved() async {
    setMoneySaved(await getMoneySaved() + HomePage.moneyIncrement);
  }

  void logged() {
    setState(() => loggedToday = true);

    DateTime now = DateTime.now();
    secureStorage.write(
      key: "lastLogged",
      value: DateFormat("yyyy-MM-dd").format(now),
    );
  }

  void positiveDay() {
    incrementStreak();
    incrementMoneySaved();

    logged();
  }

  void negativeDay() {
    // Show Dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("It's okay, you're not alone!"),
          content: const Text(
              "Everyone has tough moments. What's important is that you're still on the path to a healthier life. Let's try again tomorrow, you're stronger than you think!"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Got it, I'll keep going!"),
            ),
          ],
        );
      },
    );

    // Reset Streak
    setStreak(0);
    logged();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffb5c99a),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black, width: 2),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Image.asset(
                      "assets/images/cigarette.png",
                      fit: BoxFit.cover,
                      width: 30,
                      height: 30,
                    ),
                  ),
                  Text(
                    "NO SMOKE",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                  ),
                  Spacer(),
                  Image.asset(
                    "assets/images/user.png",
                    fit: BoxFit.cover,
                    width: 50,
                    height: 50,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                width: double.infinity,
                color: Color(0xffe9f5db),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            spreadRadius: 0,
                            offset: Offset(5, 7),
                          ),
                        ],
                        color: Color(0xff97a97c),
                      ),
                      padding: EdgeInsets.only(bottom: 15, left: 15, right: 15),
                      margin: EdgeInsets.only(top: 15),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.black, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  spreadRadius: 0,
                                  offset: Offset(5, 7),
                                ),
                              ],
                              color: Color(0xffb5c99a),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            margin: EdgeInsets.only(top: 10, bottom: 10),
                            child: Text(
                              "TOTAL MONEY SAVED",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Text(
                            "₹$moneySaved",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w900,
                              fontSize: 50,
                            ),
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: streak > 0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(99999),
                          border: Border.all(color: Colors.black, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black,
                              spreadRadius: 0,
                              offset: Offset(3, 5),
                            ),
                          ],
                          color: Color(0xffbc6c25),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 5,
                        ),
                        margin: EdgeInsets.only(top: 20),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset("assets/images/streak.png"),
                            Text(
                              "$streak ${streak == 1 ? 'Day' : 'Days'}",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 70),
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                "DID YOU KNOW?",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 19,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                "Every cigarette avoided improves your lung function and adds 11 minutes to your life.",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Spacer(),
                            Visibility(
                              visible: !loggedToday,
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTapDown: (details) =>
                                        setState(() => smokedPressed = true),
                                    onTapUp: (details) =>
                                        setState(() => smokedPressed = false),
                                    onTap: () => positiveDay(),
                                    child: AnimatedScale(
                                      duration: Duration(milliseconds: 50),
                                      scale: smokedPressed ? 0.9 : 1,
                                      alignment: Alignment.center,
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 2,
                                          ),
                                          boxShadow: !smokedPressed
                                              ? [
                                                  BoxShadow(
                                                    color: Colors.black,
                                                    spreadRadius: 2,
                                                    offset: Offset(6, 8),
                                                  ),
                                                ]
                                              : null,
                                          color: Color(0xff718355),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 15,
                                          vertical: 15,
                                        ),
                                        margin: EdgeInsets.only(top: 20),
                                        child: Text(
                                          "I DIDN'T SMOKE YESTERDAY.!",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTapDown: (details) =>
                                        setState(() => notSmokedPressed = true),
                                    onTapUp: (details) => setState(
                                        () => notSmokedPressed = false),
                                    onTap: () => negativeDay(),
                                    child: AnimatedScale(
                                      duration: Duration(milliseconds: 50),
                                      scale: notSmokedPressed ? 0.9 : 1,
                                      alignment: Alignment.center,
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 2,
                                          ),
                                          boxShadow: !notSmokedPressed
                                              ? [
                                                  BoxShadow(
                                                    color: Colors.black,
                                                    spreadRadius: 2,
                                                    offset: Offset(6, 8),
                                                  ),
                                                ]
                                              : null,
                                          color: Color(0xffbc4749),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 15,
                                          vertical: 15,
                                        ),
                                        margin: EdgeInsets.only(top: 17),
                                        child: Text(
                                          "I SMOKED YESTERDAY",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Visibility(
                              visible: loggedToday,
                              child: Container(
                                margin: EdgeInsets.only(
                                  bottom: 20,
                                ),
                                child: Text(
                                  "Come back tomorrow!",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          ],
                        ),
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
