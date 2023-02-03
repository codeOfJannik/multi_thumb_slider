import 'dart:math';

import 'package:flutter/material.dart';
import 'package:multi_thumb_slider/multi_thumb_slider.dart';

class GradientSliderUsecase extends StatefulWidget {
  GradientSliderUsecase({super.key});

  final List<Color> initialColors = [
    Colors.red,
    Colors.orange,
    Colors.indigo,
  ];

  @override
  State<GradientSliderUsecase> createState() => _GradientSliderUsecaseState();
}

class _GradientSliderUsecaseState extends State<GradientSliderUsecase> {
  List<Color> colors = [];
  List<double> stops = [];
  MultiThumbSliderController controller = MultiThumbSliderController();
  bool coloredThumbs = false;
  bool customBackground = false;

  @override
  void initState() {
    colors = widget.initialColors;
    stops =
        List.generate(colors.length, (index) => index / (colors.length - 1));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gradient Slider Usecase'),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: null,
            backgroundColor: colors.length < 10 ? null : Colors.grey,
            onPressed: colors.length < 10
                ? () {
                    double largestDifference = 0;
                    int largestDifferenceIndex = 0;
                    for (int i = 0; i < stops.length - 1; i++) {
                      final difference = stops[i + 1] - stops[i];
                      if (difference > largestDifference) {
                        largestDifference = difference;
                        largestDifferenceIndex = i;
                      }
                    }
                    final newStop =
                        stops[largestDifferenceIndex] + largestDifference / 2;
                    final randomColor =
                        Color((Random().nextDouble() * 0xFFFFFF).toInt())
                            .withOpacity(1.0);
                    controller.addThumbAtValue(newStop);
                    setState(() {
                      colors.insert(largestDifferenceIndex + 1, randomColor);
                      stops.insert(largestDifferenceIndex + 1, newStop);
                    });
                  }
                : null,
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            heroTag: null,
            backgroundColor: colors.length > 3 ? null : Colors.grey,
            onPressed: colors.length > 3
                ? () {
                    final middleIndex = (colors.length / 2).floor();
                    controller.removeThumbAtIndex(middleIndex);
                    setState(() {
                      colors.removeAt(middleIndex);
                      stops.removeAt(middleIndex);
                    });
                  }
                : null,
            child: const Icon(Icons.remove),
          )
        ],
      ),
      body: ListView(children: [
        Center(
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: List.from(colors),
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: List.from(stops)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: MultiThumbSlider(
            controller: controller,
            lockBehaviour: ThumbLockBehaviour.both,
            valuesChanged: (values) {
              setState(() {
                stops = values;
              });
            },
            initalSliderValues: stops,
            thumbBuilder: coloredThumbs
                ? (context, index) => DefaultThumb(
                      color: colors[index],
                    )
                : null,
            background: customBackground
                ? Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: List.from(colors),
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          stops: List.from(stops)),
                    ),
                  )
                : null,
          ),
        ),
        const SizedBox(height: 8),
        ListTile(
          onTap: () {
            final coloredThumbs = !this.coloredThumbs;
            setState(() {
              this.coloredThumbs = coloredThumbs;
              if (coloredThumbs) {
                customBackground = false;
              }
            });
          },
          leading: Checkbox(
            value: coloredThumbs,
            onChanged: (value) {
              setState(() {
                coloredThumbs = value ?? false;
                if (coloredThumbs) {
                  customBackground = false;
                }
              });
            },
          ),
          title: const Text('Colored Thumbs'),
          subtitle:
              const Text('Check to see how the custom thumb builder works'),
        ),
        ListTile(
          onTap: () {
            final customBackground = !this.customBackground;
            setState(() {
              this.customBackground = customBackground;
              if (customBackground) {
                coloredThumbs = false;
              }
            });
          },
          leading: Checkbox(
            value: customBackground,
            onChanged: (value) {
              setState(() {
                customBackground = value ?? false;
                if (customBackground) {
                  coloredThumbs = false;
                }
              });
            },
          ),
          title: const Text('Custom Background'),
          subtitle: const Text(
              'Check to see what a custom background could look like'),
        ),
      ]),
    );
  }
}
