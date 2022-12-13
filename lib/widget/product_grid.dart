// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';

import 'package:betdelalamobile/model/house_list_model.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:intl/intl.dart';

import '../screens/detail_screen.dart';

class ProductGrid extends StatefulWidget {
  const ProductGrid({super.key});

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  Future<PropertyListModel?>? house;
  final value = new NumberFormat("#,##0.00",
      "en_US"); // a variables used to format a number in correct format

  Future<PropertyListModel?>? getData() async {
    try {
      var uri =
          'https://betdelala-test-app-qxo8x.ondigitalocean.app/public/property-list?page=0&size=18';
      //final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        return PropertyListModel.fromJson(jsonResponse);
      } else {
        print('invalid response recived');
      }
    } catch (error) {
      print('This is an error :$error');
    }
    return null;
  }

  @override
  initState() {
    house = getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final recommendedList = Provider.of<Houses>(context).getData();
    return Scaffold(
        body: FutureBuilder<PropertyListModel?>(
            future: house,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var fetchedContent = snapshot.data!.content;

                return Container(
                  padding: const EdgeInsets.fromLTRB(15, 25, 15, 0),
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(color: Colors.grey.shade300
                        // blurRadius: 15.0, // soften the shadow
                        //spreadRadius: 5.0, //extend the shadow

                        )
                  ]),
                  margin: const EdgeInsets.only(top: 10),
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                      itemCount: snapshot.data!.content.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                       // print('${fetchedContent[index].publicId}');
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => DetailScreen(
                                productUid: fetchedContent[index].publicId,
                              ),
                            ));
                          },
                          child: Container(
                            width: 230,
                            height: 300,
                            margin: const EdgeInsets.only(bottom: 20),
                            //padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    border: const Border(
                                        bottom: BorderSide(width: 10)),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            fetchedContent[index]
                                                .propertyImagesList[0]
                                                .url),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                Positioned(
                                  right: 6,
                                  top: 15,
                                  child: Container(
                                      width: 90,
                                      height: 30,
                                      // padding: const EdgeInsets.all(5),
                                      decoration:
                                          const BoxDecoration(boxShadow: [
                                        BoxShadow(color: Colors.black54
                                            // blurRadius: 15.0, // soften the shadow
                                            //spreadRadius: 5.0, //extend the shadow

                                            )
                                      ]),
                                      child: Text(
                                        'For ${fetchedContent[index].enumContractType}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Colors.white),
                                      )),
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    //margin: EdgeInsets.only(bottom: 50),
                                    padding: const EdgeInsets.all(10),
                                    color: Colors.white,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${value.format(fetchedContent[index].price)} ${fetchedContent[index].enumCurrencyType}',
                                                style: const TextStyle(
                                                  color: Colors.lightGreen,
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                '${fetchedContent[index].bedrooms}bds, ${fetchedContent[index].bathrooms}ba,${value.format(fetchedContent[index].area)} sq m',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.541),
                                                  fontSize: 18,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Icon(Icons.location_on),
                                                  Text(
                                                    '${fetchedContent[index].addressLookups!.city}, ${fetchedContent[index].addressLookups!.subCity}',
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                ]),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            const Text(
                                              'Pending',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                                fontSize: 20,
                                              ),
                                            )
                                          ],
                                        ),
                                        // child: SvgPicture.asset('assets/icons/heart.svg'),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
