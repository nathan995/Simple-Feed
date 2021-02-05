import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_feed/home/bloc/home_bloc.dart';

class PostPage extends StatelessWidget {
  static String routeName = '/home/post';
  final picker = ImagePicker();
  final _formKey = GlobalKey<FormFieldState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  File _image = new File('');

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final HomeBloc homeBloc = BlocProvider.of<HomeBloc>(context);
    PickedFile pickedImage;
    Future _pickImage() async {
      try {
        pickedImage = await picker.getImage(source: ImageSource.gallery);
        _image = File(pickedImage.path);
        homeBloc.add(UpdateImageEvent(image: _image));
      } catch (e) {}
    }

    _submitPost() async {
      if (_formKey.currentState.validate()) {
        final bool _exists = await _image.exists();
        if (_exists) {
          homeBloc.add(SumbitPost(
            image: _image,
            caption: _formKey.currentState.value,
          ));
        } else {
          homeBloc.add(
            PostErrorEvent(message: 'Please select an image.'),
          );
        }
      }
    }

    return BlocListener<HomeBloc, HomeState>(
      listenWhen: (previous, current) =>
          current is PostErrorState || current is PostSumbittedState,
      listener: (context, state) {
        if (state is PostErrorState) {
          _scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text("${state.message}"),
            duration: Duration(seconds: 3),
          ));
        } else if (state is PostSumbittedState) {
          Navigator.of(context).pop();
        }
      },
      child: BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (previous, current) =>
            current is PostLoadingState || previous is PostLoadingState,
        builder: (context, state) => Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: Theme.of(context).backgroundColor,
            elevation: 0,
            leading: BackButton(
              color: Theme.of(context).accentColor,
            ),
            actions: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 11.0, vertical: 12),
                    child: FlatButton(
                      onPressed: state is PostLoadingState ? null : _submitPost,
                      disabledColor: Color(0x99E9446A),
                      child: state is PostLoadingState
                          ? SizedBox(
                              height: 12,
                              width: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(
                                    Theme.of(context).backgroundColor),
                              ),
                            )
                          : Text('Post'),
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).backgroundColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: Container(
              color: Theme.of(context).backgroundColor,
              child: Column(
                children: [
                  BlocBuilder<HomeBloc, HomeState>(
                    buildWhen: (previous, current) => current is ImageState,
                    builder: (context, state) {
                      return Container(
                        width: _width,
                        height: _width * 10 / 16,
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: state is ImageState
                            ? Image.file(
                                state.image,
                                fit: BoxFit.fill,
                              )
                            : Center(
                                child: IconButton(
                                  icon: Icon(
                                    Icons.camera_alt,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () async {
                                    await _pickImage();
                                  },
                                ),
                              ),
                      );
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      child: Container(
                        child: TextFormField(
                          key: _formKey,
                          expands: true,
                          maxLines: null,
                          enabled: state is! PostLoadingState,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                              hintText: "What's Happening?",
                              border: InputBorder.none),
                          validator: (text) =>
                              text.isEmpty ? "Caption can't be empty" : null,
                        ),
                      ),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
