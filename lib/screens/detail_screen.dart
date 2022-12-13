import 'dart:convert';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import '../model/house_detail.dart';
import '../model/house_list_model.dart';
import 'package:http/http.dart' as http;

class DetailScreen extends StatefulWidget {
  DetailScreen({required this.productUid});
  final String productUid;
//  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  String features = '';
  int activeIndex = 0;
  final CarouselController _controller = CarouselController();
  final value = new NumberFormat("#,##0.00",
      "en_US"); // a variables used to format a number in correct format
  Future<DetailHouseList?>? houseDetail;
  Future<DetailHouseList?>? getData(var publicId) async {
    try {
      var uri =
          // ignore: prefer_adjacent_string_concatenation
          'https://betdelala-test-app-qxo8x.ondigitalocean.app/public/property/detail/$publicId';
      //final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        return DetailHouseList.fromJson(jsonResponse);
      } else {
        print(response.statusCode);
        print('The status code error :invalid response recived');
      }
    } catch (error) {
      print('This is an error :$error');
    }
    return null;
  }

  @override
  initState() {
    houseDetail = getData(widget.productUid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // houseDetail!.then(
    //   (value) {
    //     setState(() {
    //       getdata = value;
    //     });
    //   },
    // );

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(getdata!.title),
      // ),
      body: FutureBuilder<DetailHouseList?>(
          future: houseDetail,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              int len = snapshot.data!.propertyImagesList.length;
              String convertUTF8(String value) {
                var utf8Runes = value.runes.toList();
                return const Utf8Decoder().convert(utf8Runes);
              }

              for (int i = 0;
                  i < snapshot.data!.propertyFeaturesList.length;
                  i++) {
                features += snapshot.data!.propertyFeaturesList[i].name +
                    (i + 1 == snapshot.data!.propertyFeaturesList.length
                        ? ''
                        : ', ');
              }
              return Container(
                  height: double.infinity,
                  width: double.infinity,
                  // ignore: prefer_const_constructors
                  margin: EdgeInsets.fromLTRB(15, 25, 15, 20),
                  decoration: BoxDecoration(border: Border.all(width: 2)),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.fromLTRB(360, 10, 0, 0),
                          child: const Text(
                            'Contact Agent',
                            style: TextStyle(fontSize: 22, color: Colors.blue),
                          ),
                        ),
                        Container(
                          //height: 300,
                          //margin: const Ed
                          //geInsets.fromLTRB(150, 0, 0, 0),
                          //margin: const EdgeInsets.only(top: 0),

                          //scrollDirection: Axis.horizontal,

                          child: Stack(children: [
                            CarouselSlider.builder(
                              itemCount:
                                  snapshot.data!.propertyImagesList.length,
                              options: CarouselOptions(
                                  height: 300,
                                  autoPlay: false,
                                  viewportFraction: 1,
                                  onPageChanged: ((index, reason) {
                                    setState(() {
                                      activeIndex = index;
                                    });
                                  })),
                              itemBuilder: ((context, index, realIndex) {
                                return SizedBox(
                                    height: 300,
                                    width: double.infinity,
                                    child:
                                        // boxFit: BoxFit.cover,

                                        Image.network(
                                      snapshot
                                          .data!.propertyImagesList[index].url,
                                      fit: BoxFit.cover,
                                    ));
                              }),
                            ),
                            Positioned(
                              //left: 10,
                              right: 50,
                              left: 50,
                              bottom: 5,
                              child: Container(
                                // decoration: BoxDecoration(
                                //   boxShadow: [
                                //     BoxShadow(
                                //       color: Colors.black54
                                //     )
                                //   ]
                                // ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: snapshot.data!.propertyImagesList
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    return GestureDetector(
                                      onTap: () =>
                                          _controller.animateToPage(entry.key),
                                      child: Container(
                                        width: 18.0,
                                        height: 18.0,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 0.2, horizontal: 6.0),
                                        decoration: BoxDecoration(
                                            // ignore: prefer_const_literals_to_create_immutables

                                            shape: BoxShape.circle,
                                            color:
                                                (Theme.of(context).brightness ==
                                                            Brightness.dark
                                                        ? Colors.white
                                                        : Colors.white)
                                                    .withOpacity(
                                                        activeIndex == entry.key
                                                            ? 0.9
                                                            : 0.4)),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ]),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: Text(
                                '${value.format(snapshot.data!.price)} ${snapshot.data!.enumCurrencyType}',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              '${snapshot.data!.bedrooms}bds | ${snapshot.data!.bathrooms}ba |${value.format(snapshot.data!.area)} sq m',
                              style: const TextStyle(
                                //fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 20,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: Text(
                            '${snapshot.data!.addressLookups!.subCity}, ${snapshot.data!.addressLookups!.city}',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 27,
                              fontWeight: FontWeight.normal,
                            ),
                            //textAlign: TextAlign.end,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: const Text(
                              'Specification :',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              margin: const EdgeInsets.fromLTRB(30, 3, 0, 3),
                              child: Text(
                                'Built year : ${snapshot.data!.yearBuilt}',
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(30, 3, 0, 3),
                              child: const Text(
                                'Type : House',
                                style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(30, 3, 0, 3),
                              child: Text(
                                'Size : ${snapshot.data!.area} square meter',
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(30, 3, 0, 3),
                              child: Text(
                                'Bath : ${snapshot.data!.bathrooms}',
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(30, 3, 0, 3),
                              child: Text(
                                'Garage : ${snapshot.data!.parkingSpace} car',
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(30, 3, 0, 0),
                                    child: const Text(
                                      'Features :',
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.normal),
                                    )),
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  child: Text(
                                    features,
                                    maxLines: 5,
                                    //overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.justify,
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.normal),
                                  ),
                                )),

                                // Container(
                                //   width: 200,
                                //   margin:
                                //       const EdgeInsets.fromLTRB(150, 0, 0, 0),
                                //   child: ListView.builder(
                                //       padding:
                                //           const EdgeInsets.only(right: 10),
                                //       shrinkWrap: true,
                                //       scrollDirection: Axis.horizontal,
                                //       itemCount: snapshot
                                //           .data!.propertyFeaturesList.length,
                                //       itemBuilder: ((context, index) {
                                //         return Text(
                                //           (' ${snapshot.data!.propertyFeaturesList[index].name},'),
                                //           style: const TextStyle(
                                //               fontSize: 22,
                                //               fontWeight: FontWeight.normal),
                                //         );
                                //       })),
                                // ),
                              ],
                            ),
                            Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: const Text(
                                  'Description :',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              margin: const EdgeInsets.fromLTRB(30, 3, 0, 3),
                              child: Text(
                                ' ${convertUTF8(snapshot.data!.description)}',
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.normal),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ));
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
