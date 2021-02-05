part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class HomeLoadingEvent extends HomeEvent {}

class UpdateImageEvent extends HomeEvent {
  final File image;
  UpdateImageEvent({@required this.image});
}

class LoadMoreEvent extends HomeEvent {
  final List<Post> feed;
  LoadMoreEvent({@required this.feed});
}

class LikeEvent extends HomeEvent {
  final int index;
  final List<Post> feed;
  LikeEvent({@required this.index, @required this.feed});
}

class SumbitPost extends HomeEvent {
  final File image;
  final String caption;
  SumbitPost({@required this.image, @required this.caption});
}

class PostErrorEvent extends HomeEvent {
  final String message;
  PostErrorEvent({this.message});
}
