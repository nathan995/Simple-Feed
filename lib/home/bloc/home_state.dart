part of 'home_bloc.dart';

@immutable
abstract class HomeState {
  final List<Post> feed = [];
}

class HomeInitial extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeErrorState extends HomeState {
  final String message;
  HomeErrorState({this.message});
}

class HomeLikeErrorState extends HomeState {
  final String message;
  HomeLikeErrorState({this.message});
}

class NewFeedState extends HomeState {
  final List<Post> feed;
  NewFeedState({this.feed});
}

class ImageState extends HomeState {
  final File image;
  ImageState({this.image});
}

class PostLoadingState extends HomeState {}

class PostErrorState extends HomeState {
  final String message;
  PostErrorState({this.message});
}

class PostSumbittedState extends HomeState {}
