import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:material_tag_editor/tag_editor.dart';
import 'package:socialapp/layout/socialapp/cubit/cubit.dart';
import 'package:socialapp/layout/socialapp/cubit/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class Material_tag_editor_Album extends StatefulWidget {
  Material_tag_editor_Album({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _Material_tag_editor_AlbumState createState() => _Material_tag_editor_AlbumState();
}

class _Material_tag_editor_AlbumState extends State<Material_tag_editor_Album> {
  List<String> _values = [];
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();

  _onDelete(index) {
    setState(() {
      _values.removeAt(index);
    });
  }

  /// This is just an example for using `TextEditingController` to manipulate
  /// the the `TextField` just like a normal `TextField`.
  // _onPressedModifyTextField() {
  //   final text = 'Test';
  //   _textEditingController.text = text;
  //   _textEditingController.value = _textEditingController.value.copyWith(
  //     text: text,
  //     selection: TextSelection(
  //       baseOffset: text.length,
  //       extentOffset: text.length,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context ,state){},
      builder: (context,state){
        return 
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Expanded(
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  TagEditor(
                    length: _values.length,
                    controller: _textEditingController,
                    focusNode: _focusNode,
                    delimiters: [',', ' '],
                    hasAddButton: true,
                    resetTextOnSubmitted: true,
                    // This is set to grey just to illustrate the `textStyle` prop
                    textStyle: const TextStyle(color: Colors.grey),
                    onSubmitted: (outstandingValue) {
                      if(outstandingValue != ''){
                            setState(() {
                        _values.add(outstandingValue);
                        SocialCubit.get(context).valueTags = _values;
                      });
                      }
                      print('valueTags 1');
                      print(SocialCubit.get(context).valueTags);
                    },
                    inputDecoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '#Tag...',
                    ),
                    onTagChanged: (newValue) {
                      setState(() {
                        _values.add(newValue);
                        SocialCubit.get(context).valueTags = _values;
                      });
                      print('valueTags 2');
                       print(SocialCubit.get(context).valueTags);
                    },
                    tagBuilder: (context, index) => _Chip(
                      index: index,
                      label: _values[index],
                      onDeleted: _onDelete,
                    ),
                    // InputFormatters example, this disallow \ and /
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'[/\\]'))
                    ],
                  ),
                  const Divider(),
                  // This is just a button to illustrate how to use
                  // TextEditingController to set the value
                  // or do whatever you want with it
                  // ElevatedButton(
                  //   onPressed: _onPressedModifyTextField,
                  //   child: const Text('Use Controlelr to Set Value'),
                  // ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.onDeleted,
    required this.index,
  });

  final String label;
  final ValueChanged<int> onDeleted;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Chip(
      labelPadding: const EdgeInsets.only(left: 8.0),
      label: Text(label),
      deleteIcon: const Icon(
        Icons.close,
        size: 18,
      ),
      onDeleted: () {
        onDeleted(index);
      },
    );
  }
}