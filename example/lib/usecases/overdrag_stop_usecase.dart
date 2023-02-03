import 'package:flutter/material.dart';
import 'package:multi_thumb_slider/multi_thumb_slider.dart';

class OverdragStopUsecase extends StatefulWidget {
  const OverdragStopUsecase.locked({super.key}) : locked = true;

  const OverdragStopUsecase.unlocked({super.key}) : locked = false;

  final bool locked;

  @override
  State<OverdragStopUsecase> createState() => _OverdragStopUsecaseState();
}

class _OverdragStopUsecaseState extends State<OverdragStopUsecase> {
  final List<double> initialSliderValues = [0.0, 0.3, 1.0, 0.55, 0.6, 0.65];
  List<double> sliderValues = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overdrag Stop Usecase'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: MultiThumbSlider(
                lockBehaviour: widget.locked
                    ? ThumbLockBehaviour.both
                    : ThumbLockBehaviour.none,
                valuesChanged: (values) =>
                    setState(() => sliderValues = values),
                initalSliderValues: initialSliderValues,
              ),
            ),
            Expanded(
              child: Column(children: [
                for (var i = 0; i < sliderValues.length; i++)
                  Center(
                      child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text("Thumb $i: ${sliderValues[i]}"))),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
