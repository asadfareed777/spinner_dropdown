

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:spinner_dropdown/spinner.dart';
import 'package:spinner_dropdown/spinner_list_item.dart';
import 'package:spinner_dropdown/spinner_text_field.dart';

class SpinnerBottomSheet extends StatefulWidget {

  final Spinner spinner;

  const SpinnerBottomSheet({required this.spinner, Key? key}) : super(key: key);

  @override
  State<SpinnerBottomSheet> createState() => _SpinnerBottomSheetState();
}

class _SpinnerBottomSheetState extends State<SpinnerBottomSheet> {

  List<SpinnerListItem> mainList = [];

  @override
  void initState() {
    super.initState();
    mainList = widget.spinner.data;
    _setSearchWidgetListener();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.13,
      maxChildSize: 0.9,
      expand: false,
      builder: (BuildContext context, ScrollController scrollController) {
        return Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Bottom sheet title text
                  Expanded(child: widget.spinner.bottomSheetTitle ?? Container()),

                  /// Done button
                  Visibility(
                    visible: widget.spinner.enableMultipleSelection,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Material(
                        child: ElevatedButton(
                          onPressed: () {
                            List<SpinnerListItem> selectedList =
                            widget.spinner.data.where((element) => element.isSelected == true).toList();
                            List<dynamic> selectedNameList = [];

                            for (var element in selectedList) {
                              selectedNameList.add(element);
                            }

                            widget.spinner.selectedItems?.call(selectedNameList);
                            _onUnFocusKeyboardAndPop();
                          },
                          child: widget.spinner.submitButtonChild ?? const Text('Done'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// A [TextField] that displays a list of suggestions as the user types with clear button.
            Visibility(
              visible: widget.spinner.isSearchVisible,
              child: widget.spinner.searchWidget ??
                  SpinnerTextField(
                    spinner: widget.spinner,
                    onTextChanged: _buildSearchList,
                  ),
            ),

            /// Listview (list of data with check box for multiple selection & on tile tap single selection)
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: mainList.length,
                itemBuilder: (context, index) {
                  bool isSelected = mainList[index].isSelected ?? false;
                  return InkWell(
                    onTap: widget.spinner.enableMultipleSelection
                        ? null
                        : () {
                      widget.spinner.selectedItems?.call([mainList[index]]);
                      _onUnFocusKeyboardAndPop();
                    },
                    child: Container(
                      color: widget.spinner.dropDownBackgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: ListTile(
                          title: widget.spinner.listBuilder?.call(index) ??
                              Text(
                                mainList[index].data.toString(),
                              ),
                          trailing: widget.spinner.enableMultipleSelection
                              ? GestureDetector(
                            onTap: () {
                              setState(() {
                                mainList[index].isSelected = !isSelected;
                              });
                            },
                            child: isSelected
                                ? const Icon(Icons.check_box,color: Colors.blue,)
                                : const Icon(Icons.check_box_outline_blank,color: Colors.blue,),
                          )
                              : const SizedBox(
                            height: 0.0,
                            width: 0.0,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  /// This helps when search enabled & show the filtered data in list.
  _buildSearchList(String userSearchTerm) {
    final results = widget.spinner.data
        .where((element) => element.data.toString().toLowerCase().contains(userSearchTerm.toLowerCase()))
        .toList();
    if (userSearchTerm.isEmpty) {
      mainList = widget.spinner.data;
    } else {
      mainList = results;
    }
    setState(() {});
  }

  /// This helps to UnFocus the keyboard & pop from the bottom sheet.
  _onUnFocusKeyboardAndPop() {
    FocusScope.of(context).unfocus();
    Navigator.of(context).pop();
  }

  void _setSearchWidgetListener() {
    TextFormField? _searchField = (widget.spinner.searchWidget as TextFormField?);
    _searchField?.controller?.addListener(() {
      _buildSearchList(_searchField.controller?.text ?? '');
    });
  }
}