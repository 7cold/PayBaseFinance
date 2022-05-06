import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:layouts/paybase/const/colors.dart';
import 'package:layouts/paybase/const/text.dart';

class ButtonsPB {
  CupertinoButton button(String text, Function func) => CupertinoButton(
        color: Color(corPri),
        borderRadius: BorderRadius.circular(15),
        child: Text(text),
        onPressed: func,
        padding: EdgeInsets.all(5),
      );

  CupertinoButton buttonSec(String text, Function func) => CupertinoButton(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(15),
        child: Text(text),
        onPressed: func,
      );

  Container googleButton() => Container(
        child: Material(
          borderRadius: BorderRadius.circular(15),
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            splashColor: Colors.transparent,
            focusColor: Colors.amber,
            highlightColor: Color(corPri).withAlpha(30),
            onTap: () {},
            child: Container(
              width: Get.context.width,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  width: 0.20,
                  color: Colors.grey.shade700,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 24,
                    child: Image.network(
                        'https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/2048px-Google_%22G%22_Logo.svg.png'),
                  ),
                  SizedBox(width: 15),
                  Text(
                    "Login com o Google",
                    style: TextPB.display4,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Container facebookButton() => Container(
        child: Material(
          borderRadius: BorderRadius.circular(15),
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(15),
            splashColor: Colors.transparent,
            focusColor: Colors.amber,
            highlightColor: Color(corPri).withAlpha(30),
            onTap: () {},
            child: Container(
              width: Get.context.width,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  width: 0.20,
                  color: Colors.grey.shade700,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 24,
                    child: Image.network(
                        'https://logodownload.org/wp-content/uploads/2014/09/facebook-logo-3-1.png'),
                  ),
                  SizedBox(width: 15),
                  Text(
                    "Login com o Facebook",
                    style: TextPB.display4,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Widget textButton(
    String label,
    Function func,
  ) =>
      Theme(
        data: ThemeData(
            textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              shadowColor: MaterialStateProperty.all(Colors.black),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              overlayColor:
                  MaterialStateProperty.all(Color(corPri).withOpacity(0.1)),
              splashFactory: InkRipple.splashFactory,
              foregroundColor: MaterialStateProperty.all(Color(corPri))),
        )),
        child: TextButton(
            onPressed: func,
            child: Text(
              label,
              style: TextPB.h5,
            )),
      );

  Widget iconButton1(Function func, String label, IconData icon) => Container(
        margin: EdgeInsets.all(10),
        height: 70,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: TextButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Color(corPri).withAlpha(40)),
                shadowColor: MaterialStateProperty.all(Colors.black),
                overlayColor:
                    MaterialStateProperty.all(Color(corPri).withOpacity(0.1)),
                splashFactory: InkRipple.splashFactory,
                foregroundColor: MaterialStateProperty.all(Color(corPri))),
            onPressed: func,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon),
                SizedBox(width: 10),
                Text(
                  label,
                  style: TextPB.h5.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      );

  Widget chip(Function func, String label) => Container(
        margin: EdgeInsets.all(10),
        height: 32,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: TextButton(
            style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(Color(corPri)),
                shadowColor: MaterialStateProperty.all(Colors.black),
                overlayColor:
                    MaterialStateProperty.all(Colors.white.withOpacity(0.3)),
                splashFactory: InkRipple.splashFactory,
                foregroundColor: MaterialStateProperty.all(Color(corPri))),
            onPressed: func,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextPB.display6.copyWith(color: Colors.black87),
                ),
              ],
            ),
          ),
        ),
      );

  Widget chipDisable(Function func, String label) => Container(
        margin: EdgeInsets.all(10),
        height: 32,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: TextButton(
            style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor:
                    MaterialStateProperty.all(Colors.grey.shade200),
                shadowColor: MaterialStateProperty.all(Colors.black),
                overlayColor:
                    MaterialStateProperty.all(Color(corPri).withOpacity(0.3)),
                splashFactory: InkRipple.splashFactory,
                foregroundColor: MaterialStateProperty.all(Color(corPri))),
            onPressed: func,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextPB.display6.copyWith(color: Colors.black87),
                ),
              ],
            ),
          ),
        ),
      );

  Widget radioSelect(Function func, String label, String value) => Container(
        margin: EdgeInsets.all(10),
        height: 32,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: TextButton(
            style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all(
                    value == label ? Colors.grey.shade200 : Color(corPri)),
                shadowColor: MaterialStateProperty.all(Colors.black),
                overlayColor:
                    MaterialStateProperty.all(Color(corPri).withOpacity(0.3)),
                splashFactory: InkRipple.splashFactory,
                foregroundColor:
                    MaterialStateProperty.all(Color(corSec).withAlpha(100))),
            onPressed: value == label ? null : func,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextPB.display6.copyWith(color: Colors.black87),
                ),
              ],
            ),
          ),
        ),
      );
}
