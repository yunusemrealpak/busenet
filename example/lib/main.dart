import 'dart:async';

import 'package:busenet/busenet.dart';
import 'package:example/model/post.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Completer<void> initCompleter = Completer<void>();
  late INetworkManager<dynamic> manager;

  bool isLoading = false;
  Post? post;

  bool isError = false;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    initializeManager();
  }

  initializeManager() {
    manager = NetworkManager<EmptyResponseModel>()
      ..initialize(
        NetworkConfiguration('https://jsonplaceholder.typicode.com'),
        responseModel: EmptyResponseModel(),
      ).then((value) => initCompleter.complete());
  }

  Future<void> getPost(BuildContext context) async {
    if (!initCompleter.isCompleted) {
      await initCompleter.future;
    }

    changeLoading(true);

    final response = await manager.fetch<Post, Post>(
      '/posts/1',
      parserModel: Post(),
      type: HttpTypes.get,
    ) as EmptyResponseModel;

    changeLoading(false);

    switch (response.statusCode) {
      case 1:
        setState(() {
          post = response.data as Post;
        });
        break;
      default:
        setState(() {
          isError = true;
          errorMessage = response.errorMessage ?? '';
        });
        break;
    }
  }

  changeLoading(bool val) {
    setState(() {
      isLoading = val;
    });
  }

  clearErrors() {
    setState(() {
      isError = false;
      errorMessage = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading) const Text('is loading'),
            if (post == null)
              const Center(child: Text('No post'))
            else
              Center(
                  child: Text(
                post?.title ?? '',
                textAlign: TextAlign.center,
              )),
            if (isError)
              Center(
                  child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.red),
              )),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            clearErrors();
            getPost(context);
          },
          child: const Icon(Icons.get_app),
        ),
      ),
    );
  }
}
