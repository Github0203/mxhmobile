import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:material_tag_editor/tag_editor.dart';
import 'package:socialapp/layout/socialapp/cubit/cubit.dart';
import 'package:socialapp/layout/socialapp/cubit/state.dart';
import 'package:socialapp/modules/new_post/edit_post_sub_album_when_create.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class edittagsSubpostwhencreateAlbum extends StatefulWidget {
  edittagsSubpostwhencreateAlbum({Key? key}) : super(key: key);

 

  @override
  _edittagsSubpostwhencreateAlbumState createState() => _edittagsSubpostwhencreateAlbumState();
}

class _edittagsSubpostwhencreateAlbumState extends State<edittagsSubpostwhencreateAlbum> {
  List _values = [];
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
    if(SocialCubit.get(context).valueTagsSubwhenCreateTemp == null){
      SocialCubit.get(context).valueTagsSubwhenCreateTemp = [];
    }

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
                    length: SocialCubit.get(context).valueTagsSubwhenCreateTemp.length,
                    controller: _textEditingController,
                    focusNode: _focusNode,
                    delimiters: [',', ' '],
                    hasAddButton: true,
                    resetTextOnSubmitted: false,
                    // This is set to grey just to illustrate the `textStyle` prop
                    textStyle: const TextStyle(color: Colors.grey),
                    onSubmitted: (outstandingValue) {
                      if(outstandingValue != ''){

                            setState(() {
                        SocialCubit.get(context).valueTagsSubwhenCreateTemp.add(outstandingValue);
                        
                      });
                      // SocialCubit.get(context).valueTagsSubwhenCreateTemp.add(outstandingValue);
                      // SocialCubit.get(context).valueTagsSubwhenCreateTemp = _values;
                      }
                      print(SocialCubit.get(context).valueTags);
                      print('valueTagsSubwhenCreateTemp1 la');
                      print(SocialCubit.get(context).valueTagsSubwhenCreateTemp);
                      print('valueTagsSubwhenCreate1 la');
                      print(SocialCubit.get(context).valueTagsSubwhenCreate);
                    },
                    inputDecoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '#Tag...',
                    ),
                    onTagChanged: (newValue) {
                      setState(() {
                        SocialCubit.get(context).valueTagsSubwhenCreateTemp.add(newValue);
                       // = _values;
                      });
                      //  SocialCubit.get(context).valueTagsSubwhenCreateTemp = _values;
                      print('valueTagsSubwhenCreateTemp2 la');
                      print(SocialCubit.get(context).valueTagsSubwhenCreateTemp);
                      print('valueTagsSubwhenCreate2 la');
                      print(SocialCubit.get(context).valueTagsSubwhenCreate);
                      for(int i = 0; i< SocialCubit.get(context).editsubpostTempWhenCreatePost!.length; i++){
                        print('tags cua item la: ' + SocialCubit.get(context).editsubpostTempWhenCreatePost![i].tags.toString());
                      }
                    },
                    tagBuilder: (context, index) => _Chip(
                      index: index,
                      label: SocialCubit.get(context).valueTagsSubwhenCreateTemp[index],
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