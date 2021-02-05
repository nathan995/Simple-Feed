import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_feed/authentication/bloc/authentication_bloc.dart';
import 'package:simple_feed/home/bloc/home_bloc.dart';
import 'package:simple_feed/home/view/post_page.dart';

import 'package:simple_feed/models/post.dart';

class Home extends StatelessWidget {
  static String routeName = '/';
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final HomeBloc homeBloc = BlocProvider.of<HomeBloc>(context);
    final AuthenticationBloc authenticationBloc =
        BlocProvider.of<AuthenticationBloc>(context);
    Future<void> _load() async {
      homeBloc.add(HomeLoadingEvent());
    }

    _load();
    void _logOut() {
      authenticationBloc.add(UnAuthenticate());
    }

    return BlocListener<HomeBloc, HomeState>(
      listenWhen: (previous, current) => current is HomeLikeErrorState,
      listener: (context, state) {
        if (state is HomeLikeErrorState) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("${state.message}"),
            duration: Duration(seconds: 3),
          ));
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Feed',
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).accentColor),
          ),
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(
                Icons.logout,
                color: Theme.of(context).accentColor,
              ),
              onPressed: _logOut,
            ),
          ],
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
            buildWhen: (previous, current) =>
                current is HomeLoadingState ||
                current is HomeErrorState ||
                current is NewFeedState,
            builder: (context, state) {
              if (state is HomeErrorState) {
                return Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${state.message}',
                          style: TextStyle(fontSize: 15.0),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 18.0),
                          child: FlatButton(
                            color: Theme.of(context).primaryColor,
                            textColor: Theme.of(context).backgroundColor,
                            onPressed: _load,
                            child: Text('Try again'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is HomeLoadingState) {
                return Container(
                  child: Center(
                    child: SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator()),
                  ),
                );
              } else if (state is NewFeedState) {
                return BlocBuilder<HomeBloc, HomeState>(
                  buildWhen: (current, previous) =>
                      current.feed != previous.feed,
                  builder: (context, state) {
                    return RefreshIndicator(
                      child: ListView.builder(
                        itemCount: state.feed.length,
                        itemBuilder: (context, index) {
                          final _post = state.feed[index];
                          if (index == state.feed.length - 1) {
                            homeBloc.add(LoadMoreEvent(feed: state.feed));
                          }
                          return BuildPost(post: _post, index: index);
                        },
                      ),
                      onRefresh: _load,
                    );
                  },
                );
              }
              return Container();
            }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, PostPage.routeName);
          },
          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }
}

class BuildPost extends StatelessWidget {
  final Post post;
  final int index;
  BuildPost({@required this.post, @required this.index});
  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    final DateTime _now = DateTime.now();
    final HomeBloc homeBloc = BlocProvider.of<HomeBloc>(context);

    final _diff = _now.difference(DateTime.parse(post.created));
    final _date = _diff.inDays > 0
        ? "${_diff.inDays} days"
        : _diff.inHours > 0
            ? "${_diff.inHours} hours"
            : _diff.inMinutes > 0
                ? "${_diff.inMinutes} min"
                : _diff.inSeconds > 0
                    ? "${_diff.inSeconds} sec"
                    : 'just now';
    return Column(
      children: [
        SizedBox(
          width: _width,
          height: _width * 10 / 16,
          child: Image.asset(
            post.image,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 17,
                          backgroundImage: AssetImage(
                            post.profileImage,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post.name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 2.0),
                                child: RichText(
                                  text: TextSpan(
                                    style: DefaultTextStyle.of(context).style,
                                    children: [
                                      TextSpan(
                                        text: "@username ",
                                        style: TextStyle(
                                          color: post.isLiked
                                              ? Theme.of(context).accentColor
                                              : Theme.of(context).hintColor,
                                          fontFamily: 'Roboto',
                                          fontSize: 12.0,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                      TextSpan(
                                        text: _date == 'just now'
                                            ? _date
                                            : '$_date ago',
                                        style: TextStyle(
                                          fontFamily: 'Roboto',
                                          fontSize: 12.0,
                                          color: post.isLiked
                                              ? Theme.of(context).accentColor
                                              : Theme.of(context).hintColor,
                                          decoration: TextDecoration.none,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: IconButton(
                          icon: post.isLiked
                              ? Icon(
                                  Icons.favorite,
                                  size: 17,
                                  color: Theme.of(context).primaryColor,
                                )
                              : Icon(
                                  Icons.favorite_border,
                                  size: 17,
                                ),
                          onPressed: () {
                            homeBloc.add(LikeEvent(
                                index: index, feed: homeBloc.state.feed));
                          },
                        ),
                      ),
                      Text(
                        "${post.likes}",
                        style: TextStyle(
                            color: post.isLiked
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).accentColor,
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 15),
                child: Text(
                  '${post.caption}',
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
