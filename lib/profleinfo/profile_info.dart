import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ProfileInfo extends StatefulWidget {
  const ProfileInfo({super.key});

  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: ClipPath(
        clipper: MyCustomClipper(),
        child: Container(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white70,
                    child: Icon(
                      Icons.person,
                      size: 50,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "~  WELCOME  ~",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                      fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          color: Colors.black26,
          width: double.infinity,
          height: 250.0,
        ),
      ),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height - 50);
    path.lineTo(size.width, 0.0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
