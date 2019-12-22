import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:simple_gravatar/simple_gravatar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => new HomePageState();
}

class HomePageState extends State<HomePage> {
  List developersList;
  String url = "https://itpool.network";
  String queryParam = "";
  Widget appText  = new Text("Nepal It Pool");
  bool searchButtonState = false;
  bool LoadingAppState = false;
  bool isSwitched = false;
  void showSearchInput() {
    this.setState(()  {
    this.searchButtonState = true;
    this.appText = new TextFormField(
      cursorColor: Colors.white,
      decoration: InputDecoration(
          hintText: 'Enter a search term'
      ),
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (value) {

        var searchUrl = url + "?name="+value;

        print(searchUrl);
        getDevelopersList(searchUrl);
      },
    );
    });
  }

  Widget getPageData() {
    if(!this.LoadingAppState) {
      return new ListView.builder(
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
//                    getDevelopersList();
                  }),
            );
          });

      }

    return SpinKitRotatingCircle(
      color: Colors.blue,
      size: 50.0,
    );
  }

  @override
  void initState() {
    super.initState();
    print("has this been called");
    print(url);
    this.getDevelopersList(url);
  }

  void showOtherListOptions() {
    print("keyword search");
  }

  void doSomething() {
//    this.setState(()=>{
//      this.appText = new Text("search input here");
//    });
    print("keyword search");
  }


  void removeSearchState() {

    this.setState((){
      this.searchButtonState = false;
      this.appText = new Text("Nepal It Pool");
    });
    getDevelopersList(url);
  }


  Future getDevelopersList(url) async {


    this.setState(() {
      LoadingAppState = true;
    });
    var response = await http.get(url);

    var jsonResponse = jsonDecode(response.body);

    this.setState(() {
      developersList = jsonResponse["data"];
      LoadingAppState = false;
    });
  }

  Widget getSearchButtonState() {
    if(!searchButtonState) {
      return getSearchButton();
    }

    return revertSearchState();

  }

  getSearchButton() {
    return IconButton(
      icon: const Icon(Icons.search),
      tooltip: 'Search',
      onPressed: showSearchInput,
    );
  }

  revertSearchState() {
    return IconButton(
      icon: const Icon(Icons.close),
      tooltip: 'Search',
      onPressed: removeSearchState,
    );
  }

  Widget sortingWidget() {
    return new PopupMenuButton<int>(
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 0,
          child: SwitchListTile(
            title: const Text('Sort by experience'),
            value: false,
            onChanged: (bool value) { setState(() { isSwitched = value; }); },
          ),
        ),
        PopupMenuItem(
          value: 0,
          child: SwitchListTile(
            title: const Text('Sort by job seeking'),
            value: false,
            onChanged: (bool value) { setState(() { isSwitched = value; }); },
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: this.appText,
        leading: new Image(
            image: NetworkImage(
                'https://i0.wp.com/mindbodyshe.com/wp-content/uploads/2018/07/samples-of-logo-designs-sample-of-company-logo-design-ngo-logo-design-samples.jpg?w=600')),
        actions: <Widget>[
          getSearchButtonState(),
          sortingWidget(),
        ],
      ),
      body: getPageData()
    );
  }
}
