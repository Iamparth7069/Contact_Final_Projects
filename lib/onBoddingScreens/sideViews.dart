import 'package:flutter/material.dart';

import '../Model/items.dart';


class sliderViews extends StatelessWidget {
  Item item;
  sliderViews(this.item);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          AspectRatio(
            aspectRatio: 16 / 14,
            child: Image.asset(item.images)
          ),
          SizedBox(
            height: 40,
          ),
          Text(
            item.tital,
            style: const TextStyle(
                color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 16,
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              item.desc,
              textAlign: TextAlign.center,
              maxLines: 3,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
          )

        ],
      ),
    );
  }
}
