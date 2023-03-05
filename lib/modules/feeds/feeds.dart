import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:socialapp/models/social_model/post_model_sub.dart';

import '../../../layout/socialapp/cubit/cubit.dart';
import '../../../layout/socialapp/cubit/state.dart';
import '../../../layout/socialapp/sociallayout.dart';
import '../../../models/social_model/post_model.dart';
import '../../../models/social_model/social_user_model.dart';
import '../../../shared/components/components.dart';
import '../../../shared/styles/iconbroken.dart';
import '../CommentsScreen.dart';
import '../new_post/new_post.dart';
import 'package:multi_image_layout/multi_image_layout.dart';
import 'dart:io';
import 'package:socialapp/modules/addMedias/addMedias.dart';
import 'package:socialapp/layout/video/video_player.dart';


class Feeds extends StatelessWidget {

  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getPosts();
        SocialCubit.get(context).getMyData();
    

        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {
                if (state is SocialCreatePostSuccessState){
    showToast(text: "Đã thêm bài viết thành công", state: ToastStates.SUCCESS);
                }
                if (state is SocialCreatePostErrorState){
    showToast(text: "Thêm bài viết thất bại", state: ToastStates.ERROR);
                }
          },
          builder: (context, state) {
            SocialUserModel? userModel = SocialCubit.get(context).socialUserModel;
            double setWidth = MediaQuery.of(context).size.width;
            double setheight = MediaQuery.of(context).size.height;

            return ConditionalBuilder(
              condition: SocialCubit.get(context).posts1.isNotEmpty &&
                  SocialCubit.get(context).socialUserModel != null,
              builder: (context) => SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Card(
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      elevation: 5,
                      margin: EdgeInsets.all(8),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  navigateTo(context,SocialLayout(4));
                                },
                                child: CircleAvatar(
                                    radius: 22,
                                    backgroundImage:
                                    NetworkImage('${userModel!.image}')),
                              ),

                              TextButton(
                                onPressed: () {
                                  navigateTo(context, NewPostScreen());
                                },
                                child: SizedBox(
                                  width: 100,
                                  child: Text("What is in your mind ...",
                                    style: const TextStyle(color: Colors.grey),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Row(
                            children: [

                              Expanded(
                                child: TextButton(
                                    onPressed: () {

                                       navigateTo(context, NewPostScreen());

                                    },
                                    child: Row(
                                      children: const [
                                        Icon(IconBroken.Image),
                                        SizedBox(width: 5,),
                                        Text("image/video",
                                            ),
                                      ],
                                    )),
                              ),
                             Spacer(),

                              Expanded(
                                child: TextButton(
                                    onPressed: () {},
                                    child: Row(
                                      children: const [
                                        Icon(
                                          Icons.tag,
                                          color: Colors.red,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "#TAGS",
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    )),
                              ),



                            ],
                          )
                        ],
                      ),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => buildPost(SocialCubit.get(context).posts1[index],userModel,context, index,scaffoldKey, SocialCubit.get(context).posts1[index].subPost),
                      separatorBuilder: (context, index) => SizedBox(
                        height: 8,
                      ),
                      itemCount: (SocialCubit.get(context).posts1.length),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              fallback: (context) => Center(child:CircularProgressIndicator()),
            );
          },
        );
      }
    );
  }

  Widget buildPost(PostModel model, SocialUserModel userModel ,context, index,GlobalKey<ScaffoldState> scaffoldKey, List<PostModelSub>? lengthsubpost) => Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 5,
        margin: EdgeInsets.zero,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 13),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {

                    },
                    child: CircleAvatar(
                        radius: 22,
                        backgroundImage: NetworkImage('${model.image}')),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                          onTap: () {

                          },
                          child: Text(
                            '${model.name}',
                          )),
                      Text(
                        '${model.date} at ${model.time}',
                        style: TextStyle(color: Colors.grey),
                      ),

                    ],
                  ),
                  Spacer(),

                  PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(

                        child: TextButton(onPressed: () {  SocialCubit.get(context).deletePost(model.postId); },
                          child: Text('Delete post'),
                      ),
                      ),
                      PopupMenuItem(

                        child: TextButton(onPressed: () { 
                          SocialCubit.get(context).getPosts;
                         },
                          child: Text('Edit post'),
                      ),
                      ),
                    ],
                    child: Row(
                      children: const [

                        Text(
                        "Tùy chọn",
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              myDivider(),
              model.text != null
                  ? Text(
                      '${model.text}',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    )
                  : Text('${model.text}', style: TextStyle(fontSize: 20)),
              // if (model.subPost.postImage.toString() != null)
                // Padding(
                //     padding: const EdgeInsetsDirectional.only(top: 10),
                //     child: Image(
                //       image: NetworkImage('${model.postImage}'),
                //     )),
                // if (model.subPost != null)
                Padding(
                    padding: const EdgeInsetsDirectional.only(top: 10),
                //     child: MultiImageViewer(
                // images: [
                  
                // ],),
                child: 
                
                ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => SizedBox(
                        height: 8,
                      ),
                      itemCount: (SocialCubit.get(context).posts2.length),
                      // itemCount: 1,
                      itemBuilder: (context, index) =>
                      Image.network(
                                            SocialCubit.get(context).posts2[index].postImage.toString(),
                                          width: MediaQuery.of(context).size.width-26,
                                          height: 100,
                                          fit: BoxFit.fill,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              width: 30,
                                              height: 30,
                                              child: CircularProgressIndicator());
                                          },
                      
                ),
                ),

//  lengthsubpost!.length == 1?
//                                    Container(
//                                       child: 
//                                       SocialCubit.get(context).posts2[0].postImage.toString().split('.').last.substring(0,3) != 'mp4'?
//                                       Image.network(
//                                             SocialCubit.get(context).posts2[0].postImage.toString(),
//                                           width: MediaQuery.of(context).size.width-26,
//                                           height: 100,
//                                           fit: BoxFit.fill,
//                                           errorBuilder: (context, error, stackTrace) {
//                                             return CircularProgressIndicator();
//                                           },
//                                         ):
//                                         Stack(
//                                         children: <Widget>[
//                                          Container(
//                                           width: MediaQuery.of(context).size.width-26,
//                                           height: 100,
//                                           child: VideoPlayerLayout(SocialCubit.get(context).posts2[0].postImage!.toString())),
//                                                Positioned.fill(
//                                                 child: Padding(
//                                                   padding: const EdgeInsets.all(8.0),
//                                                   child: Align(
//                                                     alignment: Alignment.center,
//                                                     child: Container(
//                                                       padding: EdgeInsets.all(3.0),
//                                                       decoration: BoxDecoration(
//                                                         borderRadius: BorderRadius.circular(30),
//                                                         color: Color.fromARGB(66, 255, 255, 255),
//                                                         boxShadow: [
//                                                           BoxShadow(color: Color.fromARGB(157, 255, 255, 255), spreadRadius: 3),
//                                                         ],
//                                                       ),
//                                                       child: Icon(Icons.play_arrow_outlined, size:20)     ,
//                                                     )           
//                                                   ),
//                                                 ),
//                                               ),
//                                         ],
//                                        )
                                        
//                                     )
//                                       // (SocialCubit.get(context)
//                                        //          .paths![index].path!.split('.').last == 'mp4')
//                           :
//                       lengthsubpost!.length == 2?
//                       Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Expanded(
//                               child:  Padding(
//                                 padding: const EdgeInsetsDirectional.only(top: 10),
//                                 child:  Container(
//                                       child: 
//                                       SocialCubit.get(context).posts2[0].postImage.toString().split('.').last.substring(0,3) != 'mp4'?
//                                       Image.network(
//                                             SocialCubit.get(context).posts2[0].postImage.toString(),
//                                           width: MediaQuery.of(context).size.width-26,
//                                           height: 100,
//                                           fit: BoxFit.fill,
//                                           errorBuilder: (context, error, stackTrace) {
//                                             return Container(
//                                               height: 30,
//                                               width: 30,
//                                               child: CircularProgressIndicator());
//                                           },
//                                         ):
//                                         Stack(
//                                         children: <Widget>[
//                                          Container(
//                                           width: MediaQuery.of(context).size.width-26,
//                                           height: 100,
//                                           child: VideoPlayerLayout(SocialCubit.get(context).posts2[0].postImage!.toString())),
//                                                Positioned.fill(
//                                                 child: Padding(
//                                                   padding: const EdgeInsets.all(8.0),
//                                                   child: Align(
//                                                     alignment: Alignment.center,
//                                                     child: Container(
//                                                       padding: EdgeInsets.all(3.0),
//                                                       decoration: BoxDecoration(
//                                                         borderRadius: BorderRadius.circular(30),
//                                                         color: Color.fromARGB(66, 255, 255, 255),
//                                                         boxShadow: [
//                                                           BoxShadow(color: Color.fromARGB(157, 255, 255, 255), spreadRadius: 3),
//                                                         ],
//                                                       ),
//                                                       child: Icon(Icons.play_arrow_outlined, size:20)     ,
//                                                     )           
//                                                   ),
//                                                 ),
//                                               ),
//                                         ],
//                                        )
                                        
//                                     )
//                                   )
//                               ),
//                             VerticalDivider(width: 1.0),
//                             Expanded(
//                               child:  Padding(
//                                 padding: const EdgeInsetsDirectional.only(top: 10),
//                                 child:  Container(
//                                       child: 
//                                       SocialCubit.get(context).posts2[1].postImage.toString().split('.').last.substring(0,3) != 'mp4'?
//                                       Image.network(
//                                             SocialCubit.get(context).posts2[1].postImage.toString(),
//                                           width: MediaQuery.of(context).size.width-26,
//                                           height: 100,
//                                           fit: BoxFit.fill,
//                                           errorBuilder: (context, error, stackTrace) {
//                                             return CircularProgressIndicator();
//                                           },
//                                         ):
//                                         Stack(
//                                         children: <Widget>[
//                                          Container(
//                                           width: MediaQuery.of(context).size.width-26,
//                                           height: 100,
//                                           child: VideoPlayerLayout(SocialCubit.get(context).posts2[1].postImage!.toString())),
//                                                Positioned.fill(
//                                                 child: Padding(
//                                                   padding: const EdgeInsets.all(8.0),
//                                                   child: Align(
//                                                     alignment: Alignment.center,
//                                                     child: Container(
//                                                       padding: EdgeInsets.all(3.0),
//                                                       decoration: BoxDecoration(
//                                                         borderRadius: BorderRadius.circular(30),
//                                                         color: Color.fromARGB(66, 255, 255, 255),
//                                                         boxShadow: [
//                                                           BoxShadow(color: Color.fromARGB(157, 255, 255, 255), spreadRadius: 3),
//                                                         ],
//                                                       ),
//                                                       child: Icon(Icons.play_arrow_outlined, size:20)     ,
//                                                     )           
//                                                   ),
//                                                 ),
//                                               ),
//                                         ],
//                                        )
                                        
//                                     )
//                                   )
//                               ),
//                           ],
//                         )
//                         :
//                         lengthsubpost!.length == 3?
//                         Column(
//                           children: <Widget>[
//                             Row(children: [
//                                Container(
//                                       child: 
//                                       SocialCubit.get(context).posts2[0].postImage.toString().split('.').last.substring(0,3) != 'mp4'?
//                                       Image.network(
//                                             SocialCubit.get(context).posts2[0].postImage.toString(),
//                                           width: MediaQuery.of(context).size.width-26,
//                                           height: 100,
//                                           fit: BoxFit.fill,
//                                           errorBuilder: (context, error, stackTrace) {
//                                             return CircularProgressIndicator();
//                                           },
//                                         ):
//                                         Stack(
//                                         children: <Widget>[
//                                          Container(
//                                           width: MediaQuery.of(context).size.width-26,
//                                           height: 100,
//                                           child: VideoPlayerLayout(SocialCubit.get(context).posts2[0].postImage!.toString())),
//                                                Positioned.fill(
//                                                 child: Padding(
//                                                   padding: const EdgeInsets.all(8.0),
//                                                   child: Align(
//                                                     alignment: Alignment.center,
//                                                     child: Container(
//                                                       padding: EdgeInsets.all(3.0),
//                                                       decoration: BoxDecoration(
//                                                         borderRadius: BorderRadius.circular(30),
//                                                         color: Color.fromARGB(66, 255, 255, 255),
//                                                         boxShadow: [
//                                                           BoxShadow(color: Color.fromARGB(157, 255, 255, 255), spreadRadius: 3),
//                                                         ],
//                                                       ),
//                                                       child: Icon(Icons.play_arrow_outlined, size:20)     ,
//                                                     )           
//                                                   ),
//                                                 ),
//                                               ),
//                                         ],
//                                        )
                                        
//                                     )
                                  
//                             ],),
//                             Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Expanded(
//                               child:  Padding(
//                                 padding: const EdgeInsetsDirectional.only(top: 10),
//                                 child:  Container(
//                                       child: 
//                                       SocialCubit.get(context).posts2[1].postImage.toString().split('.').last.substring(0,3) != 'mp4'?
//                                       Image.network(
//                                             SocialCubit.get(context).posts2[1].postImage.toString(),
//                                           width: MediaQuery.of(context).size.width-26,
//                                           height: 100,
//                                           fit: BoxFit.fill,
//                                           errorBuilder: (context, error, stackTrace) {
//                                             return CircularProgressIndicator();
//                                           },
//                                         ):
//                                         Stack(
//                                         children: <Widget>[
//                                          Container(
//                                           width: MediaQuery.of(context).size.width-26,
//                                           height: 100,
//                                           child: VideoPlayerLayout(SocialCubit.get(context).posts2[1].postImage!.toString())),
//                                                Positioned.fill(
//                                                 child: Padding(
//                                                   padding: const EdgeInsets.all(8.0),
//                                                   child: Align(
//                                                     alignment: Alignment.center,
//                                                     child: Container(
//                                                       padding: EdgeInsets.all(3.0),
//                                                       decoration: BoxDecoration(
//                                                         borderRadius: BorderRadius.circular(30),
//                                                         color: Color.fromARGB(66, 255, 255, 255),
//                                                         boxShadow: [
//                                                           BoxShadow(color: Color.fromARGB(157, 255, 255, 255), spreadRadius: 3),
//                                                         ],
//                                                       ),
//                                                       child: Icon(Icons.play_arrow_outlined, size:20)     ,
//                                                     )           
//                                                   ),
//                                                 ),
//                                               ),
//                                         ],
//                                        )
                                        
//                                     )
//                                   )
//                               ),
//                             VerticalDivider(width: 1.0),
//                             Expanded(
//                               child:  Padding(
//                                 padding: const EdgeInsetsDirectional.only(top: 10),
//                                 child:  Container(
//                                       child: 
//                                       SocialCubit.get(context).posts2[2].postImage.toString().split('.').last.substring(0,3) != 'mp4'?
//                                       Image.network(
//                                             SocialCubit.get(context).posts2[2].postImage.toString(),
//                                           width: MediaQuery.of(context).size.width-26,
//                                           height: 100,
//                                           fit: BoxFit.fill,
//                                           errorBuilder: (context, error, stackTrace) {
//                                             return CircularProgressIndicator();
//                                           },
//                                         ):
//                                         Stack(
//                                         children: <Widget>[
//                                          Container(
//                                           width: MediaQuery.of(context).size.width-26,
//                                           height: 100,
//                                           child: VideoPlayerLayout(SocialCubit.get(context).posts2[2].postImage!.toString())),
//                                                Positioned.fill(
//                                                 child: Padding(
//                                                   padding: const EdgeInsets.all(8.0),
//                                                   child: Align(
//                                                     alignment: Alignment.center,
//                                                     child: Container(
//                                                       padding: EdgeInsets.all(3.0),
//                                                       decoration: BoxDecoration(
//                                                         borderRadius: BorderRadius.circular(30),
//                                                         color: Color.fromARGB(66, 255, 255, 255),
//                                                         boxShadow: [
//                                                           BoxShadow(color: Color.fromARGB(157, 255, 255, 255), spreadRadius: 3),
//                                                         ],
//                                                       ),
//                                                       child: Icon(Icons.play_arrow_outlined, size:20)     ,
//                                                     )           
//                                                   ),
//                                                 ),
//                                               ),
//                                         ],
//                                        )
                                        
//                                     )
//                                   )
//                               ),
//                           ],
//                         ),
//                           ],
//                         )
//                         :
//                         lengthsubpost!.length == 4?
//                           Column(
//                             children: <Widget>[
//                               Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Expanded(
//                               child:  Padding(
//                                 padding: const EdgeInsetsDirectional.only(top: 10),
//                                 child:  Container(
//                                       child: 
//                                       SocialCubit.get(context).posts2[0].postImage.toString().split('.').last.substring(0,3) != 'mp4'?
//                                       Image.network(
//                                             SocialCubit.get(context).posts2[0].postImage.toString(),
//                                           width: MediaQuery.of(context).size.width-26,
//                                           height: 100,
//                                           fit: BoxFit.fill,
//                                           errorBuilder: (context, error, stackTrace) {
//                                             return CircularProgressIndicator();
//                                           },
//                                         ):
//                                         Stack(
//                                         children: <Widget>[
//                                          Container(
//                                           width: MediaQuery.of(context).size.width-26,
//                                           height: 100,
//                                           child: VideoPlayerLayout(SocialCubit.get(context).posts2[0].postImage!.toString())),
//                                                Positioned.fill(
//                                                 child: Padding(
//                                                   padding: const EdgeInsets.all(8.0),
//                                                   child: Align(
//                                                     alignment: Alignment.center,
//                                                     child: Container(
//                                                       padding: EdgeInsets.all(3.0),
//                                                       decoration: BoxDecoration(
//                                                         borderRadius: BorderRadius.circular(30),
//                                                         color: Color.fromARGB(66, 255, 255, 255),
//                                                         boxShadow: [
//                                                           BoxShadow(color: Color.fromARGB(157, 255, 255, 255), spreadRadius: 3),
//                                                         ],
//                                                       ),
//                                                       child: Icon(Icons.play_arrow_outlined, size:20)     ,
//                                                     )           
//                                                   ),
//                                                 ),
//                                               ),
//                                         ],
//                                        )
                                        
//                                     )
//                                   )
//                               ),
//                             VerticalDivider(width: 1.0),
//                             Expanded(
//                               child:  Padding(
//                                 padding: const EdgeInsetsDirectional.only(top: 10),
//                                 child:  Container(
//                                       child: 
//                                       SocialCubit.get(context).posts2[1].postImage.toString().split('.').last.substring(0,3) != 'mp4'?
//                                       Image.network(
//                                             SocialCubit.get(context).posts2[1].postImage.toString(),
//                                           width: MediaQuery.of(context).size.width-26,
//                                           height: 100,
//                                           fit: BoxFit.fill,
//                                           errorBuilder: (context, error, stackTrace) {
//                                             return CircularProgressIndicator();
//                                           },
//                                         ):
//                                         Stack(
//                                         children: <Widget>[
//                                          Container(
//                                           width: MediaQuery.of(context).size.width-26,
//                                           height: 100,
//                                           child: VideoPlayerLayout(SocialCubit.get(context).posts2[1].postImage!.toString())),
//                                                Positioned.fill(
//                                                 child: Padding(
//                                                   padding: const EdgeInsets.all(8.0),
//                                                   child: Align(
//                                                     alignment: Alignment.center,
//                                                     child: Container(
//                                                       padding: EdgeInsets.all(3.0),
//                                                       decoration: BoxDecoration(
//                                                         borderRadius: BorderRadius.circular(30),
//                                                         color: Color.fromARGB(66, 255, 255, 255),
//                                                         boxShadow: [
//                                                           BoxShadow(color: Color.fromARGB(157, 255, 255, 255), spreadRadius: 3),
//                                                         ],
//                                                       ),
//                                                       child: Icon(Icons.play_arrow_outlined, size:20)     ,
//                                                     )           
//                                                   ),
//                                                 ),
//                                               ),
//                                         ],
//                                        )
                                        
//                                     )
//                                   )
//                               ),
//                           ],
//                         ),
//                           Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Expanded(
//                               child:  Padding(
//                                 padding: const EdgeInsetsDirectional.only(top: 10),
//                                 child:  Container(
//                                       child: 
//                                       SocialCubit.get(context).posts2[2].postImage.toString().split('.').last.substring(0,3) != 'mp4'?
//                                       Image.network(
//                                             SocialCubit.get(context).posts2[2].postImage.toString(),
//                                           width: MediaQuery.of(context).size.width-26,
//                                           height: 100,
//                                           fit: BoxFit.fill,
//                                           errorBuilder: (context, error, stackTrace) {
//                                             return CircularProgressIndicator();
//                                           },
//                                         ):
//                                         Stack(
//                                         children: <Widget>[
//                                          Container(
//                                           width: MediaQuery.of(context).size.width-26,
//                                           height: 100,
//                                           child: VideoPlayerLayout(SocialCubit.get(context).posts2[2].postImage!.toString())),
//                                                Positioned.fill(
//                                                 child: Padding(
//                                                   padding: const EdgeInsets.all(8.0),
//                                                   child: Align(
//                                                     alignment: Alignment.center,
//                                                     child: Container(
//                                                       padding: EdgeInsets.all(3.0),
//                                                       decoration: BoxDecoration(
//                                                         borderRadius: BorderRadius.circular(30),
//                                                         color: Color.fromARGB(66, 255, 255, 255),
//                                                         boxShadow: [
//                                                           BoxShadow(color: Color.fromARGB(157, 255, 255, 255), spreadRadius: 3),
//                                                         ],
//                                                       ),
//                                                       child: Icon(Icons.play_arrow_outlined, size:20)     ,
//                                                     )           
//                                                   ),
//                                                 ),
//                                               ),
//                                         ],
//                                        )
                                        
//                                     )
//                                   )
//                               ),
//                             VerticalDivider(width: 1.0),
//                             Expanded(
//                               child:  Padding(
//                                 padding: const EdgeInsetsDirectional.only(top: 10),
//                                 child:  Container(
//                                       child: 
//                                       SocialCubit.get(context).posts2[3].postImage.toString().split('.').last.substring(0,3) != 'mp4'?
//                                       Image.network(
//                                             SocialCubit.get(context).posts2[3].postImage.toString(),
//                                           width: MediaQuery.of(context).size.width-26,
//                                           height: 100,
//                                           fit: BoxFit.fill,
//                                           errorBuilder: (context, error, stackTrace) {
//                                             return CircularProgressIndicator();
//                                           },
//                                         ):
//                                         Stack(
//                                         children: <Widget>[
//                                          Container(
//                                           width: MediaQuery.of(context).size.width-26,
//                                           height: 100,
//                                           child: VideoPlayerLayout(SocialCubit.get(context).posts2[3].postImage!.toString())),
//                                                Positioned.fill(
//                                                 child: Padding(
//                                                   padding: const EdgeInsets.all(8.0),
//                                                   child: Align(
//                                                     alignment: Alignment.center,
//                                                     child: Container(
//                                                       padding: EdgeInsets.all(3.0),
//                                                       decoration: BoxDecoration(
//                                                         borderRadius: BorderRadius.circular(30),
//                                                         color: Color.fromARGB(66, 255, 255, 255),
//                                                         boxShadow: [
//                                                           BoxShadow(color: Color.fromARGB(157, 255, 255, 255), spreadRadius: 3),
//                                                         ],
//                                                       ),
//                                                       child: Icon(Icons.play_arrow_outlined, size:20)     ,
//                                                     )           
//                                                   ),
//                                                 ),
//                                               ),
//                                         ],
//                                        )
                                        
//                                     )
//                                   )
//                               ),
//                           ],
//                         ),
//                             ],
//                           )
//                           :
//                           lengthsubpost!.length > 4 ?
//                           Column(
//                             children: <Widget>[
//                               Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Expanded(
//                               child:  Padding(
//                                 padding: const EdgeInsetsDirectional.only(top: 10),
//                                 child: Container(
//                                       child: 
//                                       SocialCubit.get(context).posts2[0].postImage.toString().split('.').last.substring(0,3) != 'mp4'?
//                                       Image.network(
//                                             SocialCubit.get(context).posts2[0].postImage.toString(),
//                                           width: MediaQuery.of(context).size.width-26,
//                                           height: 100,
//                                           fit: BoxFit.fill,
//                                           errorBuilder: (context, error, stackTrace) {
//                                             return CircularProgressIndicator();
//                                           },
//                                         ):
//                                         Stack(
//                                         children: <Widget>[
//                                          Container(
//                                           width: MediaQuery.of(context).size.width-26,
//                                           height: 100,
//                                           child: VideoPlayerLayout(SocialCubit.get(context).posts2[0].postImage!.toString())),
//                                                Positioned.fill(
//                                                 child: Padding(
//                                                   padding: const EdgeInsets.all(8.0),
//                                                   child: Align(
//                                                     alignment: Alignment.center,
//                                                     child: Container(
//                                                       padding: EdgeInsets.all(3.0),
//                                                       decoration: BoxDecoration(
//                                                         borderRadius: BorderRadius.circular(30),
//                                                         color: Color.fromARGB(66, 255, 255, 255),
//                                                         boxShadow: [
//                                                           BoxShadow(color: Color.fromARGB(157, 255, 255, 255), spreadRadius: 3),
//                                                         ],
//                                                       ),
//                                                       child: Icon(Icons.play_arrow_outlined, size:20)     ,
//                                                     )           
//                                                   ),
//                                                 ),
//                                               ),
//                                         ],
//                                        )
                                        
//                                     ))
//                               ),
//                             VerticalDivider(width: 1.0),
//                             Expanded(
//                               child:  Padding(
//                                 padding: const EdgeInsetsDirectional.only(top: 10),
//                                 child: Container(
//                                       child: 
//                                       SocialCubit.get(context).posts2[1].postImage.toString().split('.').last.substring(0,3) != 'mp4'?
//                                       Image.network(
//                                             SocialCubit.get(context).posts2[1].postImage.toString(),
//                                           width: MediaQuery.of(context).size.width-26,
//                                           height: 100,
//                                           fit: BoxFit.fill,
//                                           errorBuilder: (context, error, stackTrace) {
//                                             return CircularProgressIndicator();
//                                           },
//                                         ):
//                                         Stack(
//                                         children: <Widget>[
//                                          Container(
//                                           width: MediaQuery.of(context).size.width-26,
//                                           height: 100,
//                                           child: VideoPlayerLayout(SocialCubit.get(context).posts2[1].postImage!.toString())),
//                                                Positioned.fill(
//                                                 child: Padding(
//                                                   padding: const EdgeInsets.all(8.0),
//                                                   child: Align(
//                                                     alignment: Alignment.center,
//                                                     child: Container(
//                                                       padding: EdgeInsets.all(3.0),
//                                                       decoration: BoxDecoration(
//                                                         borderRadius: BorderRadius.circular(30),
//                                                         color: Color.fromARGB(66, 255, 255, 255),
//                                                         boxShadow: [
//                                                           BoxShadow(color: Color.fromARGB(157, 255, 255, 255), spreadRadius: 3),
//                                                         ],
//                                                       ),
//                                                       child: Icon(Icons.play_arrow_outlined, size:20)     ,
//                                                     )           
//                                                   ),
//                                                 ),
//                                               ),
//                                         ],
//                                        )
                                        
//                                     ))
//                               ),
//                           ],
//                         ),
//                           Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Expanded(
//                               child:  Padding(
//                                 padding: const EdgeInsetsDirectional.only(top: 10),
//                                 child: Container(
//                                       child: 
//                                       SocialCubit.get(context).posts2[2].postImage.toString().split('.').last.substring(0,3) != 'mp4'?
//                                       Image.network(
//                                             SocialCubit.get(context).posts2[2].postImage.toString(),
//                                           width: MediaQuery.of(context).size.width-26,
//                                           height: 100,
//                                           fit: BoxFit.fill,
//                                           errorBuilder: (context, error, stackTrace) {
//                                             return CircularProgressIndicator();
//                                           },
//                                         ):
//                                         Stack(
//                                         children: <Widget>[
//                                          Container(
//                                           width: MediaQuery.of(context).size.width-26,
//                                           height: 100,
//                                           child: VideoPlayerLayout(SocialCubit.get(context).posts2[2].postImage!.toString())),
//                                                Positioned.fill(
//                                                 child: Padding(
//                                                   padding: const EdgeInsets.all(8.0),
//                                                   child: Align(
//                                                     alignment: Alignment.center,
//                                                     child: Container(
//                                                       padding: EdgeInsets.all(3.0),
//                                                       decoration: BoxDecoration(
//                                                         borderRadius: BorderRadius.circular(30),
//                                                         color: Color.fromARGB(66, 255, 255, 255),
//                                                         boxShadow: [
//                                                           BoxShadow(color: Color.fromARGB(157, 255, 255, 255), spreadRadius: 3),
//                                                         ],
//                                                       ),
//                                                       child: Icon(Icons.play_arrow_outlined, size:20)     ,
//                                                     )           
//                                                   ),
//                                                 ),
//                                               ),
//                                         ],
//                                        )
                                        
//                                     ))
//                               ),
//                             VerticalDivider(width: 1.0),
//                             Expanded(
//                               child: Stack(
//                                 children: [
//                                   Expanded(
//                                 child:  Padding(
//                                   padding: const EdgeInsetsDirectional.only(top: 10),
//                                   child: 
//                                   Container(
//                                       child: 
//                                       SocialCubit.get(context).posts2[3].postImage.toString().split('.').last.substring(0,3) != 'mp4'?
//                                       Image.network(
//                                             SocialCubit.get(context).posts2[3].postImage.toString(),
//                                           width: MediaQuery.of(context).size.width-26,
//                                           height: 100,
//                                           fit: BoxFit.fill,
//                                           errorBuilder: (context, error, stackTrace) {
//                                             return CircularProgressIndicator();
//                                           },
//                                         ):
//                                         Stack(
//                                         children: <Widget>[
//                                          Container(
//                                           height: 100,
//                                           child: VideoPlayerLayout(SocialCubit.get(context).posts2[3].postImage!.toString())),
//                                                Positioned.fill(
//                                                 child: Padding(
//                                                   padding: const EdgeInsets.all(8.0),
//                                                   child: Align(
//                                                     alignment: Alignment.center,
//                                                     child: Container(
//                                                       padding: EdgeInsets.all(3.0),
//                                                       decoration: BoxDecoration(
//                                                         borderRadius: BorderRadius.circular(30),
//                                                         color: Color.fromARGB(66, 255, 255, 255),
//                                                         boxShadow: [
//                                                           BoxShadow(color: Color.fromARGB(157, 255, 255, 255), spreadRadius: 3),
//                                                         ],
//                                                       ),
//                                                       child: Icon(Icons.play_arrow_outlined, size:20)     ,
//                                                     )           
//                                                   ),
//                                                 ),
//                                               ),
//                                         ],
//                                        )
                                        
//                                     ))
//                                 ),
//                                 Expanded(
//                                 child:  Padding(
//                                   padding: const EdgeInsetsDirectional.only(top: 10),
//                                   child: Stack(
//                                     children: [
//                                           Container(
//                                             height: 100,
//                                             color: Colors.black,
//                                             child: ColorFiltered(
//                                                 colorFilter:
//                                                     ColorFilter.mode(Colors.black.withOpacity(0.1), BlendMode.color),
//                                                 child: Container(
//                                       child: 
//                                       SocialCubit.get(context).posts2[3].postImage.toString().split('.').last.substring(0,3) != 'mp4'?
//                                       Image.network(
//                                             SocialCubit.get(context).posts2[3].postImage.toString(),
//                                           width: MediaQuery.of(context).size.width-26,
//                                           height: 100,
//                                           fit: BoxFit.fill,
//                                           errorBuilder: (context, error, stackTrace) {
//                                             return CircularProgressIndicator();
//                                           },
//                                         ):
//                                         Stack(
//                                         children: <Widget>[
//                                          Container(
//                                           height: 100,
//                                           child: VideoPlayerLayout(SocialCubit.get(context).posts2[3].postImage!.toString())),
//                                                Positioned.fill(
//                                                 child: Padding(
//                                                   padding: const EdgeInsets.all(8.0),
//                                                   child: Align(
//                                                     alignment: Alignment.center,
//                                                     child: Container(
//                                                       padding: EdgeInsets.all(3.0),
//                                                       decoration: BoxDecoration(
//                                                         borderRadius: BorderRadius.circular(30),
//                                                         color: Color.fromARGB(66, 255, 255, 255),
//                                                         boxShadow: [
//                                                           BoxShadow(color: Color.fromARGB(157, 255, 255, 255), spreadRadius: 3),
//                                                         ],
//                                                       ),
//                                                       child: Icon(Icons.play_arrow_outlined, size:20)     ,
//                                                     )           
//                                                   ),
//                                                 ),
//                                               ),
//                                         ],
//                                        )
                                        
//                                     ),
//                                               ),
//                                           ),
//                                             Positioned.fill(
//                                               child: Align(
//                                                 alignment: Alignment.center,
//                                                 child: Text('+ ' + 
//                                                   (SocialCubit.get(context).posts2.length-3).toString(), style: TextStyle(fontSize: 30, color: Colors.black87,fontWeight: FontWeight.bold,))             
//                                               ),
//                                             ),
//                                     ],
//                                   )
//                                   )
//                                 )
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                             ],
//                           )
//                           :
//                           Container(),
                      
                    // ),

                ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(end: 6.0),
                    child: SizedBox(
                      height: 20,
                      child: MaterialButton(
                        onPressed: () {},
                        minWidth: 1.0,
                        padding: EdgeInsets.zero,
                        child: Text(
                          "#Software",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {},
                    child: Row(

                      children: [
                        Icon(
                          IconBroken.Heart,
                          color: Colors.red,
                          size: 20,
                        ),
                        Text(
                          '${model.likes}',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  //if(model.comments != 0)
                  Spacer(),
                  InkWell(
                      onTap: () {
                        navigateTo(
                            context,
                            CommentsScreen(likes: model.likes, postId: model.postId,postUid: model.uId,));
                      },
                      child: Row(

                        mainAxisAlignment: MainAxisAlignment.end,
                        children:  [
                          Icon(
                            IconBroken.Chat,
                            color: Colors.amber,
                            size: 20,
                          ),
                          Text('${model.comments} ', style: TextStyle(fontSize: 10)),
                          Text(
                            "Comments",
                            style: TextStyle(fontSize: 10),
                          ),
                        ],
                      )),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              myDivider(),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        navigateTo(
                          context,
                          CommentsScreen(likes: model.likes, postId: model.postId,postUid: model.uId,),
                        );
                      },
                      child: Row(

                        children: [

                          CircleAvatar(
                              radius: 13,
                              backgroundImage: NetworkImage('${userModel.image}')),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "Write a comment",
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      SocialUserModel ? postUser = SocialCubit.get(context).socialUserModel;
                      await SocialCubit.get(context).likedByMe(
                          postUser: postUser,
                          context: context,
                          postModel: model,
                          postId: model.postId
                      );

                    },
                    child: Row(
                      children: const [
                        Icon(
                          IconBroken.Heart,
                          color: Colors.red,
                          size: 20,
                        ),
                        Text(
                          ' Like',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  PopupMenuButton(

                    onSelected: (value) {
                      if (value == 'Share') {
                        // SocialCubit.get(context).createNewPost(
                        //     name: SocialCubit.get(context).model!.name,
                        //     profileImage: SocialCubit.get(context).model!.profilePic,
                        //     postText: postModel.postText,
                        //     postImage: postModel.postImage,
                        //     date: getDate() ,
                        //     time: TimeOfDay.now().format(context).toString()
                        // ) ;
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                          value: 'Share',
                          child: Row(
                            children: const [
                              Icon(Icons.share, color: Colors.green),
                              Text(
                                "Share now",
                              ),
                            ],
                          ))
                    ],
                    child: Row(
                      children: const [
                        Icon(
                          Icons.share,
                          color: Colors.green,
                          size: 20,
                        ),
                        Text(
                          "Share",
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      );
}


Widget imgPost(PostModelSub modelSub)
     { 
      return
         Image.network(
               modelSub.postImage.toString(),
            width: 100,
            height: 100,
            fit: BoxFit.fill,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset('assets/images/loading_icon.gif',
                  width: 100, height: 100, fit: BoxFit.fill);
            },
          );
     
     }