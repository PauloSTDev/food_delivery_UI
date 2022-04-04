import 'package:flutter/material.dart';
import 'package:flutter_food_delivery_ui/data/firebase_api.dart';
import 'package:flutter_food_delivery_ui/models/firebase_file.dart';
import 'package:flutter_food_delivery_ui/widgets/rating_stars.dart';

class BuildRestaurantsDB extends StatefulWidget {
  @override
  State<BuildRestaurantsDB> createState() => _BuildRestaurantsDBState();
}

class _BuildRestaurantsDBState extends State<BuildRestaurantsDB> {
  Future<List<FirebaseFile>> futureFiles;

  @override
  void initState() {
    super.initState();
    futureFiles = FirebaseApi.listAll("Images/restaurants/");
  }

  @override
  Widget build(BuildContext context) {
    Widget buildFile(BuildContext context, FirebaseFile file) => Row(
          children: <Widget>[

            ClipOval(
              child: Image.network(
                file.url,
                width: 52,
                height: 53,
                fit: BoxFit.cover,
              ),
            ),
          ],
        );

    return Container(
      child: FutureBuilder<List<FirebaseFile>>(
        future: futureFiles,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text("Some error occurred!"),
                );
              } else {
                final files = snapshot?.data;
                return Row(
                  children: [
                    Expanded(
                        child: Container(
                          height: 700,
                          width: 900,
                          margin: EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 10.0,
                          ),
                          child: ListView.builder(
                            itemCount: files.length,
                            itemBuilder: (context, index) {
                              final file = files[index];
                              return buildFile(context, file);
                        },
                      ),
                    ),
                    ),
                  ],
                );
              }
          }
        },
      ),
    );
  }
}
