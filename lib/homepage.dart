import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:simple_gravatar/simple_gravatar.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  List developersList;

  void showSearchInput() {
    print("keyword search");
  }

  @override
  void initState() {
    super.initState();
    print("has this been called");
    this.getDevelopersList();
  }

  void showOtherListOptions() {
    print("keyword search");
  }

  void doSomething() {
    print("keyword search");
  }

  Future getDevelopersList() async {

    var response = await http.get('https://itpool.network?limit=1000');

    var jsonResponse = jsonDecode(response.body);

    this.setState(() {
      developersList = jsonResponse["data"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Nepal It Pool"),
        leading: new Image(
            image: NetworkImage(
                'https://i0.wp.com/mindbodyshe.com/wp-content/uploads/2018/07/samples-of-logo-designs-sample-of-company-logo-design-ngo-logo-design-samples.jpg?w=600')),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: showSearchInput,
          ),
          IconButton(
            icon: const Icon(Icons.list),
            tooltip: 'More filters',
            onPressed: showOtherListOptions,
          )
        ],
      ),
      body: new ListView.builder(
          itemCount: developersList == null ? 0 : developersList.length,
          itemBuilder: (BuildContext context, int index) {
            String name = developersList[index]["name"];
            String experience = developersList[index]["experience"].toString();
            String skills = developersList[index]["skills"].join(",");
            String email = developersList[index]["email"];
            var gravatar = Gravatar(email);
            var url = gravatar.imageUrl(
              size: 100,
              defaultImage: GravatarImage.retro,
              rating: GravatarRating.pg,
              fileExtension: true,
            );
            return Card(
              child: ListTile(
                  leading: new Image(
                    image: NetworkImage(url),
                  ),
                  title: Text(name),
                  subtitle: Text(
                      experience + ' years of experience skills:' + skills),
                  onTap: () {
                    getDevelopersList();
                  }),
            );
          }),
    );
  }
}
