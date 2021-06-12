import 'package:amrita_quizzes/common_widgets/platform_alert_dialog.dart';
import 'package:amrita_quizzes/common_widgets/platform_exception_alert_dialog.dart';
import 'package:amrita_quizzes/constants/color_constants.dart';
import 'package:amrita_quizzes/constants/strings.dart';
import 'package:amrita_quizzes/models/Quiz.dart';
import 'package:amrita_quizzes/screens/addquiz/add_quiz_screen.dart';
import 'package:amrita_quizzes/screens/details/details_screen.dart';
import 'package:amrita_quizzes/screens/home/components/qr.dart';
import 'package:amrita_quizzes/screens/profile/profile_screen.dart';
import 'package:amrita_quizzes/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'categories.dart';
import 'quiz_card.dart';

class Body extends StatefulWidget {
  final List<Quiz> qList;
  final VoidCallback onRefresh;
  Body(this.qList, this.onRefresh, {Key key}) : super(key: key);

  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<Quiz> quizzes = [];
  String selectedCategory = "";
  int selectedIndex = 0;
  SearchBar searchBar;
  String searchBarText="";
  bool _searching = false;
  int curPage = 0;

  List<Quiz> filterQList(String filter)  {
    List<Quiz> filterQ = [];
    for (var quiz in widget.qList) {
      if(quiz.category == filter) {
        filterQ.add(quiz);
      }
    }
    return filterQ;
  }

  void filterSearch(String searchFilter) {
    searchBarText = searchFilter;
    if(searchFilter == ""){
      _searching = false;
      quizzes =filterQList(selectedCategory);
      setState(() {});
    }
    else{
      List<Quiz> searchQ = [];
      for (var quiz in widget.qList) {
        if(quiz.title.toString().toLowerCase().contains(searchFilter.toLowerCase())) {
          searchQ.add(quiz);
        }
      }
      quizzes = searchQ;
      _searching = true;
      setState(() {});
    }
  }

  callback(newSelectedCategory) {
    setState(() {
      selectedCategory = newSelectedCategory;
      quizzes =filterQList(selectedCategory);

    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.qList.length != 0) {
      selectedCategory = widget.qList[0].category;
    }
    quizzes = filterQList(selectedCategory);
    searchBar = SearchBar(
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onChanged: (value){
          if(value==""){
            filterSearch("");
          }
        },
        onCleared: () {
          filterSearch("");
        },
        onClosed: () {
          filterSearch("");
        },
        onSubmitted: (value){
          filterSearch(value);
        },
        inBar: false
    );
  }

  @override
  Widget build(BuildContext context) {
    //return (widget.qList.length == 0) ?  noQuizzes() : quizDisplay();
    return _buildQuizzes();
  }

  Widget _buildQuizzes(){
    PageController _myPage = PageController(initialPage: 0);
    //Icon menuIcon = Icon(Icons.menu, color: (curPage==0)? Colors.lightBlueAccent: Colors.black);
    //Icon ProfileIcon = Icon(Icons.person, color: (curPage==1)? Colors.lightBlueAccent: Colors.black);
    return Scaffold(
      appBar: searchBar.build(context),
      //body: (quizzes.length==0) ? emptySearch() : quizDisplay(),
      body: PageView(
        controller: _myPage,
        onPageChanged: (pageNum) {
          print('Page Changes to index $pageNum');
          curPage = pageNum;
          if(curPage==1){
            searchBarText="Profile";
          }
          else{
            searchBarText="";
          }
          /*setState(() {
            curPage = pageNum;
          });*/
        },
        children: [
          RefreshIndicator(
              onRefresh: () async {
                widget.onRefresh();
                return;
              },
              child: (quizzes.length==0) ? emptySearch() : quizDisplay()
          ),
          //(quizzes.length==0) ? emptySearch() : quizDisplay(),
          Profile()
        ],
        physics: NeverScrollableScrollPhysics(),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
        backgroundColor: Colors.lightBlueAccent,
        elevation: 4.0,
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddQuizScreen(),
            )
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                onPressed: (){
                  setState(() {
                    _myPage.jumpToPage(0);
                  });
                },
                icon: Icon(Icons.menu, color: (curPage==0)? Colors.lightBlueAccent: Colors.black)
            ),
            IconButton(
                onPressed: (){
                  setState(() {
                    _myPage.jumpToPage(1);
                  });
                },
                icon: Icon(Icons.person, color: (curPage==1)? Colors.lightBlueAccent: Colors.black)
            )
          ],
        ),
      ),
    );
  }

  Widget emptySearch(){
    return Container(
        child: Center(
            child: Text('No Quizzes Found!', style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),)
        )
    );
  }

  Widget noQuizzes() {
    return Scaffold(
        body: Center(
            child: Text('No Quizzes To Take at this moment', style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),)
        )
    );
  }

  Widget quizDisplay(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Visibility(
            visible: _searching,
            child: SizedBox(height: 15,)
        ),
        Visibility(
          visible: !_searching,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
            child: Text(
              "$selectedCategory Quizzes ",
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Visibility(
            visible: !_searching,
            child: Categories(selectedCategory, callback, widget.qList),
        ),
        //Categories(selectedCategory, callback, widget.qList),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
            child: _quizGridView(quizzes),
          ),
        ),
      ],
    );
  }

  GridView _quizGridView(List<Quiz> data) {
    return GridView.builder(
        itemCount: data.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: kDefaultPaddin,
          crossAxisSpacing: kDefaultPaddin,
          childAspectRatio: 0.75 ,
        ),
        itemBuilder: (context, index) => ItemCard(
          quiz_info: data[index],
          press: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailsScreen(
                  mode:1,
                  quiz_info: data[index],
                ),
              )),
        ));
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          _confirmSignOut(context);
        },
      ),
      title: Text(searchBarText),
      actions: <Widget>[
        if(curPage==0)
          searchBar.getSearchAction(context),

        Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: SvgPicture.asset(
                "assets/icons/qr.svg",
                // By default our  icon color is white
                color: kTextColor,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (BuildContext context) => QRViewExample()),
                );
              },
            );
          },
        ),
        SizedBox(width: kDefaultPaddin / 2)
      ],
    );
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final AuthService auth = Provider.of<AuthService>(context, listen: false);
      await auth.signOut();
    } on PlatformException catch (e) {
      await PlatformExceptionAlertDialog(
        title: Strings.logoutFailed,
        exception: e,
      ).show(context);
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final bool didRequestSignOut = await PlatformAlertDialog(
      title: Strings.logout,
      content: Strings.logoutAreYouSure,
      cancelActionText: Strings.cancel,
      defaultActionText: Strings.logout,
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }
}