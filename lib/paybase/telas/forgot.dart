import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:layouts/paybase/const/colors.dart';
import 'package:layouts/paybase/const/text.dart';
import 'package:layouts/paybase/controller/controller.dart';

class ForgotPB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 80,
        leading: Container(
          child: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: Color(corPri),
                    borderRadius: BorderRadius.circular(80)),
                child: Icon(Icons.close)),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  Container(
                    child: Obx(
                      () => Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Esqueceu sua senha?", style: TextPB.h2),
                          Text("Entre com um dos metodos de verificação abaixo",
                              style: TextPB.display5),
                          SizedBox(height: 40),
                          Material(
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                c.changeForgot("email");
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                    top: 12, bottom: 12, right: 2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: c.forgot.value == "email"
                                        ? Color(corPri).withAlpha(120)
                                        : Colors.transparent.withAlpha(50)),
                                child: Flex(
                                  direction: Axis.horizontal,
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: Radio(
                                          activeColor: Color(corPri),
                                          value: "email",
                                          groupValue: c.forgot.value,
                                          onChanged: (v) {
                                            c.changeForgot("email");
                                          }),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: !Get.context.isDarkMode
                                                  ? Colors.black87
                                                  : Colors.white),
                                          text: 'Email\n',
                                          children: [
                                            TextSpan(
                                              text:
                                                  'Um link será enviado para seu email.',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 12),
                          Material(
                            borderRadius: BorderRadius.circular(10),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                c.changeForgot("tel");
                              },
                              child: Container(
                                padding: EdgeInsets.only(
                                    top: 12, bottom: 12, right: 2),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: c.forgot.value == "tel"
                                        ? Color(corPri).withAlpha(120)
                                        : Colors.transparent.withAlpha(50)),
                                child: Flex(
                                  direction: Axis.horizontal,
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: Radio(
                                          activeColor: Color(corPri),
                                          value: "tel",
                                          groupValue: c.forgot.value,
                                          onChanged: (v) {
                                            c.changeForgot("tel");
                                          }),
                                    ),
                                    Flexible(
                                      flex: 2,
                                      child: RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: !Get.context.isDarkMode
                                                  ? Colors.black87
                                                  : Colors.white),
                                          text: 'Celular\n',
                                          children: [
                                            TextSpan(
                                              text:
                                                  'Um sms será enviado para seu celular.',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w300,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
