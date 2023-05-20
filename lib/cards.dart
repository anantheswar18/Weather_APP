import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Cards extends StatelessWidget {
  const Cards({
    super.key,
    required this.climate,
    required this.imageurl,
    required this.name,
    required this.unit,
  });

  final num climate;
  final String imageurl;
  final String name;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.12,
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade900,
            offset: Offset(1, 2),
            blurRadius: 3,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image(
              image: AssetImage(
                imageurl,
              ),
              width: MediaQuery.of(context).size.width * 0.05,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            '$name = ${climate.toInt()}  $unit',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}