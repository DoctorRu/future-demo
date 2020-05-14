import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:futuredemo/post.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() {
  runApp(MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
//  final String _url = "https://blockchain.info/ticker";
  final String _url = "https://jsonplaceholder.typicode.com";

  Future<List<Post>> _getPosts() async {
    List<Post> posts = List();
    http.Response r = await http.get(_url + "/posts");
    List data = json.decode(r.body);

//    for(var e in data) {
//      Post p = Post(e["userId"], e["id"], e["title"], e["body"]);
//      posts.add(p);
//    };

    data.forEach((e) {
      posts.add(Post(e["userId"], e["id"], e["title"], e["body"]));
    });
    return posts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Future data"),
        ),
        body: FutureBuilder<List<Post>>(
          future: _getPosts(),
          builder: (context, snapshot) {
            String result = "";

            switch (snapshot.connectionState) {
              case ConnectionState.none:
                print("none");
                break;
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
                break;
              case ConnectionState.active:
                print("active");
                break;
              case ConnectionState.done:
                if (snapshot.hasError) {
                  result = "erro ao carregar os dados";
                } else {
                  print("done");
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
//                        List<Post> lista = snapshot.data;
//                        Post post = lista[index];

                        return ListTile(
                            title: Text(snapshot.data[index].title),
                            subtitle: Text(snapshot.data[index].body));
                      });
                }
                break;
            }

            return Center(child: Text(result));
          },
        ));
  }
}
