// importamos lo que vamos a necesitar
import 'package:flutter/material.dart';
//import 'package:flutter_application_1/constants/Theme.dart';

class CardCategory extends StatelessWidget {
  CardCategory(
      {this.title = "Placeholder Title",
      this.img = "https://via.placeholder.com/250",
      this.tap = defaultFunc});

  // creamos las varibles
  final String img;
  final Function() tap;
  final String title;

  static void defaultFunc() {
    print("La funcion trabaja");
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 252,
      width: null,
      child: GestureDetector(
        onTap: tap,
        child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6.0)),
            ),
            child: Stack(
              children: [
                Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        image: DecorationImage(
                          image: NetworkImage(img),
                          fit: BoxFit.cover,
                        ))),
                Container(
                    decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.all(Radius.circular(6.0)))),
                Center(
                  child: Text(title,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0)),
                ),
              ],
            )),
      ),
    );
  }
}
