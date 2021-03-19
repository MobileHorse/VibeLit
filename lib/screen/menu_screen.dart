import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:vibelit/config/styles.dart';
import 'package:vibelit/screen/info_screen.dart';
import 'package:vibelit/widget/button/icon_circle_button.dart';
import 'package:vibelit/widget/card_container.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {

  String version;

  @override
  void initState() {
    super.initState();
    version = "";
    getVersion();
  }

  void getVersion() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        version = packageInfo.version;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.bgPurple,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 60),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Container()),
                  IconCircleButton(
                    icon: Icon(
                      Icons.clear,
                      size: 24,
                      color: Styles.txtColor,
                    ),
                    onClick: () {
                      Navigator.pop(context);
                    },
                    size: 24,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Column(
              children: [
                CardContainerWidget(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => InfoScreen(),));
                          },
                          child: Text(
                            " PIÙ  INFO ",
                            style: TextStyle(color: Styles.txtColor, fontSize: 24, decoration: TextDecoration.underline, fontFamily: 'Montserrat'),
                          )),
                      SizedBox(
                        height: 50,
                      )
                    ],
                  ),
                ),
                Transform.translate(
                    offset: Offset(0, -60),
                  child: CardContainerWidget(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          " CONTATTI ",
                          style: TextStyle(color: Styles.txtColor, fontSize: 24, decoration: TextDecoration.underline, fontFamily: 'Montserrat'),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Icon(Icons.mail_outlined, size: 48, color: Styles.iconColor,),
                        SizedBox(height: 10,),
                        Text(
                          "Info@vibelit.it",
                          style: TextStyle(color: Styles.txtColor, fontSize: 20, fontFamily: 'Montserrat'),
                        ),
                        SizedBox(height: 20,),
                        Icon(Icons.language, size: 48, color: Styles.iconColor,),
                        SizedBox(height: 10,),
                        Text(
                          "www.vibelit.it",
                          style: TextStyle(color: Styles.txtColor, fontSize: 20, fontFamily: 'Montserrat'),
                        ),
                        SizedBox(height: 20,),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.language, size: 36, color: Styles.iconColor,),
                            SizedBox(width: 20,),
                            Icon(Icons.language, size: 36, color: Styles.iconColor,),
                            SizedBox(width: 20,),
                            Icon(Icons.language, size: 36, color: Styles.iconColor,),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Text(
                          "@vibelit",
                          style: TextStyle(color: Styles.txtColor, fontSize: 20, fontFamily: 'Montserrat'),
                        ),
                        SizedBox(height: 60,),
                        Text(
                          "App version: $version",
                          style: TextStyle(color: Styles.txtColor, fontSize: 14, fontFamily: 'Montserrat'),
                        ),
                      ],
                    ),
                  )
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
