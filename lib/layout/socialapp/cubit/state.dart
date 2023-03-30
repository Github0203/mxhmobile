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

class SocialGetUserFriendLoadingState extends SocialStates {}

class SocialGetUserFriendSuccessState extends SocialStates {}

class SocialGetUserFriendErrorState extends SocialStates {
  final String error;

  SocialGetUserFriendErrorState(this.error);
}

class SocialGetAllUserLoadingState extends SocialStates {}

class SocialGetAllUserSuccessState extends SocialStates {}

class SocialGetAllUserErrorState extends SocialStates {
  final String error;

  SocialGetAllUserErrorState(this.error);
}

class SocialGetAllVideoLoadingState extends SocialStates {}

class SocialGetAllVideoSuccessState extends SocialStates {}

class SocialGetAllVideoErrorState extends SocialStates {
  final String error;

  SocialGetAllVideoErrorState(this.error);
}

class SocialGetAllUserTokenLoadingState extends SocialStates {}

class SocialGetAllUserTokenSuccessState extends SocialStates {}

class SocialGetAllUserTokenErrorState extends SocialStates {
  final String error;

  SocialGetAllUserTokenErrorState(this.error);
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

class SocialAddSubAlbumErrorState extends SocialStates {}

class SocialAddSubAlbumLoadingState extends SocialStates {}

class SocialAddSubAlbumSuccessState extends SocialStates {}

class SocialGetSubPostErrorState extends SocialStates {}

class SocialGetSubPostLoadingState extends SocialStates {}

class SocialGetSubPostSuccessState extends SocialStates {}

class SocialGetSubPostTempErrorState extends SocialStates {}

class SocialGetSubPostTempLoadingState extends SocialStates {}

class SocialGetSubPostTempSuccessState extends SocialStates {}

class SocialGetEditSubPostErrorState extends SocialStates {}

class SocialGetEditSubPostLoadingState extends SocialStates {}

class SocialGetEditSubPostSuccessState extends SocialStates {}

class SocialSaveEditSubPostLoadingState extends SocialStates {}

class SocialSaveEditSubPostSuccessState extends SocialStates {}

class SocialSaveEditSubPostErrorState extends SocialStates {}

class SocialGetEditPostErrorState extends SocialStates {}

class SocialGetEditPostLoadingState extends SocialStates {}

class SocialGetEditPostSuccessState extends SocialStates {}

class SocialAllPhotosErrorState extends SocialStates {}

class SocialAllPhotosLoadingState extends SocialStates {}

class SocialAllPhotosSuccessState extends SocialStates {}

class SocialUploadProfileImageLoadingState extends SocialStates {}

class SocialUploadProfileImageSuccessState extends SocialStates {}

class SocialUploadProfileImageErrorState extends SocialStates {}

class SocialUploadCoverImageLoadingState extends SocialStates {}

class SocialUploadCoverSuccessState extends SocialStates {}

class SocialUploadCoverErrorState extends SocialStates {}

class SocialUserUpdateLoadingState extends SocialStates {}

class SocialUserUpdateSuccessState extends SocialStates {}

class SocialUserUpdateErrorState extends SocialStates {}

class SocialCreatePostSuccessState extends SocialStates {}

class SocialCreatePostErrorState extends SocialStates {}

class SocialCreatePostLoadingState extends SocialStates {}

class SocialCreateAlbumSuccessState extends SocialStates {}

class SocialCreateAlbumErrorState extends SocialStates {}

class SocialCreateAlbumLoadingState extends SocialStates {}

class SocialCreateFilePostSuccessState extends SocialStates {}

class SocialCreateFilePostErrorState extends SocialStates {}

class SocialPostSuccessState extends SocialStates {}

class SocialPostErrorState extends SocialStates {}

class SocialRemovePostState extends SocialStates {}

class DeletePostSuccessState extends SocialStates {}

class DeleteSubPostSuccessState extends SocialStates {}

class SocialGetPostsLoadingState extends SocialStates {}

class SocialGetPostsSuccessState extends SocialStates {}

class SocialGetPostsErrorState extends SocialStates {
  final String error;

  SocialGetPostsErrorState(this.error);
}

class SocialGetDetailPostsLoadingState extends SocialStates {}

class SocialGetDetailPostsSuccessState extends SocialStates {}

class SocialGetDetailPostsErrorState extends SocialStates {
  final String error;

  SocialGetDetailPostsErrorState(this.error);
}

class SocialLikePostsSuccessState extends SocialStates {}

class SocialLikePostsLoadingState extends SocialStates {}

class SocialLikePostsErrorState extends SocialStates {
  final String error;

  SocialLikePostsErrorState(this.error);
}

class SocialLikePostsSubSuccessState extends SocialStates {}

class SocialLikePostsSubLoadingState extends SocialStates {}

class SocialLikePostsSubErrorState extends SocialStates {
  final String error;

  SocialLikePostsSubErrorState(this.error);
}

class SocialUserLikePostsLoadingState extends SocialStates {}

class SocialUserLikePostsErrorState extends SocialStates {
  final String error;

  SocialUserLikePostsErrorState(this.error);
}

class SocialUserLikePostsSubSuccessState extends SocialStates {}

class SocialUserLikePostsSubLoadingState extends SocialStates {}

class SocialUserLikePostsSubErrorState extends SocialStates {
  final String error;

  SocialUserLikePostsSubErrorState(this.error);
}

class SocialUserDisLikePostsSuccessState extends SocialStates {}

class SocialUserDisLikePostsLoadingState extends SocialStates {}

class SocialUserDisLikePostsErrorState extends SocialStates {
  final String error;

  SocialUserDisLikePostsErrorState(this.error);
}

class SocialDisLikePostsSubSuccessState extends SocialStates {}

class SocialDisLikePostsSubLoadingState extends SocialStates {}

class SocialDisLikePostsSubErrorState extends SocialStates {
  final String error;

  SocialDisLikePostsSubErrorState(this.error);
}




class SocialCommentLoadingState extends SocialStates {}

class SocialCommentSuccessState extends SocialStates {}

class SocialCommentErrorState extends SocialStates {
  final String error;

  SocialCommentErrorState(this.error);
}

class SocialNotificationLoadingState extends SocialStates {}

class SociallNotificationSuccessState extends SocialStates {}

class SociallNotificationErrorState extends SocialStates {
  final String error;

  SociallNotificationErrorState(this.error);
}

class GetSocialNotificationLoadingState extends SocialStates {}

class GetSociallNotificationSuccessState extends SocialStates {}

class UpdateSociallNotificationSuccessState extends SocialStates {}

class GetSociallNotificationErrorState extends SocialStates {
  final String error;

  GetSociallNotificationErrorState(this.error);
}

class GetCommentLoadingState extends SocialStates {}

class GetCommentSuccessState extends SocialStates {}

class GetCommentsErrorState extends SocialStates {}

class GetLikedLoadingState extends SocialStates {}

class GetLikedSuccessState extends SocialStates {}

class GetLikedsErrorState extends SocialStates {}

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

class EditItemTempSuccessState extends SocialStates {}

class EditItemTempErrorState extends SocialStates {}

class GetEditItemTempSuccessState extends SocialStates {}

class GetEditItemTempErrorState extends SocialStates {}

class ResetPostSuccessState extends SocialStates {}

class ResetPostErrorState extends SocialStates {}

class LoadAlbumLoadingState extends SocialStates {}

class LoadAlbumErrorState extends SocialStates {}

class LoadAlbumSuccessState extends SocialStates {}

class LoadAlbumLevel1SuccessState extends SocialStates {}

class LoadAlbumLevel1ErrorState extends SocialStates {}

class LoadAlbumLevel2SuccessState extends SocialStates {}

class LoadAlbumLevel2ErrorState extends SocialStates {}

class GetThumbnailPathAlbumSuccessState extends SocialStates {}

class CheckFollowerSuccessState extends SocialStates {}

class CheckFollowerErrorState extends SocialStates {}

class CheckFollowerLoadingState extends SocialStates {}

class AddFollowerSuccessState extends SocialStates {}

class AddFollowerLoadingState extends SocialStates {}

class AddFollowerErrorState extends SocialStates {}

class CheckAcceptSuccessState extends SocialStates {}

class CheckAcceptErrorState extends SocialStates {}

class UnFollowerSuccessState extends SocialStates {}

class UnFollowerErrorState extends SocialStates {}

class GetFollowerSuccessState extends SocialStates {}

class SetShowMoreTagsSuccessState extends SocialStates {}

class GetFollowerErroeState extends SocialStates {}

class CheckFriendsuccessState extends SocialStates {}

class CheckFriendsErrorState extends SocialStates {}

class CheckFriendsLoadingState extends SocialStates {}

class AddFriendsSuccessState extends SocialStates {}

class AddFriendsLoadingState extends SocialStates {}

class AddFriendsErrorState extends SocialStates {}

class UnFriendsSuccessState extends SocialStates {}

class UnBothFriendsSuccessState extends SocialStates {}

class UnFriendsErrorState extends SocialStates {}

class GetFriendsSuccessState extends SocialStates {}

class GetFriendsErroeState extends SocialStates {}

class SendNotifiSuccessState extends SocialStates {}

class SendNotifiErrorState extends SocialStates {}

class GetTagsPostSuccessState extends SocialStates {}

class GetTagsPostErrorState extends SocialStates {}