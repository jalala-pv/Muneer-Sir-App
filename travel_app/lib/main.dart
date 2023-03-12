// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers
import 'package:flutter/foundation.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/detail_page.dart';
import 'package:travel_app/places_page.dart';
import 'package:travel_app/data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
  Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        'placepage': (context) => PlacePages(),
        'detailpage': (context) => DetailPage()
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
    );
  }
}

class Home extends StatelessWidget {
  Home({
    Key? key,
  }) : super(key: key);

  var data = getData();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(),
                Container(
                  child: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () async {
                      await getData0();
                    },
                  ),
                )
              ],
            ), //y

            SizedBox(
              width: width,
              height: height / 3,
              child: PageView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      'placepage',
                      arguments: {
                        'places': data[index]['places'],
                        'name': data[index]['name'],
                      },
                    );
                  },
                  //pageview.builder
                  child: Container(
                    width: width,
                    height: height / 2,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(data[index]['url'].toString()),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(20)),
                    margin: EdgeInsets.symmetric(
                        vertical: height / 400, horizontal: 20),
                    child: Container(
                      alignment: Alignment.bottomLeft,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          Container(),
                          Container(
                              margin: EdgeInsets.all(height / 50),
                              alignment: Alignment.topLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: [
                                  Text(
                                    data[index]['name'].toString(),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  RatingBar.builder(
                                    itemSize: 18,
                                    initialRating: double.parse(
                                        data[index]['rating'].toString()),
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 0.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {},
                                  ),
                                  Text(
                                    data[index]['desc'].toString(),
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.white),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: height / 100, left: 20),
              alignment: Alignment.topLeft,
              child: Text(
                "Places you might like",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
                height: height / 2,
                width: width,
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, 'placepage', arguments: {
                        'name': data[index]['name'],
                        'places': data[index]['places'],
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: height / 100),
                      height: height / 5,
                      decoration: BoxDecoration(),
                      child: Row(
                        children: [
                          Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              height: height / 2,
                              width: width / 3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        data[index]['url'].toString()),
                                    fit: BoxFit.cover),
                              )),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  data[index]['name'].toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                RatingBar.builder(
                                  itemSize: 18,
                                  initialRating: double.parse(
                                      data[index]['rating'].toString()),
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 0.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {},
                                ),
                                Container(
                                  width: width / 2,
                                  child: Text(
                                    data[index]['desc'].toString(),
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  dynamic getData0() async {
    await FirebaseFirestore.instance
        .collection('data')
        .doc('india')
        .set({'place': 'manali'});

    print('search clicked');
  }
}