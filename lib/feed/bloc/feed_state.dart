part of 'feed_bloc.dart';

@immutable
abstract class FeedState {
  final feed = [];
}

class FeedInitial extends FeedState {
  final feed;
  FeedInitial(
    this.feed,
  );
}

class NewFeedState extends FeedState {
  final feed;
  NewFeedState(this.feed);
}
