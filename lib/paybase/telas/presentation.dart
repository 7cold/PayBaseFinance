import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:layouts/paybase/const/buttons.dart';
import 'package:layouts/paybase/const/text.dart';
import 'package:layouts/paybase/telas/login.dart';

PageController controller = PageController(
  viewportFraction: 1,
  initialPage: 0,
);

class Presentation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          _Page1(),
          _Page2(),
          _Page3(),
        ],
        controller: controller);
  }
}

class _Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.all(20),
              child: Image.asset(
                "assets/paybase/1.png",
                fit: BoxFit.contain,
              ),
            ),
          ),
          Container(
            width: Get.width,
            height: 300,
            child: Column(
              children: [
                Text(
                  "Pagamentos Rápidos\n no mundo todo",
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 40,
                    left: 15,
                    right: 15,
                    bottom: 40,
                  ),
                  child: Text(
                    "Integração com diversos bancos ao redor do mundo, com suporte personalizado",
                    style: TextPB.display3,
                    textAlign: TextAlign.center,
                  ),
                ),
                ButtonsPB().button("Próximo", () {
                  controller.animateToPage(
                    1,
                    duration: Duration(seconds: 1),
                    curve: Curves.ease,
                  );
                })
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.all(30),
              child: Image.asset(
                "assets/paybase/2.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            width: Get.width,
            height: 300,
            child: Column(
              children: [
                Text(
                  "Pagamentos Rápidos\n no mundo todo",
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 40,
                    left: 15,
                    right: 15,
                    bottom: 40,
                  ),
                  child: Text(
                    "Integração com diversos bancos ao redor do mundo, com suporte personalizado",
                    style: TextPB.display3,
                    textAlign: TextAlign.center,
                  ),
                ),
                ButtonsPB().button("Próximo", () {
                  controller.animateToPage(
                    2,
                    duration: Duration(seconds: 1),
                    curve: Curves.ease,
                  );
                })
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.all(30),
              child: Image.asset(
                "assets/paybase/3.png",
                fit: BoxFit.contain,
              ),
            ),
          ),
          Container(
            width: Get.width,
            height: 300,
            child: Column(
              children: [
                Text(
                  "Pagamentos Rápidos\n no mundo todo",
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 40,
                    left: 15,
                    right: 15,
                    bottom: 40,
                  ),
                  child: Text(
                    "Integração com diversos bancos ao redor do mundo, com suporte personalizado",
                    style: TextPB.display3,
                    textAlign: TextAlign.center,
                  ),
                ),
                ButtonsPB().button("Finalizar", () {
                  Get.offAll(() => LoginPB());
                })
              ],
            ),
          )
        ],
      ),
    );
  }
}
