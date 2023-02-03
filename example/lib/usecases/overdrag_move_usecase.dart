import 'package:flutter/material.dart';
import 'package:multi_thumb_slider/multi_thumb_slider.dart';

class OverdragMoveUsecase extends StatefulWidget {
  const OverdragMoveUsecase.locked({super.key}) : locked = true;

  const OverdragMoveUsecase.unlocked({super.key}) : locked = false;

  final bool locked;

  @override
  State<OverdragMoveUsecase> createState() => _OverdragMoveUsecaseState();
}

class _OverdragMoveUsecaseState extends State<OverdragMoveUsecase> {
  List<double> sliderValues = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overdrag Stop Usecase'),
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
                overdragBehaviour: ThumbOverdragBehaviour.move,
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
