import 'dart:io';

import 'package:dio/dio.dart';
import 'package:simple_feed/api/http_protocol.dart';
import 'package:simple_feed/api/routes.dart';
import 'package:simple_feed/models/post.dart';

class ApiRespository {
  final HttpProtocol _httpProtocol = HttpProtocol();
  Future<Map<String, dynamic>> getPosts({int page}) async {
    Response response =
        await _httpProtocol.get(path: "${Routes.POSTS}/?page=$page");
    return {
      'feed':
          response.data['docs']?.map<Post>((e) => Post.fromJson(e))?.toList(),
      'limit': response.data['pages'],
    };
  }

  Future likePost({String id}) async {
    await _httpProtocol.put(path: "${Routes.POSTS}/like/$id");
    return;
  }

  Future unLikePost({String id}) async {
    await _httpProtocol.put(path: "${Routes.POSTS}/unlike/$id");
    return;
  }

  Future addPost({String caption, File image}) async {
    String imageName = image.path.split('/').last;
    FormData formData = FormData.fromMap(
      {
        'caption': '$caption',
        'image': await MultipartFile.fromFile(image.path, filename: imageName)
      },
    );
    await _httpProtocol.postFiles(
      path: "${Routes.POSTS}",
      data: formData,
    );
    return;
  }
}
