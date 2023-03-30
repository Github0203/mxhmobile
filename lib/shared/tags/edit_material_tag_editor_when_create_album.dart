import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:material_tag_editor/tag_editor.dart';
import 'package:socialapp/layout/socialapp/cubit/cubit.dart';
import 'package:socialapp/layout/socialapp/cubit/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class Edit_Material_tag_editor_when_create_Album extends StatefulWidget {
  Edit_Material_tag_editor_when_create_Album({Key? key, this.gettags}) : super(key: key);

   List? gettags = [];

  @override
  _Edit_Material_tag_editor_when_create_AlbumState createState() => _Edit_Material_tag_editor_when_create_AlbumState();
}

class _Edit_Material_tag_editor_when_create_AlbumState extends State<Edit_Material_tag_editor_when_create_Album> {
  List<String>? _values = [];
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();

  _onDelete(index) {
    setState(() {
      widget.gettags!.removeAt(index);
    });
     print('valueTagsSubwhenCreateTemp la');
                    print(SocialCubit.get(context).valueTagsSubwhenCreateTemp);
                    print('valueTagsSubwhenCreate la');
                    print(SocialCubit.get(context).valueTagsSubwhenCreate);
  }

  // This is just an example for using `TextEditingController` to manipulate
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
        
        // _values = SocialCubit.get(context).valueTagsSubwhenCreate;
        // print('value luc dau la: ' + _values.toString());
        widget.gettags == null ? widget.gettags = [] : widget.gettags = widget.gettags;
        return 
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: <Widget>[
                TagEditor(
                  length: widget.gettags!.length,
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
                            widget.gettags!.add(outstandingValue);
                      // SocialCubit.get(context).valueTagsSubwhenCreateTemp = widget.gettags!;
                      // SocialCubit.get(context).valueTagsSubwhenCreate = _values!;
                    });
                    }
                    // print('valueTagsSubwhenCreateTemp la');
                    // print(SocialCubit.get(context).valueTagsSubwhenCreateTemp);
                    // print('valueTagsSubwhenCreate la');
                    // print(SocialCubit.get(context).valueTagsSubwhenCreate);
                  },
                  inputDecoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '#Tag...',
                  ),
                  onTagChanged: (newValue) {
                    setState(() {
                      widget.gettags!.add(newValue);
                      // SocialCubit.get(context).valueTagsSubwhenCreateTemp = widget.gettags!;
                    });
                    print(SocialCubit.get(context).valueTagsSubwhenCreateTemp);
                     print('valueTagsSubwhenCreateTemp la');
                    print(SocialCubit.get(context).valueTagsSubwhenCreateTemp);
                    print('valueTagsSubwhenCreate la');
                    print(SocialCubit.get(context).valueTagsSubwhenCreate);
                  },
                  tagBuilder: (context, index) => _Chip(
                    index: index,
                    label: widget.gettags![index],
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