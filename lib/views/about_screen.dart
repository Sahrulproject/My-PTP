import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});
  static const id = "/about_screen";

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2D3748),
      appBar: AppBar(
        title: Text(
          "Tentang Aplikasi",
          style: TextStyle(
            fontFamily: "StageGrotesk_Bold",
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF2D3748),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 8,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 50,
                    child: ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [
                          Colors.black,
                          Colors.grey,
                        ], // Bisa gradient juga!
                      ).createShader(bounds),
                      child: Image.asset(
                        "assets/images/newvector_bg.png",
                        width: 100,
                        height: 100,
                        color: Colors.white, // Penting: image harus putih
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Versi 1.1.0",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    Text(
                      "My PTP adalah aplikasi absensi digital yang dirancang untuk mempermudah proses pencatatan kehadiran. Dengan tampilan yang sederhana dan fitur yang praktis, My PTP membantu pengguna mengelola aktivitas absensi secara lebih cepat, efisien, dan akurat",
                      style: TextStyle(
                        fontFamily: "StageGrotesk_Regular",
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 120),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 150),
                        Text(
                          "© 2025 My PTP. All rights reserved.",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
