import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:material_tag_editor/tag_editor.dart';
import 'package:socialapp/layout/socialapp/cubit/cubit.dart';
import 'package:socialapp/layout/socialapp/cubit/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class Edit_Material_tag_editor extends StatefulWidget {
  Edit_Material_tag_editor({Key? key, this.idPost}) : super(key: key);

  final String? idPost;

  @override
  _Edit_Material_tag_editorState createState() => _Edit_Material_tag_editorState();
}

class _Edit_Material_tag_editorState extends State<Edit_Material_tag_editor> {
  List<String>? _values = [];
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();

  _onDelete(index) {
    setState(() {
      SocialCubit.get(context).valueTags!.removeAt(index);
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
        
        // _values = SocialCubit.get(context).valueTags;
        // print('value luc dau la: ' + _values.toString());
        return 
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: <Widget>[
                TagEditor(
                  length: SocialCubit.get(context).valueTags.length,
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
                      SocialCubit.get(context).valueTags!.add(outstandingValue);
                      // SocialCubit.get(context).valueTags = _values!;
                    });
                    }
                    print(SocialCubit.get(context).valueTags);
                  },
                  inputDecoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '#Tag...',
                  ),
                  onTagChanged: (newValue) {
                    setState(() {
                      SocialCubit.get(context).valueTags!.add(newValue);
                    });
                    print(SocialCubit.get(context).valueTags);
                  },
                  tagBuilder: (context, index) => _Chip(
                    index: index,
                    label: SocialCubit.get(context).valueTags![index],
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