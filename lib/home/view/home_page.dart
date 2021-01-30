import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_feed/authentication/bloc/authentication_bloc.dart';
import 'package:simple_feed/feed/bloc/feed_bloc.dart';
import 'package:simple_feed/home/bloc/home_bloc.dart';

class Home extends StatelessWidget {
  static String routeName = '/home';
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeBloc(),
        ),
        BlocProvider(
          create: (context) => FeedBloc(),
        ),
      ],
      child: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  Dio dio = new Dio();

  @override
  Widget build(BuildContext context) {
    final String _phone = context.read<AuthenticationBloc>().state.phone;

    void _logOut() {
      context.read<AuthenticationBloc>().add(UnAuthenticate());
    }

    void _load() async {
      final response = await dio
          .get("https://simple-feed-test.herokuapp.com/v1/posts/?page=1");
      // print(response.data.toString());
      // print(response.data['docs'].runtimeType);
      context.read<HomeBloc>().add(SetNotLoading());
      context.read<FeedBloc>().add(UpdateFeed(response.data['docs']));
    }

    _load();
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Feed',
            style: TextStyle(
                fontWeight: FontWeight.bold,
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
          builder: (context, state) {
            if (state.errorStatus == ErrorStatus.error) {
              return Container(
                child: Text('An error occured'),
              );
            } else {
              if (state.loadingStatus == LoadingStatus.loading) {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return BlocBuilder<FeedBloc, FeedState>(
                  builder: (context, state) {
                    if (state.feed.isEmpty) {
                      return Container();
                    }
                    return ListView.builder(
                      itemCount: state.feed.length,
                      itemBuilder: (context, index) {
                        final post = state.feed[index];
                        return Post(
                          username: post['user']['name'],
                          name: post['user']['username'],
                          image: 'assets/images/logo.png',
                          profileImage: 'assets/images/logo.png',
                          creationDate: post['created_at'],
                          likes: post['likes'],
                          isLiked: post['isLiked'],
                        );
                      },
                    );
                  },
                );
              }
            }
          },
        ));
  }
}

class Post extends StatelessWidget {
  final String username;
  final String name;
  final String image;
  final String profileImage;
  final String creationDate;
  final int likes;
  final bool isLiked;
  Post({
    @required this.username,
    @required this.name,
    @required this.image,
    @required this.profileImage,
    @required this.creationDate,
    @required this.likes,
    @required this.isLiked,
  });
  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        SizedBox(
          width: _width,
          height: _width * 9 / 16,
          child: Image.asset(
            image,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 17,
                          backgroundImage: AssetImage(
                            profileImage,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: [
                                    TextSpan(
                                      text: username,
                                      style: TextStyle(
                                        color: isLiked
                                            ? Theme.of(context).accentColor
                                            : Theme.of(context).hintColor,
                                        fontFamily: 'Roboto',
                                        fontSize: 12.0,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                    TextSpan(
                                      text: "  $creationDate",
                                      style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontSize: 12.0,
                                        color: isLiked
                                            ? Theme.of(context).accentColor
                                            : Theme.of(context).hintColor,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ],
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
                        child: isLiked
                            ? Icon(
                                Icons.favorite,
                                size: 17,
                                color: Theme.of(context).primaryColor,
                              )
                            : Icon(
                                Icons.favorite_border,
                                size: 17,
                              ),
                      ),
                      Text("${likes}")
                    ],
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  'In do non non do nisi excepteur dolore voluptate duis excepteur ipsum dolore laborum. ',
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
