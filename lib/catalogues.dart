import 'dart:math';
import 'package:flutter/material.dart';
import 'package:simple_search_bar/simple_search_bar.dart';
import 'package:manga_reader/services.dart';
import 'package:manga_reader/Home.dart';
import 'package:manga_reader/catalog_details.dart';
class Catalogues extends StatefulWidget {
  @override
  _CataloguesState createState() => _CataloguesState();
}

class _CataloguesState extends State<Catalogues> {

  List<MaterialColor> _colorItem = [
    Colors.deepOrange,
    Colors.blueGrey,
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.green,
    Colors.yellow,
    Colors.indigo
  ];
  List<Widget> result = [];
  
  List<Widget> buildCatalogs(data,BuildContext context){
    result = [];
    for(var i =0;i<data.length;i++){
      var random = (Random().nextInt(_colorItem.length));
      result.add(
        Padding(
          padding: EdgeInsets.only(left:7.0,right: 7.0),
          child:
            Card(
              elevation: 0.75,
              color: Color.fromRGBO(32, 32, 32, 1),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)
              ),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(
                      data[i].name[0],
                      style: TextStyle(fontSize: 18.0)
                  ),
                  backgroundColor: _colorItem[random],
                ),
                title: Text(
                  data[i].name,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17.0
                  ),
                ),
                trailing: InkWell(
                  onTap: (){
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder:  (c) => CatalogDetails(data[i])
                    ));
                  },
                  child: Text("Explorer",
                  style: TextStyle(
                      color: Colors.blue,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold
                  ),),
                ),
              ),
            )
        )
      );
    }
    return result;
  }
  Future<Null> getRefresh() async{
    await Future.delayed (Duration(seconds:3));
    setState(() {
      getCatalogues();
    });
  }

  final AppBarController appBarController = AppBarController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(
        primary: Color.fromRGBO(32, 32, 32, 1),
        appBarController: appBarController,
        // You could load the bar with search already active
        autoSelected: false,
        searchHint: "Rechercher...",
        mainTextColor: Colors.white,
        onChange: (String value) {
          //Your function to filter list. It should interact with
          //the Stream that generate the final list
        },
        //Will show when SEARCH MODE wasn't active
        mainAppBar: AppBar(
          title: Text("Catalogues"),
          actions: <Widget>[
            InkWell(
              child: Icon(
                Icons.search,
              ),
              onTap: () {
                //This is where You change to SEARCH MODE. To hide, just
                //add FALSE as value on the stream
                appBarController.stream.add(false);
              },
            ),
          ],
        ),
      ),
      drawer: Drawer(
          child: Container(
              color: Color.fromRGBO(28, 28, 28, 1),
              child:ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountEmail: null,
                    accountName: Text("Sherlock Holmes",
                      style: TextStyle(
                          fontSize: 20.0
                      ),),
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(54, 117, 158, 1)
                    ),
                  ),
                  ListTileTheme(
                    selectedColor: Colors.blue,
                    child: ListTile(
                      selected: true,
                      onTap: (){
                        Navigator.of(context).pop();
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder:  (c) => Home()
                        ));
                      },
                      title: Text("Ma bibliothèque",
                        style: TextStyle(
                            fontSize: 17.0,
                            color: Colors.white
                        ),
                      ),
                      leading: Icon(Icons.phone,color: Colors.grey),
                    ),
                  ),

                  ListTile(
                    title: Text("Catalogues",
                      style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.white),),
                    leading: Icon(Icons.photo,color: Colors.grey,),
                  ),
                  ListTile(

                    title: Text("File de téléchargement",
                      style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.white),),
                    leading: Icon(Icons.more,color: Colors.grey),
                  ),
                  ListTile(
                    title: Text("Paramètres",
                      style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.white),),
                    leading: Icon(Icons.settings,color: Colors.grey),
                  ),
                ],
              )
          )
      ),
      body: FutureBuilder(
        future: getCatalogues(),
        builder: (context,snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              color: Color.fromRGBO(20, 20, 20, 1),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return RefreshIndicator(
              onRefresh: getRefresh,
              child: Container(
                  color: Color.fromRGBO(20, 20, 20, 1),
                  child: ListView(
                    children: buildCatalogs(snapshot.data,context),
                  )
              ),
            );
          }
        }
      ),
    );
  }
}
