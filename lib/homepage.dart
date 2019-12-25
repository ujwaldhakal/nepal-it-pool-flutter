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
  bool _sortByExperienceSwitch = false;
  int _popMenuBtn = 0;
  bool _sortByJobSeekingSwitch = false;
  ScrollController _scrollController;
  int totalDevs = 0;
  int currentOffset = 0;
  int limit = 10;

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
          controller: _scrollController,
          itemCount: this.developersList.length,
          itemBuilder: (BuildContext context, index) {

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
                contentPadding: new EdgeInsets.all(20.5),
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


  _scrollListener() async{
    int currentDevsListCount = this.developersList.length;
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {

      print("scroll bottom reached");
      if(totalDevs > currentDevsListCount) {

        this.currentOffset = this.currentOffset + this.limit;
        var url = this.url + '?offset='+this.currentOffset.toString()+'&limit='+this.limit.toString();
        var response = await http.get(url);


        var jsonResponse = jsonDecode(response.body);
        print(url);
        List newDev = jsonResponse["data"];
        newDev = [...this.developersList,...newDev];
        this.setState(() {
          developersList =  newDev;
        });

      }
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);


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

    this.totalDevs = jsonResponse["total"];


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

  handleExperienceSortingToggle(value) {

    this.setState(() {
      this._sortByExperienceSwitch = value;
    }
    );
  }

  Widget sortingWidget() {
    return PopupMenuButton<int>(

      itemBuilder: (context) => [
        PopupMenuItem(
          value : this._popMenuBtn,
          child: SwitchListTile(
            title: const Text('Sort by experience'),
            value: this._sortByExperienceSwitch,
            onChanged: handleExperienceSortingToggle,
          ),
        ),

        PopupMenuItem(
          child: SwitchListTile(
            title: const Text('Sort by job seeking'),
            value: this._sortByJobSeekingSwitch,
            onChanged: (bool value) { setState(() { _sortByJobSeekingSwitch = value; }); },
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
      body: getPageData(),
    );
  }
}
