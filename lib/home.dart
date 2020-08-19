import 'package:flutter/material.dart';
import'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool loading=true;
  var data;//this variable for nepal data
  var wdata;//this variale is for world
  var news;//this variable for news

  _launchURL(String websiteurl) async {
  var url = '$websiteurl';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

  //creating method for nepal information
  Future getLatestUpdate() async{
    String url="https://nepalcorona.info/api/v1/data/nepal";

    var response=await http.get(url);
    //decoding json data
    var jsondata=json.decode(response.body);

    setState(() {
      data=jsondata;
      loading=false;//eti jsondata data ma gayo vani loading false huney
      
      //print(data);
    });
  }
  //creating method for world information data

  Future getWorldLatestUpdate() async{
    String url="https://data.nepalcorona.info/api/v1/world";

    var response=await http.get(url);
    //decoding json data
    var jsondata=json.decode(response.body);

    setState(() {
      wdata=jsondata;
    
      
      //print(data);
    });
  }

  //creating method for latest news
   Future getLatestNews() async{
    String url="https://nepalcorona.info/api/v1/news";

    var response=await http.get(Uri.encodeFull(url),headers: {'Accept':'application/json'});//this only takes json format
    //decoding json data
    var jsondata=json.decode(response.body);

    setState(() {
      news=jsondata['data'];
    
      
      //print(data);
    });
  }

  void initState(){
    super.initState();
    getLatestUpdate();
    getWorldLatestUpdate();
    getLatestNews(); 
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Corona Status Nepal')
        
      ),
      
      body: loading==true ? Center(child: CircularProgressIndicator(),):SingleChildScrollView(
        child: Column(
          
          children:<Widget>[
            ListTile(
            title:Text('Nepal Informtaion')
          ),
            Row(
              children:<Widget>[
                Expanded(
                  child: Container(
                    //margin: EdgeInsets.all(3.0),
                    color:Colors.blue.shade100,
                    padding: EdgeInsets.all(10.0),
                    alignment: Alignment.center,
                    child: Column(
                      children:<Widget>[
                        Text("Positive cases"),
                        Text(data['tested_positive'].toString()),

                      ],
                    ),

                ),
                ),

                //for recovered cases
                Expanded(
                  child: Container(
                    color:Colors.green.shade100,
                    padding: EdgeInsets.all(10.0),
                    alignment: Alignment.center,
                    child: Column(
                      children:<Widget>[
                        Text("Recovered"),
                        Text(data['recovered'].toString()),

                      ],
                    ),

                ),
                ),

                //for deaths
                Expanded(
                  child: Container(
                    color:Colors.red.shade100,
                    padding: EdgeInsets.all(10.0),
                    alignment: Alignment.center,
                    child: Column(
                      children:<Widget>[
                        Text("Deaths"),
                        Text(data['deaths'].toString()),

                      ],
                    ),

                ),
                ),

              ],
            ),

            SizedBox(height:10.0),



            //second row
            Row(
              children:<Widget>[
                Expanded(
                  child: Container(
                    color:Colors.blue.shade100,
                    padding: EdgeInsets.all(10.0),
                    alignment: Alignment.center,
                    child: Column(
                      children:<Widget>[
                        Text("isolation"),
                        Text(data['in_isolation'].toString()),

                      ],
                    ),

                ),
                ),

                //for recovered cases
                Expanded(
                  child: Container(
                    color:Colors.green.shade100,
                    padding: EdgeInsets.all(10.0),
                    alignment: Alignment.center,
                    child: Column(
                      children:<Widget>[
                        Text("RDT Test"),
                        Text(data['tested_rdt'].toString()),

                      ],
                    ),

                ),
                ),

                //for deaths
                Expanded(
                  child: Container(
                    color:Colors.red.shade100,
                    padding: EdgeInsets.all(10.0),
                    alignment: Alignment.center,
                    child: Column(
                      children:<Widget>[
                        Text("Quarantined"),
                        Text(data['quarantined'].toString()),

                      ],
                    ),

                ),
                ),

              ],
            ),

            //for source
            // Container(
            //   //margin: EdgeInsets.all(19),
            //   //padding: EdgeInsets.all(5),
            //   color:Colors.blue,
            //   child:Text("source"+data['latest_sit_report']['type'])
            // )

            ListTile(
              title:Text('World Information')
            ),

             Row(
              children:<Widget>[
                Expanded(
                  child: Container(
                    color:Colors.blue.shade100,
                    padding: EdgeInsets.all(10.0),
                    alignment: Alignment.center,
                    child: Column(
                      children:<Widget>[
                        Text("Total Cases"),
                        Text(wdata['cases'].toString()),

                      ],
                    ),

                ),
                ),

                //for world recovered cases
                Expanded(
                  child: Container(
                    color:Colors.green.shade100,
                    padding: EdgeInsets.all(10.0),
                    alignment: Alignment.center,
                    child: Column(
                      children:<Widget>[
                        Text("Recovered"),
                        Text(wdata['recovered'].toString()),

                      ],
                    ),

                ),
                ),

                //for world deaths
                Expanded(
                  child: Container(
                    color:Colors.red.shade100,
                    padding: EdgeInsets.all(10.0),
                    alignment: Alignment.center,
                    child: Column(
                      children:<Widget>[
                        Text("Deaths"),
                        Text(wdata['deaths'].toString()),

                      ],
                    ),

                ),
                ),

              ],
            ),

            ListTile(
              title: Text('latest News')
            ),

            //dherai data dekhauna so hamle listview.builder ma rakheko
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: news.length,
              itemBuilder: (context, index){
                return Card(
                  child:Column(children: <Widget>[
                    Image.network(news[index]['image_url']),
                    ListTile(
                      title:Text(news[index]['title'],style: TextStyle(
                        fontWeight:FontWeight.bold,
                      ),),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(news[index]['summary']),
                          OutlineButton(
                            
                            onPressed: (){
                              _launchURL(news[index]['url']);
                            },
                            child: Text('Read More'),
                            )
                        ],
                      ),
                    ),

                  ],
                  ) ,
                  ) ;
              },
              )


          ],
        ),
      ),
      
      
    );
  }
}