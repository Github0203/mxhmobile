import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:socialapp/shared/components/components.dart';



abstract class SocialStates {}

class SocialInitialState extends SocialStates {}

class SocialGetUserLoadingState extends SocialStates {}

class SocialGetUserSuccessState extends SocialStates {}

class SocialGetUserErrorState extends SocialStates {
  final String error;

  SocialGetUserErrorState(this.error);
}

class SocialGetAllUserLoadingState extends SocialStates {}

class SocialGetAllUserSuccessState extends SocialStates {}

class SocialGetAllUserErrorState extends SocialStates {
  final String error;

  SocialGetAllUserErrorState(this.error);
}

class SocialChangeBottomNav extends SocialStates {}

class SocialNewPostState extends SocialStates {}

class ChangeAppModeState extends SocialStates {}

class SocialProfileImageSuccessState extends SocialStates {}

class SocialProfileImageErrorState extends SocialStates {}

class SocialCoverSuccessState extends SocialStates {}

class SocialCoverErrorState extends SocialStates {}

class SocialAddSubPostErrorState extends SocialStates {}

class SocialAddSubPostLoadingState extends SocialStates {}

class SocialAddSubPostSuccessState extends SocialStates {}

class SocialGetSubPostErrorState extends SocialStates {}

class SocialGetSubPostLoadingState extends SocialStates {}

class SocialGetSubPostSuccessState extends SocialStates {}

class SocialUploadProfileImageLoadingState extends SocialStates {}

class SocialUploadProfileImageSuccessState extends SocialStates {}

class SocialUploadProfileImageErrorState extends SocialStates {}

class SocialUploadCoverImageLoadingState extends SocialStates {}

class SocialUploadCoverSuccessState extends SocialStates {}

class SocialUploadCoverErrorState extends SocialStates {}

class SocialUserUpdateLoadingState extends SocialStates {}

class SocialUserUpdateErrorState extends SocialStates {}

class SocialCreatePostSuccessState extends SocialStates {}

class SocialCreatePostErrorState extends SocialStates {}

class SocialCreatePostLoadingState extends SocialStates {}

class SocialCreateFilePostSuccessState extends SocialStates {}

class SocialCreateFilePostErrorState extends SocialStates {}

class SocialPostSuccessState extends SocialStates {}

class SocialPostErrorState extends SocialStates {}

class SocialRemovePostState extends SocialStates {}

class DeletePostSuccessState extends SocialStates {}

class SocialGetPostsLoadingState extends SocialStates {}

class SocialGetPostsSuccessState extends SocialStates {}

class SocialGetPostsErrorState extends SocialStates {
  final String error;

  SocialGetPostsErrorState(this.error);
}

class SocialLikePostsSuccessState extends SocialStates {}

class SocialLikePostsLoadingState extends SocialStates {}

class SocialLikePostsErrorState extends SocialStates {
  final String error;

  SocialLikePostsErrorState(this.error);
}

class SocialCommentLoadingState extends SocialStates {}

class SocialCommentSuccessState extends SocialStates {}

class SocialCommentErrorState extends SocialStates {
  final String error;

  SocialCommentErrorState(this.error);
}

class GetCommentLoadingState extends SocialStates {}

class GetCommentSuccessState extends SocialStates {}

class GetCommentsErrorState extends SocialStates {}

class GetCommentSubLoadingState extends SocialStates {}

class GetCommentSubSuccessState extends SocialStates {}

class GetCommentsSubErrorState extends SocialStates {}

class UploadCommentPicLoadingState extends SocialStates {}

class UploadCommentPicSuccessState extends SocialStates {}

class UploadCommentPicErrorState extends SocialStates {}

class UploadCommentPicSubLoadingState extends SocialStates {}

class UploadCommentPicSubSuccessState extends SocialStates {}

class UploadCommentPicSubErrorState extends SocialStates {}

class UpdatePostLoadingState extends SocialStates {}

class GetCommentPicSuccessState extends SocialStates {}

class GetCommentPicErrorState extends SocialStates {}

class GetCommentPicSubSuccessState extends SocialStates {}

class GetCommentPicSubErrorState extends SocialStates {}

class SocialSendMessageSuccessState extends SocialStates {}

class SocialSendMessageErrorState extends SocialStates {}

class SocialGetMessageSuccessState extends SocialStates {}

class GetMessagePicSuccessState extends SocialStates {}

class GetMessagePicErrorState extends SocialStates {}

class UploadMessagePicLoadingState extends SocialStates {}

class UploadMessagePicSuccessState extends SocialStates {}

class UploadMessagePicErrorState extends SocialStates {}

class DeleteMessagePicState extends SocialStates {}

class DeleteCommentPicState extends SocialStates {}

class GetPostLoadingState extends SocialStates {}

class GetSinglePostSuccessState extends SocialStates {}

class GetPostErrorState extends SocialStates {}

class UploadMultiPicLoadingState extends SocialStates {}

class UploadMultiPicSuccessState extends SocialStates {}

class UploadMultiPicErrorState extends SocialStates {}

class DeleteMultiPicState extends SocialStates {}

class DeleteAMultiPicSuccessState extends SocialStates {}

class DeleteAMultiPicErrorState extends SocialStates {}

class DeleteIndexMultiPicSuccessState extends SocialStates {}

class DeleteIndexMultiPicErrorState extends SocialStates {}

class DeleteAllFilePickerSuccessState extends SocialStates {}

class DeleteAllFilePickerErrorState extends SocialStates {}

class ResetPostSuccessState extends SocialStates {}

class ResetPostErrorState extends SocialStates {}