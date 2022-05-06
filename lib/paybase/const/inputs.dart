import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:layouts/paybase/const/text.dart';
import 'package:searchfield/searchfield.dart';

class InputPB extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool isPass;
  final bool isDisable;
  final Function func;
  final bool isNumber;
  final List<String> listSearch;
  final Function onChanged;

  InputPB(
    this.controller,
    this.hint,
    this.icon,
    this.isPass, {
    this.isDisable = false,
    this.func,
    this.isNumber = false,
    this.listSearch,
    this.onChanged,
  });

  factory InputPB.field(
      TextEditingController controller, String hint, IconData icon) {
    return InputPB(controller, hint, icon, false);
  }

  factory InputPB.search(TextEditingController controller, String hint,
      IconData icon, List<String> listSearch) {
    return InputPB(
      controller,
      hint,
      icon,
      false,
      listSearch: listSearch,
    );
  }

  factory InputPB.numbers(TextEditingController controller, String hint,
      IconData icon, Function onChanged) {
    return InputPB(
      controller,
      hint,
      icon,
      false,
      isNumber: true,
      onChanged: onChanged,
    );
  }

  factory InputPB.pass(
      TextEditingController controller, String hint, IconData icon) {
    return InputPB(controller, hint, icon, true);
  }

  factory InputPB.disable(TextEditingController controller, String hint,
      IconData icon, Function func) {
    return InputPB(
      controller,
      hint,
      icon,
      false,
      isDisable: true,
      func: func,
    );
  }

  @override
  Widget build(BuildContext context) {
    return listSearch == null
        ? TextFormField(
            style: TextPB.display5,
            keyboardType:
                isNumber == false ? TextInputType.text : TextInputType.number,
            inputFormatters: isNumber == false
                ? [FilteringTextInputFormatter.singleLineFormatter]
                : <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
            readOnly: isDisable,
            controller: controller,
            obscureText: isPass,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Entre com um valor';
              }
              return null;
            },
            onTap: isDisable == true ? func : null,
            onChanged: onChanged,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 15),
              hintText: hint,
              prefixIcon: Icon(
                icon,
                size: 20,
                color: Colors.grey.shade700,
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10.0),
              ),
              fillColor: Colors.transparent.withOpacity(0.12),
              filled: true,
            ),
          )
        : SearchField(
            controller: controller,
            suggestions: listSearch,
            searchInputDecoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 15),
              hintText: hint,
              prefixIcon: Icon(
                icon,
                size: 20,
                color: Colors.grey.shade700,
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10.0),
              ),
              fillColor: Colors.transparent.withOpacity(0.12),
              filled: true,
            ),
          );
  }
}
