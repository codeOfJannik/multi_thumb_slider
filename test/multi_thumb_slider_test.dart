import 'package:flutter_test/flutter_test.dart';
import 'package:multi_thumb_slider/multi_thumb_slider.dart';

void main() {
  group('MultiThumbSlider constructor with initalSliderValues', () {
    test('Correct input', () {
      var multiThumbSlider = MultiThumbSlider(
        valuesChanged: (values) {},
        initalSliderValues: const [1.0, 2.0, 3.0],
      );
      expect(multiThumbSlider, isNotNull);
    });
    test('Initial slider amount less than 2', () {
      expect(
          () => MultiThumbSlider(
                valuesChanged: (values) {},
                initalSliderValues: const [1.0],
              ),
          throwsAssertionError);
    });

    test('Initial slider amount equal to 2', () {
      expect(
          () => MultiThumbSlider(
                valuesChanged: (values) {},
                initalSliderValues: const [1.0, 2.0],
              ),
          throwsAssertionError);
    });

    test(
        'OverdragBehaviour = ThumbOverdragBehaviour.move and more than 20 thumbs',
        () {
      expect(
          () => MultiThumbSlider(
                valuesChanged: (values) {},
                initalSliderValues:
                    List.generate(21, (index) => index.toDouble()),
                overdragBehaviour: ThumbOverdragBehaviour.move,
              ),
          throwsAssertionError);
    });

    test("Test sorted and map function", () {
      List<double> initialValues = [0.3, 0.5, 0.2, 0.8];
      MultiThumbSlider slider = MultiThumbSlider(
        valuesChanged: (List<double> values) {},
        initalSliderValues: initialValues,
      );
      List<double> expectedValues = [0.2, 0.3, 0.5, 0.8];
      expect(slider.initalSliderValues, expectedValues);
    });

    test("Test clamp function", () {
      List<double> initialValues = [0.3, 0.5, -0.2, 2.8];
      MultiThumbSlider slider = MultiThumbSlider(
        valuesChanged: (List<double> values) {},
        initalSliderValues: initialValues,
      );
      List<double> expectedValues = [0.0, 0.3, 0.5, 1.0];
      expect(slider.initalSliderValues, expectedValues);
    });

    test("initial slider values sorted and clamped", () {
      final values = [0.5, -0.5, 2.0, 1.0];
      MultiThumbSlider slider = MultiThumbSlider(
        valuesChanged: (List<double> values) {},
        initalSliderValues: values,
      );

      final expectedValues = [0.0, 0.5, 1.0, 1.0];
      expect(slider.initalSliderValues, expectedValues);
    });
  });

  group('MultiThumbSlider.distributed constructor', () {
    test('Correct input', () {
      var multiThumbSlider = MultiThumbSlider.distributed(
        valuesChanged: (values) {},
        initialThumbAmount: 3,
      );
      expect(multiThumbSlider, isNotNull);
    });
    test('Initial thumb amount equal to 2', () {
      expect(
          () => MultiThumbSlider.distributed(
                valuesChanged: (values) {},
                initialThumbAmount: 2,
              ),
          throwsAssertionError);
    });

    test('Initial thumb amount equal to 1', () {
      expect(
          () => MultiThumbSlider.distributed(
                valuesChanged: (values) {},
                initialThumbAmount: 1,
              ),
          throwsAssertionError);
    });

    test('Initial thumb amount less than 2', () {
      expect(
          () => MultiThumbSlider.distributed(
                valuesChanged: (values) {},
                initialThumbAmount: 0,
              ),
          throwsAssertionError);
    });

    test(
        'OverdragBehaviour = ThumbOverdragBehaviour.move and more than 20 thumbs',
        () {
      expect(
          () => MultiThumbSlider.distributed(
                valuesChanged: (values) {},
                initialThumbAmount: 21,
                overdragBehaviour: ThumbOverdragBehaviour.move,
              ),
          throwsAssertionError);
    });
  });
}
