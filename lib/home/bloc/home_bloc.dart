import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:simple_feed/api/respository.dart';
import 'package:simple_feed/models/post.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial());
  final ApiRespository repository = ApiRespository();
  int limit = 1;
  int page = 1;
  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is HomeLoadingEvent) {
      yield* _load(
        page: 1,
        feed: [],
      );
    }
    if (event is LoadMoreEvent) {
      yield* _load(
        page: page + 1,
        feed: event.feed,
      );
    }
    if (event is UpdateImageEvent) {
      yield ImageState(image: event.image);
    }
    if (event is LikeEvent) {
      yield* _like(
        index: event.index,
        feed: event.feed,
      );
    }
    if (event is SumbitPost) {
      yield* _sumbitPost(
        caption: event.caption,
        image: event.image,
      );
    }
    if (event is PostErrorEvent) {
      yield PostErrorState(message: event.message);
    }
  }

  Stream<HomeState> _load({int page, List<Post> feed}) async* {
    if (page == 1) yield HomeLoadingState();
    try {
      if (page <= limit) {
        final _posts = await repository.getPosts(page: page);
        yield NewFeedState(
          feed: feed.isEmpty ? _posts['feed'] : feed + _posts['feed'],
        );
        page = page;
        limit = _posts['limit'];
      }
    } catch (e) {
      yield HomeErrorState(message: 'An error occurred');
    }
  }

  Stream<HomeState> _like({int index, List<Post> feed}) async* {
    Post post = feed[index];
    if (post.isLiked) {
      post.isLiked = false;
      post.likes -= 1;
    } else {
      post.isLiked = true;
      post.likes += 1;
    }
    feed[index] = post;
    yield NewFeedState(feed: feed);
    try {
      if (!post.isLiked) {
        await repository.unLikePost(id: post.id);
      } else {
        await repository.likePost(id: post.id);
      }
    } catch (e) {
      post.isLiked = !post.isLiked;
      post.likes = post.isLiked ? post.likes + 1 : post.likes - 1;
      feed[index] = post;
      yield HomeLikeErrorState(
          message:
              "Error ${feed[index].isLiked ? 'unliking' : 'liking'} post. Please try again.");
      yield NewFeedState(feed: feed);
    }
  }

  Stream<HomeState> _sumbitPost({String caption, File image}) async* {
    yield PostLoadingState();
    try {
      repository.addPost(caption: caption, image: image);
      final _posts = await repository.getPosts(page: 1);
      page = 1;
      limit = _posts['limit'];
      yield PostSumbittedState();
      yield NewFeedState(feed: _posts['feed']);
    } catch (e) {
      print(e);
      yield PostErrorState(message: 'Error submiting post. Please try again.');
    }
  }
}
