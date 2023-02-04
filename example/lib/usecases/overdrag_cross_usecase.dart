import 'package:flutter/material.dart';
import 'package:multi_thumb_slider/multi_thumb_slider.dart';

class OverdragCrossUsecase extends StatefulWidget {
  const OverdragCrossUsecase.locked({super.key}) : locked = true;

  const OverdragCrossUsecase.unlocked({super.key}) : locked = false;

  final bool locked;

  @override
  State<OverdragCrossUsecase> createState() => _OverdragCrossUsecaseState();
}

class _OverdragCrossUsecaseState extends State<OverdragCrossUsecase> {
  List<double> sliderValues = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overdrag Cross Usecase'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: MultiThumbSlider.distributed(
                lockBehaviour: widget.locked
                    ? ThumbLockBehaviour.both
                    : ThumbLockBehaviour.none,
                overdragBehaviour: ThumbOverdragBehaviour.cross,
                valuesChanged: (values) =>
                    setState(() => sliderValues = values),
                initialThumbAmount: 5,
              ),
            ),
            Expanded(
                child: Column(children: [
              for (var i = 0; i < sliderValues.length; i++)
                Center(
                    child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text("Thumb $i: ${sliderValues[i]}"))),
            ]))
          ],
        ),
      ),
    );
  }
}
