import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:layouts/paybase/const/buttons.dart';
import 'package:layouts/paybase/const/colors.dart';
import 'package:layouts/paybase/const/inputs.dart';
import 'package:layouts/paybase/const/text.dart';
import 'package:layouts/paybase/const/widgets.dart';
import 'package:layouts/paybase/controller/controller.dart';
import 'package:layouts/paybase/data/accountBank_data.dart';
import 'package:layouts/paybase/data/user_data.dart';

class AccoutBankPB extends StatelessWidget {
  final TextEditingController _name = TextEditingController();
  final _amount = MoneyMaskedTextController(
    decimalSeparator: ',',
    thousandSeparator: '.',
  );
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Controller c = Get.put(Controller());

    return Obx(() {
      UserData user = UserData.fromMap(c.userData);
      return c.loading.value == true
          ? WidgetsPB.loading
          : Scaffold(
              appBar: WidgetsPB().appBarPB("Contas", () {
                Get.defaultDialog(
                    title: "Criar Conta",
                    content: Column(
                      children: [
                        InputPB.field(
                            _name, "nome", Ionicons.folder_open_outline),
                        SizedBox(
                          height: 8,
                        ),
                        InputPB.numbers(_amount, "saldo inicial",
                            Icons.attach_money_rounded, null),
                        SizedBox(
                          height: 8,
                        ),
                        ButtonsPB().button("Criar", () {
                          c.createAccountBank({
                            "amount":
                                _amount.text == "" ? 0 : _amount.numberValue,
                            "name":
                                _name.text == "" ? "Nova Conta" : _name.text,
                            "id": int.parse(c.createId()),
                            "favorite": false
                          });
                          _amount.updateValue(0);
                          _name.clear();
                          Get.back();
                        })
                      ],
                    ));
              }),
              body: SafeArea(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Center(
                    child: Column(
                      children: user.aBank.map((x) {
                        AccountsBank accountsBank = AccountsBank.fromJson(x);
                        return Padding(
                          padding: EdgeInsets.all(10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onLongPress: () {
                              showCupertinoModalPopup(
                                context: Get.context,
                                builder: (_) => CupertinoTheme(
                                  data: CupertinoThemeData(
                                      primaryColor: Color(corPri)),
                                  child: CupertinoActionSheet(
                                    actions: [
                                      CupertinoActionSheetAction(
                                        onPressed: () {
                                          if (accountsBank.id ==
                                              c.aBankFav.value.id) {
                                            Get.defaultDialog(
                                                    title: "Aviso",
                                                    middleText:
                                                        "Não pode excluir a conta favorita, escolha outra!")
                                                .whenComplete(() => Get.back());
                                          } else {
                                            Get.defaultDialog(
                                              title:
                                                  "Deseja realmente excluir?",
                                              middleText:
                                                  "Todas suas transações serão excluídas",
                                              confirm: ButtonsPB().button(
                                                "Sim",
                                                () {
                                                  c.deleteAccountBank(
                                                      accountsBank);
                                                  Get.back();
                                                  Get.back();
                                                },
                                              ),
                                              cancel: SizedBox(
                                                child: ButtonsPB().buttonSec(
                                                  "Não",
                                                  () {
                                                    Get.back();
                                                    Get.back();
                                                  },
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        child: Text('🗑 Apagar'),
                                      ),
                                      CupertinoActionSheetAction(
                                        onPressed: () {
                                          final _formatterReal =
                                              MoneyMaskedTextController(
                                                  decimalSeparator: ',',
                                                  thousandSeparator: '.',
                                                  initialValue:
                                                      accountsBank.amount);
                                          Get.defaultDialog(
                                              title: "Editar Saldo",
                                              content: Column(
                                                children: [
                                                  InputPB.numbers(
                                                      _formatterReal,
                                                      "Valor",
                                                      Icons
                                                          .attach_money_rounded,
                                                      null),
                                                ],
                                              ),
                                              confirm: ButtonsPB()
                                                  .button("Salvar", () {
                                                c.updateAccountBank(
                                                    accountsBank,
                                                    _formatterReal.numberValue);
                                                Get.back();
                                              })).whenComplete(() {
                                            _formatterReal.updateValue(0);
                                            Get.back();
                                          });
                                        },
                                        child: Text('🖊 Editar Saldo'),
                                      ),
                                    ],
                                    cancelButton: CupertinoActionSheetAction(
                                      onPressed: () => Get.back(),
                                      child: Text('Fechar'),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              height: 80,
                              padding: EdgeInsets.all(10),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Color(corBackDark).withAlpha(150)),
                              child: Stack(
                                children: [
                                  Positioned(
                                      right: 0,
                                      child: accountsBank.favorite == true
                                          ? ButtonsPB()
                                              .chipDisable(null, "Favorito")
                                          : ButtonsPB().chip(() {
                                              c.changeFav(accountsBank);
                                            }, "Selecionar")),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        accountsBank.name,
                                        style: TextPB.display3,
                                      ),
                                      Text(
                                        "R\$ " +
                                            c.real.format(accountsBank.amount),
                                        style: TextPB.display5,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            );
    });
  }
}
