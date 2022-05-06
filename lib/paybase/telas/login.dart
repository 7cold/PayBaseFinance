import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:layouts/paybase/const/buttons.dart';
import 'package:layouts/paybase/const/colors.dart';
import 'package:layouts/paybase/const/inputs.dart';
import 'package:layouts/paybase/const/text.dart';
import 'package:layouts/paybase/const/widgets.dart';
import 'package:layouts/paybase/controller/controller.dart';
import 'package:layouts/paybase/telas/signup.dart';

class LoginPB extends StatelessWidget {
  final Controller c = Get.put(Controller());
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => c.loading.value == true
          ? WidgetsPB.loading
          : Scaffold(
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: CustomScrollView(
                    physics: BouncingScrollPhysics(),
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Form(
                          key: formKey,
                          child: Column(
                            children: [
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 40),
                                    Text("Vamos efetuar o Login",
                                        style: TextPB.h2),
                                    Text("Seja bem vindo, entre com seus dados",
                                        style: TextPB.display5),
                                    SizedBox(height: 40),
                                    Text("E-mail", style: TextPB.display4),
                                    SizedBox(height: 8),
                                    InputPB.field(
                                        _email,
                                        "entre com seu e-mail",
                                        Icons.email_outlined),
                                    SizedBox(height: 20),
                                    Text("Senha", style: TextPB.display4),
                                    SizedBox(height: 8),
                                    InputPB.pass(_pass, "entre com sua senha",
                                        Icons.lock_open_outlined),
                                    SizedBox(height: 30),
                                    SizedBox(
                                        width: Get.context.width,
                                        child: ButtonsPB().button("Login", () {
                                          if (formKey.currentState.validate()) {
                                            c.login(
                                                email: _email.text,
                                                pass: _pass.text);
                                          }
                                        })),
                                    SizedBox(height: 30),
                                    Center(
                                      child: Text(
                                          "Ou efetue o login com sua rede social",
                                          style: TextPB.display5),
                                    ),
                                    Divider(),
                                    SizedBox(height: 15),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Column(
                                      children: [
                                        ElevatedButton(
                                            onPressed: () {
                                              print(_email.text + _pass.text);
                                            },
                                            child: Text("data")),
                                        ElevatedButton(
                                            onPressed: () {
                                              print(c.logout());
                                            },
                                            child: Text("Sair")),
                                        ButtonsPB().googleButton(),
                                        SizedBox(height: 20),
                                        ButtonsPB().facebookButton(),
                                      ],
                                    ),
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      onTap: () {
                                        Get.to(() => SignUpPB(),
                                            duration:
                                                Duration(milliseconds: 150));
                                      },
                                      child: RichText(
                                        text: TextSpan(
                                          style: TextPB.display5,
                                          text: 'Ainda não tem uma conta? ',
                                          children: [
                                            TextSpan(
                                              text: 'Cadastre-se',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(corPri)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
