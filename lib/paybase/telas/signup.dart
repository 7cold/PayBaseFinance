import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:layouts/paybase/const/buttons.dart';
import 'package:layouts/paybase/const/colors.dart';
import 'package:layouts/paybase/const/inputs.dart';
import 'package:layouts/paybase/const/text.dart';
import 'package:layouts/paybase/const/widgets.dart';
import 'package:layouts/paybase/controller/controller.dart';

class SignUpPB extends StatelessWidget {
  final Controller c = Get.put(Controller());
  final formKey = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _email = TextEditingController();

  final _celuar = TextEditingController();
  final _senha = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => c.loading.value == true
          ? WidgetsPB.loading
          : Scaffold(
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
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: CustomScrollView(
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Form(
                          key: formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Começar Agora", style: TextPB.h2),
                              Text("Cria uma conta para continuar...",
                                  style: TextPB.display5),
                              SizedBox(height: 40),
                              Text("Nome", style: TextPB.display4),
                              SizedBox(height: 8),
                              InputPB.field(
                                _nome,
                                "Entre com seu nome",
                                Icons.people,
                              ),
                              SizedBox(height: 20),
                              Text("E-mail", style: TextPB.display4),
                              SizedBox(height: 8),
                              InputPB.field(
                                _email,
                                "Entre com seu e-mail",
                                Icons.email_outlined,
                              ),
                              SizedBox(height: 20),
                              Text("Celular", style: TextPB.display4),
                              SizedBox(height: 8),
                              InputPB.field(
                                _celuar,
                                "Entre com seu celular",
                                Icons.phone_in_talk,
                              ),
                              SizedBox(height: 20),
                              Text("Senha", style: TextPB.display4),
                              SizedBox(height: 8),
                              InputPB.pass(
                                _senha,
                                "Entre com sua senha",
                                Icons.lock_open_outlined,
                              ),
                              SizedBox(height: 30),
                              CheckboxListTile(
                                title: RichText(
                                  text: TextSpan(
                                    style: TextPB.display5,
                                    text:
                                        'Quando criada a conta, eu aceito os ',
                                    children: [
                                      TextSpan(
                                        text: 'Termos e Condições',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(corPri)),
                                      ),
                                    ],
                                  ),
                                ),
                                value: c.therms.value,
                                onChanged: (newValue) {
                                  c.therms.value = newValue;
                                },
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              ),
                              SizedBox(height: 30),
                              SizedBox(
                                width: Get.context.width,
                                child: ButtonsPB().button(
                                  "Cadastrar",
                                  c.therms.value == false
                                      ? null
                                      : () {
                                          if (formKey.currentState.validate()) {
                                            c.signup(
                                                email: _email.text,
                                                onFail: () {
                                                  print("erro");
                                                },
                                                onSuccess: () {
                                                  print("sucesso");
                                                },
                                                pass: _senha.text,
                                                userData: {
                                                  "name": _nome.text,
                                                  "email": _email.text,
                                                  "phone": _celuar.text
                                                });
                                          }
                                        },
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
    );
  }
}
