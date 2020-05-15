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

    data.forEach((e) {
      posts.add(Post(e["userId"], e["id"], e["title"], e["body"]));
    });
    return posts;
  }

  _post() async {
    var body = json.encode(
        {"userId": 1, "id": null, "title": "Titúlo 1", "body": "Conteúdo 1"});

    Post p1 = Post(200, 101, "Title 101", "Body 101");
    print(p1);
    print(p1.title);
    print('json encoded:');
    print(json.encode(p1));
    body = json.encode(p1);

    print('to json :');
    print(p1.toJson()); // A diferença é a remoção das aspas

//    http.Response response = await http.post(_url + "/posts",
//        headers: {"Content-type": "application/json; charset=UTF-8"},
//        body: body);
//
//    print("Status ${response.statusCode}");
//    print("Body ${response.body}");
  }

  _put() async {
    var body = json.encode({
      "userId": 1,
      "id": 1,
      "title": "Titúlo atualizado com PUT",
      "body": "Conteúdo atualizado com PUT"
    });

    http.Response response = await http.put(_url + "/posts/1",
        headers: {"Content-type": "application/json; charset=UTF-8"},
        body: body);

    print("Status ${response.statusCode}");
    print("Body ${response.body}");
  }

  _patch() async {
    var body = json.encode({
      "title": "Titúlo atualizado com PATCH",
    });

    http.Response response = await http.patch(_url + "/posts/1",
        headers: {"Content-type": "application/json; charset=UTF-8"},
        body: body);

    print("Status ${response.statusCode}");
    print("Body ${response.body}");
  }

  _delete() async {
    http.Response response = await http.delete(_url + "/posts/1");

    print("Status ${response.statusCode}");
    print("Body ${response.body}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Future data"),
        ),
        body: Container(
            padding: EdgeInsets.all(32),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      color: Colors.red,
                      child: Text(
                        "POST",
                        style: (TextStyle(color: Colors.white, fontSize: 26)),
                      ),
                      onPressed: _post,
                    ),
                    RaisedButton(
                      color: Colors.red,
                      child: Text(
                        "PUT",
                        style: (TextStyle(color: Colors.white, fontSize: 26)),
                      ),
                      onPressed: _put,
                    ),
                    RaisedButton(
                      color: Colors.red,
                      child: Text(
                        "PATCH",
                        style: (TextStyle(color: Colors.white, fontSize: 26)),
                      ),
                      onPressed: _patch,
                    ),
                    RaisedButton(
                      color: Colors.red,
                      child: Text(
                        "DELETE",
                        style: (TextStyle(color: Colors.white, fontSize: 26)),
                      ),
                      onPressed: _delete,
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: FutureBuilder<List<Post>>(
                      future: _getPosts(),
                      builder: (context, snapshot) {
                        String result = "";

                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
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
                                        title: Text(snapshot.data[index].title,
                                            style: TextStyle(fontSize: 20)),
                                        subtitle: Text(
                                            snapshot.data[index].body,
                                            style: TextStyle(fontSize: 20)));
                                  });
                            }
                            break;
                        }

                        return Center(child: Text(result));
                      },
                    ),
                  ),
                )
              ],
            )));
  }
}
