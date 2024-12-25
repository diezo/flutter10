import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController messageEditingController = TextEditingController();
  TextEditingController pinEditingController = TextEditingController();

  String numericText = "";
  String errorLabel = "";

  void setError(String text) {
    setState(() => errorLabel = text.toUpperCase());
  }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: const Text("Copied to clipboard!")),
    );
  }

  void copyResult() {
    if (numericText.isNotEmpty) {
      copyToClipboard(numericText);
    }
  }

  void encryptTap() {
    setError("");

    final String text = messageEditingController.text.trim();
    final String key = pinEditingController.text.trim();

    // Validate Key Length (<=32)
    if (key.length > 32) {
      setError("PIN length must not exceed 32 characters.");
      return;
    }

    // Return if Empty Parameters
    if (text.isEmpty || key.isEmpty) return;

    final String cipherText = aesEncrypt(key, text);

    if (cipherText.isEmpty) {
      setError("Sorry, but we failed to encrypt.");
      return;
    }

    final String numeric = encodeNumeric(cipherText, " ");

    if (numeric.isEmpty) {
      setError("Sorry, but we failed to encrypt.");
      return;
    }

    setState(() => numericText = numeric);
  }

  void decryptTap() {
    setError("");

    final String numeric = messageEditingController.text.trim();
    final String key = pinEditingController.text.trim();

    // Validate Key Length (<=32)
    if (key.length > 32) {
      setError("PIN length must not exceed 32 characters.");
      return;
    }

    // Return if Empty Parameters
    if (numeric.isEmpty || key.isEmpty) return;

    final String cipherText = decodeNumeric(numeric, " ");

    if (cipherText.isEmpty) {
      setError("Invalid ciphertext to decrypt.");
      return;
    }

    final String text = aesDecrypt(key, cipherText);

    if (text.isEmpty) {
      setError("Incorrect PIN!");
      return;
    }

    setState(() => numericText = text);
  }

  String encodeNumeric(String text, String separator) {
    return text
        .split("")
        .map((e) => e.codeUnitAt(0).toString())
        .join(separator);
  }

  String decodeNumeric(String text, String separator) {
    try {
      return String.fromCharCodes(text.split(separator).map(int.parse));
    } catch (_) {
      return "";
    }
  }

  String binaryRepresentation(String text) {
    return String.fromCharCodes(text.runes.toList());
  }

  String aesEncrypt(String key, String text) {
    try {
      final paddedKey = encrypt.Key.fromUtf8(pad(key, 32));
      final iv = encrypt.IV.fromLength(16);
      final String ivBase64 = base64Encode(iv.bytes);

      final encryptor = encrypt.Encrypter(encrypt.AES(paddedKey));
      final String cipherText = encryptor.encrypt(text, iv: iv).base64;

      return "$ivBase64:$cipherText";
    } catch (_) {
      return "";
    }
  }

  String aesDecrypt(String key, String cipherText) {
    try {
      final paddedKey = encrypt.Key.fromUtf8(pad(key, 32));
      final ivBase64 = cipherText.split(":")[0];
      final iv = encrypt.IV.fromBase64(ivBase64);
      final String text = cipherText.split(":")[1];

      final encryptor = encrypt.Encrypter(encrypt.AES(paddedKey));
      final encrypted = encrypt.Encrypted.fromBase64(text);

      return encryptor.decrypt(encrypted, iv: iv);
    } catch (_) {
      return "";
    }
  }

  String pad(String text, int length) {
    if (text.length >= length) return text;

    while (text.length < length) {
      text += "-";
    }

    return text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE8DFCA),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Image.asset(
                "assets/images/cabbage.png",
                width: 80,
              ),
            ),
            Opacity(
              opacity: errorLabel.isEmpty ? 1 : 0.1,
              child: Visibility(
                visible: numericText.isNotEmpty,
                child: GestureDetector(
                  onTap: copyResult,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xffE8DFCA),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.black,
                        width: 3
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(6, 6)
                        )
                      ]
                    ),
                    margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: Column(
                      children: [
                        Text(
                          "TAP TO COPY",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Text(
                            numericText,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: errorLabel.isNotEmpty,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                child: Text(
                  errorLabel,
                  style: TextStyle(
                    color: Color(0xff5B7F69),
                    fontSize: 15,
                    fontWeight: FontWeight.w900
                  ),
                ),
              ),
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 20,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Color(0xff5B7F69),
              ),
              width: double.infinity,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: [
                        Flexible(
                          child: TextField(
                            controller: messageEditingController,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 20),
                              fillColor: Color(0xff688975),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                              hintText: "MESSAGE",
                              hintStyle: TextStyle(
                                color: Color(0xff95AB9E),
                              ),
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                        IntrinsicWidth(
                          child: TextField(
                            controller: pinEditingController,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            keyboardType: TextInputType.numberWithOptions(
                                decimal: false, signed: false),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              fillColor: Color(0xff688975),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                              hintText: "PIN",
                              hintStyle: TextStyle(color: Color(0xff95AB9E)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: decryptTap,
                          child: Container(
                            margin: EdgeInsets.only(right: 8),
                            padding: EdgeInsets.symmetric(
                              vertical: 20,
                            ),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color(0xffE8DFCA),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(8, 8),
                                ),
                              ],
                            ),
                            child: const Text(
                              "DECRYPT",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w900,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: encryptTap,
                          child: Container(
                            margin: EdgeInsets.only(left: 8),
                            padding: EdgeInsets.symmetric(
                              vertical: 20,
                            ),
                            width: double.infinity,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color(0xffE8DFCA),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  offset: Offset(8, 8),
                                ),
                              ],
                            ),
                            child: const Text(
                              "ENCRYPT",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w900,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
