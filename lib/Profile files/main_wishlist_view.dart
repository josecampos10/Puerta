import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WishlistView extends StatelessWidget {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text(
          'Wishlist View',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CupertinoButton(
              color: Colors.black,
              borderRadius: BorderRadius.circular(15), 
              onPressed: () => Navigator.pushNamed(context, '/detailsWishlist'),
              //onPressed: () {},
              child: Text('Go to details Wishlist')
            )
          ],
        ),
      ),
    );
  }
}