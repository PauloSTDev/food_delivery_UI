import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_food_delivery_ui/data/data.dart';
import 'package:flutter_food_delivery_ui/models/restaurant.dart';
import 'package:flutter_food_delivery_ui/screens/cart_screen.dart';
import 'package:flutter_food_delivery_ui/screens/restaurant_screen.dart';
import 'package:flutter_food_delivery_ui/widgets/rating_stars.dart';
import 'package:flutter_food_delivery_ui/widgets/recent_orders.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  _buildRestaurants() {
    List<Widget> restaurantList = [];
    restaurants.forEach(
      (Restaurant restaurant) {
        restaurantList.add(
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RestaurantScreen(restaurant: restaurant),
              ),
            ),
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(
                  width: 1.0,
                  color: Colors.grey[200],
                ),
              ),
              child: Row(
                children: <Widget>[
                  Hero(
                    tag: restaurant.imageUrl,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image(
                        height: 150.0,
                        width: 150.0,
                        image: AssetImage(restaurant.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            restaurant.name,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.0),
                          RatingStars(restaurant.rating),
                          Text(
                            restaurant.address,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            "0.2 miles away",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    return Column(
      children: restaurantList,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepOrangeAccent,
        title: Text(
          "Food Delivery App UI",
          style: TextStyle(
            fontSize: 19,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          //Icone de perfil
          icon: Icon(
            Icons.account_circle,
            color: Colors.black,
          ),
          iconSize: 30.0,
          onPressed: () {},
        ),
        actions: <Widget>[
          //TextButton, substituição do FlatButton, botão para o carrinho
          TextButton(
            child: Text(
              "Cart (${currentUser.cart.length})",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
              ),
            ),
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => CartScreen())),
          ),
        ],
      ),
      body: ListView(
        //Lista de Widgets
        children: <Widget>[
          //Campo de pesquisa(Search Bar)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              cursorColor: Colors.black54,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                fillColor: Colors.white,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 0.8, color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(30),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(width: 1.2, color: Colors.deepOrangeAccent),
                  borderRadius: BorderRadius.circular(30),
                ),
                hintText: "Search Food or Restaurants",
                prefixIcon: Icon(
                  Icons.search,
                  size: 30.0,
                  color: Colors.black54,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.black54,
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ),
          //Widget com um list view em colunas dos pedidos recentes
          RecentOrders(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Nearby Restaurants",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              Material(
                child: FutureBuilder(
                  future: _fbApp,
                  builder: (context, snapshot) {
                    print("Dados: "+ snapshot.hasData.toString());
                    if(snapshot.hasError){
                      return Text("Something went Wrong");
                    }
                    else if (snapshot.hasData){
                      return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                              ),
                                onPressed: () {},
                                child: Icon(Icons.update, color: Colors.black),
                            ),
                          ],
                        );
                    }
                    else{
                      Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Container();
                  },
                ),
              ),
              _buildRestaurants(),
            ],
          ),
        ],
      ),
    );
  }
}
