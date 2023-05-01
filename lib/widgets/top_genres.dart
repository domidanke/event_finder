import 'dart:math';

import 'package:event_finder/models/consts.dart';
import 'package:flutter/material.dart';

class TopGenres extends StatelessWidget {
  const TopGenres({Key? key, required this.onGenreSelected}) : super(key: key);
  final Function(String genre) onGenreSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            margin: const EdgeInsets.only(left: 12),
            child: const Text(
              'Top Genres Künstler & Events',
              style: TextStyle(fontSize: 18),
            )),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20),
              itemCount: topGenres.length,
              itemBuilder: (BuildContext ctx, index) {
                return GestureDetector(
                  onTap: () {
                    onGenreSelected(topGenres[index].name);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(),
                        color: topGenres[index].color.withOpacity(0.8),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(8))),
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          topGenres[index].name,
                          style: const TextStyle(fontSize: 20),
                        ),
                        Transform.rotate(
                          angle: -pi / 10,
                          child: Image.asset(
                            topGenres[index].imagePath,
                            height: 60,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
