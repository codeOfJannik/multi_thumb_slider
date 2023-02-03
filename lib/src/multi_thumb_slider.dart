import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:multi_thumb_slider/src/multi_thumb_slider_controller.dart';
import 'package:multi_thumb_slider/src/multi_thumb_slider_state.dart';
import 'package:multi_thumb_slider/src/thumb_lock_behaviour.dart';
import 'package:multi_thumb_slider/src/thumb_overdrag_behaviour.dart';

/// Flutter widget that allows to create a slider with multiple thumbs.
///
/// The widget has no size constraints. It will take the size of its parent.
/// The appearance of the slider can be customized by providing a [background],
/// and a [thumbBuilder]. The [thumbBuilder] is called for each thumb and
/// receives the index of the thumb as a parameter. The [background] is
/// displayed behind the thumbs. Both the [background] and the [thumbBuilder]
/// are optional. If not provided, a default background and thumb will be used.
///
/// The [MultiThumbSlider] works only with an amount of thumbs greater than 2.
/// If you want to create a slider with only one thumb, use a [Slider] instead.
/// If you want to create a slider with two thumbs, use a [RangeSlider] instead.
///
/// The thumbs are rendered in a [Stack] widget. The order of the thumbs is
/// determined by the order of the [initalSliderValues]. The thumb with the
/// lowest value is rendered at the bottom of the stack. The thumb with the
/// highest value is rendered at the top of the stack.
///
/// Combined with the [overdragBehaviour] and [lockBehaviour] properties, different
/// thumbs receive the drag events. Check the examples to see how the different
/// properties work together.
class MultiThumbSlider extends StatefulWidget {
  /// Creates a [MultiThumbSlider].
  ///
  /// The count of [initalSliderValues] must be greater than 2. If you want to create
  /// a slider with only one thumb, use a [Slider] instead. If you want to create
  /// a slider with two thumbs, use a [RangeSlider] instead.
  MultiThumbSlider(
      {super.key,
      required this.valuesChanged,
      required List<double> initalSliderValues,
      this.overdragBehaviour = ThumbOverdragBehaviour.stop,
      this.controller,
      this.lockBehaviour = ThumbLockBehaviour.both,
      this.thumbBuilder,
      this.background,
      this.height = 48.0})
      : assert(initalSliderValues.length != 1,
            "Initial slider amount must be greater than 2. Use a Slider instead."),
        assert(initalSliderValues.length != 2,
            "Initial slider amount must be greater than 2. Use a RangeSlider instead."),
        assert(initalSliderValues.length > 2,
            "Initial slider amount must be greater than 2."),
        assert(
          overdragBehaviour != ThumbOverdragBehaviour.move ||
              initalSliderValues.length < 20,
          "Avoid using overdragBehaviour.move with more than 20 thumbs. The performance of your device might drop if too much thums need to be moved at the same time",
        ),
        initialThumbAmount = null,
        initalSliderValues = initalSliderValues
            .sorted((a, b) => a.compareTo(b))
            .map((e) => e.clamp(0.0, 1.0))
            .toList() {
    final initialSliderAmount = initalSliderValues.length;
    if (initialSliderAmount == 1) {
      throw Exception(
          "Initial slider amount must be greater than 2. Use a Slider instead.");
    }
    if (initialSliderAmount == 2) {
      throw Exception(
          "Initial slider amount must be greater than 2. Use a RangeSlider instead.");
    }
    if (initialSliderAmount < 2) {
      throw Exception("Initial slider amount must be greater than 2.");
    }
  }

  /// Creates a [MultiThumbSlider] with a initial amount of thumbs that will be
  /// distributed evenly across the slider.
  ///
  /// The [initialSliderAmount] must be greater than 2. If you want to create a
  /// slider with only one thumb, use a [Slider] instead. If you want to create
  /// a slider with two thumbs, use a [RangeSlider] instead.
  MultiThumbSlider.distributed(
      {super.key,
      required this.valuesChanged,
      required int this.initialThumbAmount,
      this.overdragBehaviour = ThumbOverdragBehaviour.stop,
      this.controller,
      this.lockBehaviour = ThumbLockBehaviour.both,
      this.thumbBuilder,
      this.background,
      this.height = 48.0})
      : assert(initialThumbAmount != 1,
            "Initial slider amount must be greater than 2. Use a Slider instead."),
        assert(initialThumbAmount != 2,
            "Initial slider amount must be greater than 2. Use a RangeSlider instead."),
        assert(initialThumbAmount > 2,
            "Initial slider amount must be greater than 2."),
        assert(
          overdragBehaviour != ThumbOverdragBehaviour.move ||
              initialThumbAmount < 20,
          "Avoid using overdragBehaviour.move with more than 20 thumbs. The performance of your device might drop if too much thums need to be moved at the same time",
        ),
        initalSliderValues = null {
    final thumbAmount = initialThumbAmount;
    if (thumbAmount == null) {
      throw Exception(
          "Initial slider amount cannot be null for this constructor.");
    }
    if (thumbAmount == 1) {
      throw Exception(
          "Initial slider amount must be greater than 2. Use a Slider instead.");
    }
    if (thumbAmount == 2) {
      throw Exception(
          "Initial slider amount must be greater than 2. Use a RangeSlider instead.");
    }
    if (thumbAmount < 2) {
      throw Exception("Initial slider amount must be greater than 2.");
    }
  }

  /// The builder for the thumb. If not provided, a [DefaultThumb] will be used.
  final Widget Function(BuildContext context, int index)? thumbBuilder;

  /// The background of the slider. If not provided, the following container
  /// will be used:
  /// ```dart
  ///
  /// Container(
  ///   height: 4,
  ///   decoration: BoxDecoration(
  ///     color: Colors.grey[400],
  ///     borderRadius: BorderRadius.circular(10.0),
  ///   ),
  /// )
  /// ```
  final Widget? background;

  /// The controller for the slider.
  ///
  /// If not provided, a new controller will be
  /// created. A [MultiThumbSliderController] can be used to add or remove thumbs
  /// from the slider. One [MultiThumbSliderController] can be used only for one
  /// [MultiThumbSlider].
  final MultiThumbSliderController? controller;

  /// Initial value of the slider.
  ///
  /// The length of the list must be greater than 2. If the length is 1, a
  /// [Slider] should be used instead. If the length is 2, a [RangeSlider]
  /// should be used instead.
  ///
  /// The values of the list must be between 0 and 1. Values outside of this
  /// range will be set to 0 or 1.
  /// The values of the list are sorted in ascending order before they are displayed.
  ///
  /// If [inititalSliderValues] is null, the [initialThumbAmount] will be used.
  final List<double>? initalSliderValues;

  /// An initial amount of thumbs that will be distributed evenly across the slider.
  ///
  /// The [initialThumbAmount] must be greater than 2. If you want to create a
  /// slider with only one thumb, use a [Slider] instead. If you want to create
  /// a slider with two thumbs, use a [RangeSlider] instead.
  ///
  /// If [initialThumbAmount] is null, the [initalSliderValues] will be used.
  final int? initialThumbAmount;

  /// The behaviour of the thumbs when they are overdragged.
  ///
  /// Defaults to [ThumbOverdragBehaviour.stop].
  ///
  /// - If [ThumbOverdragBehaviour.move] is used, moving one thumb over another
  /// will move the other thumb as well. This behaviour stacks, so
  /// moving one thumb over another and then over another will move all
  /// thumbs in between. This behaviour can be very resource intensive and
  /// the performance of your device might drop if too much thums need to be
  /// moved at the same time. All indeces of the thumbs will stay the same.
  ///
  /// - If [ThumbOverdragBehaviour.stop] is used, the thumb will stop at the
  /// position of the next or previous thumb. All indeces of the thumbs will
  /// stay the same.
  ///
  /// - If [ThumbOverdragBehaviour.cross] is used, the thumb will be able to move
  /// over other thumbs. All indeces of the thumbs will stay the same, also if
  /// the thumb is moved over another thumb.
  final ThumbOverdragBehaviour overdragBehaviour;

  /// The behaviour of the most left and most right thumb if the user tries to
  /// drag them.
  ///
  /// Defaults to [ThumbLockBehaviour.both].
  ///
  /// - If [ThumbLockBehaviour.both] is used, the most left and most right thumb
  /// will not be able to be dragged.
  ///
  /// - If [ThumbLockBehaviour.left] is used, the most left thumb will not be
  /// able to be dragged.
  ///
  /// - If [ThumbLockBehaviour.right] is used, the most right thumb will not be
  /// able to be dragged.
  ///
  /// - If [ThumbLockBehaviour.none] is used, all thumbs will be able to be
  /// dragged.
  final ThumbLockBehaviour lockBehaviour;

  /// The callback that will be called when any of the thumbs is moved.
  ///
  /// The callback will be called with a list of all values of the thumbs.
  /// The values will be in the range of 0.0 to 1.0. The first value in the list
  /// will be the value of the initial most left thumb and the last value in
  /// the list will be the value of the initial most right thumb.
  ///
  /// If [ThumbOverdragBehaviour.cross] is used, the order of the values might
  /// not match the order of the thumbs on the screen, because the thumbs can
  /// be moved over each other.
  final Function(List<double> values) valuesChanged;

  /// The height of the slider container.
  ///
  /// Defaults to 48.0.
  final double height;

  @override
  MultiThumbSliderState createState() => MultiThumbSliderState();
}
