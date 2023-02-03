import 'package:flutter/material.dart';
import 'package:multi_thum_slider/usecases/gradient_slider_usecase.dart';
import 'package:multi_thum_slider/usecases/overdrag_cross_usecase.dart';
import 'package:multi_thum_slider/usecases/overdrag_move_usecase.dart';
import 'package:multi_thum_slider/usecases/overdrag_stop_usecase.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) => const MaterialApp(
        home: Home(),
      );
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: const Text('Multi Thumb Slider'),
      ),
      body: ListView(
        children: [
          Container(
              height: 36,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: Colors.grey[300],
              child: const Text(
                "Start and End thumbs locked",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              )),
          ...ListTile.divideTiles(color: Colors.grey[500], tiles: [
            ListTile(
              title: const Text("Overdrag Stop"),
              subtitle: const Text("Build with initalSliderValues"),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const OverdragStopUsecase.locked())),
            ),
            ListTile(
              title: const Text("Overdrag Move"),
              subtitle: const Text("Build with initialThumbAmount"),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const OverdragMoveUsecase.locked())),
            ),
            ListTile(
              title: const Text("Overdrag Cross"),
              subtitle: const Text("Build with initialThumbAmount"),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const OverdragCrossUsecase.locked())),
            ),
          ]),
          Container(
              height: 36,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: Colors.grey[300],
              child: const Text(
                "Start and End thumbs not locked",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              )),
          ...ListTile.divideTiles(color: Colors.grey[500], tiles: [
            ListTile(
              title: const Text("Overdrag Stop"),
              subtitle: const Text("Build with initalSliderValues"),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const OverdragStopUsecase.unlocked())),
            ),
            ListTile(
              title: const Text("Overdrag Move"),
              subtitle: const Text("Build with initialThumbAmount"),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const OverdragMoveUsecase.unlocked())),
            ),
            ListTile(
              title: const Text("Overdrag Cross"),
              subtitle: const Text("Build with initialThumbAmount"),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const OverdragCrossUsecase.unlocked())),
            ),
          ]),
          Container(
              height: 36,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              color: Colors.grey[300],
              child: const Text(
                "Custom usecases",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              )),
          ...ListTile.divideTiles(color: Colors.grey[500], tiles: [
            ListTile(
              title: const Text("Gradient Slider"),
              subtitle: const Text(
                  "Example of a gradient editor that uses the MultiThumbSlider to edit the gradient stops"),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GradientSliderUsecase())),
            ),
          ]),
        ],
      ));
}
