import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nine_grid_view/nine_grid_view.dart';
import 'package:socialapp/layout/socialapp/cubit/cubit.dart';
import 'package:socialapp/layout/socialapp/cubit/state.dart';
import 'package:socialapp/layout/socialapp/sociallayout.dart';
import 'package:socialapp/models/social_model/post_model.dart';
import 'package:socialapp/models/social_model/post_model_sub.dart';
import 'package:socialapp/models/social_model/social_user_model.dart';
import 'package:socialapp/modules/albums/albulmModouls/drag_sort_page.dart';
import 'package:socialapp/modules/albums/albulmModouls/models.dart';
import 'package:socialapp/modules/albums/albulmModouls/utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:socialapp/modules/settings/photos_detail_page.dart.dart';
import 'package:socialapp/shared/components/components.dart';
import 'package:socialapp/layout/gallery/gallery_view.dart';
import 'package:socialapp/shared/network/UrlTypeHelper';



class Grid_Group extends StatefulWidget {
   
   Grid_Group({ Key? key}) : super(key: key);

  @override
  _Grid_GroupState createState() => _Grid_GroupState();
}

class _Grid_GroupState extends State<Grid_Group> 
 
  with TickerProviderStateMixin {


  NineGridType _gridType = NineGridType.weChatGp;

  // List<ImageBean> imageList = [];

  // @override
  // void initState() {
  //   super.initState();
  //   // imageList = Utils.getImageData();
  //   super.dispose();

  // }
  



  Widget _buildGroup(BuildContext context, indexget,
          PostModel model,
          List<PostModelSub>? subpost) {
    Decoration decoration = BoxDecoration(
      color: Color(0XFFE5E5E5),
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.all(Radius.circular(4)),
    );
    int total = 1;
    switch (_gridType) {
      case NineGridType.weChatGp:
        total = 4;
        break;
      case NineGridType.normal:
        // TODO: Handle this case.
        break;
      case NineGridType.weChat:
        // TODO: Handle this case.
        break;
      case NineGridType.weiBo:
        // TODO: Handle this case.
        break;
      case NineGridType.dingTalkGp:
        // TODO: Handle this case.
        break;
      case NineGridType.qqGp:
        // TODO: Handle this case.
        break;
    }
    List<Widget> children = [];
    for (int i = 0; i < SocialCubit.get(context).posts3.length; i++) {
      children.add(NineGridView(
        width: (MediaQuery.of(context).size.width - 60) / 2,
        height: (MediaQuery.of(context).size.width - 60) / 2,
        padding: EdgeInsets.all(2),
        margin: EdgeInsets.all(5),
        alignment: Alignment.center,
        space: 2,
        arcAngle: 60,
        type: _gridType,
        decoration: _gridType == NineGridType.dingTalkGp ? null : decoration,
        itemCount: 1,//'$subpost'.length, //1, //SocialCubit.get(context).posts3.length, //i % total + 1,
        itemBuilder: (BuildContext context, int index) {
          ImageBean bean =  SocialCubit.get(context).imageList[indexget];
          return Utils.getWidget(bean.middlePath!);
        },
      ));
    }
    return Wrap(
      alignment: WrapAlignment.center,
      children: children,
    );
  }

    // floatingActionButton: FloatingActionButton(
    //     onPressed: () {
    //       Utils.pushPage(context, DragSortPage());
    //     },
    //     child: Icon(Icons.camera_alt),
    //   ),


  PostModelSub? getlistpostmodelsub;
  @override
  Widget build(BuildContext context) {
    return
  
          Builder(
            builder: (context) {
              return BlocConsumer<SocialCubit, SocialStates>(
                  listener: (context, state) {
                    // if(state is LoadAlbumLevel1SuccessState){
                    //   showToast(text: 'Load Abum thành công', state: ToastStates.SUCCESS);
                    // }
                  },
          builder: (context, state) {
            SocialUserModel? userModel =
                SocialCubit.get(context).getsocialUserModelFriend;
            double setWidth = MediaQuery.of(context).size.width;
            double setheight = MediaQuery.of(context).size.height;

            return ConditionalBuilder(
              condition: 
              SocialCubit.get(context).posts3.isNotEmpty &&
                  SocialCubit.get(context).getsocialUserModelFriend != null,
              builder: (context) =>  
              
              ListView.builder(
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 1,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) =>
                Column(
                  children: [
                    Container(
                      height: setheight*0.7,
                      width: setWidth-20,
                                    child: Wrap(
                                      direction: Axis.horizontal,
                                      children: 
                                      List.generate(
                                      
                                        SocialCubit.get(context).solist,
                                        (index1) => buildPostImage(userModel!, SocialCubit.get(context).posts3[index1],context, index1, SocialCubit.get(context).posts4[index]),
                                      ),
                                    ),
                                  ),
                  SizedBox(height: 10,),
                  ],
                ),
                              ),
                
                  fallback: (context) => Column(
                    children: [
                      Center(child: CircularProgressIndicator()),
                    ],
                  ),
              );
            }
          );
  }
          );
}

 Widget buildPostImage(SocialUserModel getUserModer, PostModel model, context, index, PostModelSub subpost) => Container(
  margin: EdgeInsets.all(8),
   child: 

     StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('albumImages')
                  .doc('${model.postId}')
                  .collection('albumImages')
                  .snapshots(),
              builder:
                  (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return const Text('Loading...');
                final int surveysCount = snapshot.data!.docs.length;
                List<DocumentSnapshot> documents = snapshot.data!.docs;
                print('00000000000000000000000');
                List<String> listpostIdSubID = [];
                documents.forEach((doc) {
                 if( getUserModer.uId == doc['uId']){
                    listpostIdSubID.add(doc['postIdSub'].toString(),);
                 }
                });
                
                List<String> urls = [];
                documents.forEach((doc) {
                   if( getUserModer.uId == doc['uId']){
                    urls.add(doc['postImage'].toString(),);
                }
              

                
                    
                });
 
                // SocialCubit.get(context).posts4.add(PostModelSub.fromJson(snapshot.data));
                

 
                return 
                
                GestureDetector(
                     onTap: () => {
                        //  SocialCubit.get(context).getDetailAlbumImages('${model.postId}'),
                        getlistpostmodelsub = null,
                        getlistpostmodelsub = subpost,
                         navigateTo(context, Photos_Detail_Page( model, subpost, '${model.nameAlbum}', '${model.postId}', index.toString())),
                      } ,
                  child: Column(
                    children: [
                      Container(
                         width: MediaQuery.of(context).size.width * 0.4,
                         padding: EdgeInsets.all(8),
                         color: Color.fromARGB(64, 202, 202, 197),
                      height: 170,
                       
                        child: 
                        PhotoGrid(
                                imageUrls: urls,
                          //                         onImageClicked: (i) => 
                          //                                     // onTap:() {
                          //           Navigator.push(
                          // context, CupertinoPageRoute(
                          //   builder: (context) => feedDetail('${userModel.name}', '${model.postId}', i.toString(),
                          //                                    listpostIdSubID.toString() , 
                          //                                     ))),
                                  // },
                                onExpandClicked: () => print('Expand Image was clicked'),
                                maxImages: 4,
                              ),
                      ),
                    Text('${model.nameAlbum}'),
                    ],
                  ),
                );
              }),




 );


}

