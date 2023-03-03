

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spinner_dropdown/spinner.dart';

/// This is search text field class.
class SpinnerTextField extends StatefulWidget {
  final Spinner spinner;
  final Function(String) onTextChanged;

  const SpinnerTextField({required this.spinner, required this.onTextChanged, Key? key})
      : super(key: key);

  @override
  State<SpinnerTextField> createState() => _SpinnerTextFieldState();
}

class _SpinnerTextFieldState extends State<SpinnerTextField> {

  final TextEditingController _editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextFormField(
        controller: _editingController,
        cursorColor: Colors.black,
        onChanged: (value) {
          widget.onTextChanged(value);
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.black12,
          contentPadding: const EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 15),
          hintText: 'Search',
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          prefixIcon: const IconButton(
            icon: Icon(Icons.search),
            onPressed: null,
          ),
          suffixIcon: GestureDetector(
            onTap: onClearTap,
            child: const Icon(
              Icons.cancel,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  void onClearTap() {
    _editingController.clear();
    widget.onTextChanged("");
  }
}