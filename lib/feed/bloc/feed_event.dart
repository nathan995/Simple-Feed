part of 'feed_bloc.dart';

@immutable
abstract class FeedEvent {}

class UpdateFeed extends FeedEvent {
  final feed;
  UpdateFeed(this.feed);
}
