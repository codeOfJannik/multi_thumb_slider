import 'package:flutter/foundation.dart';
import 'package:multi_thumb_slider/src/multi_thumb_slider_state.dart';
import 'package:multi_thumb_slider/src/thumb_overdrag_behaviour.dart';

/// The controller of the [MultiThumbSlider].
///
/// Using this controller, the state of the slider can be accessed and updated.
/// Make sure that the controller is attached to the state of the slider before
/// using it.
class MultiThumbSliderController {
  /// Creates a new [MultiThumbSliderController].
  MultiThumbSliderController();

  /// The state of the slider.
  MultiThumbSliderState? _attachedState;

  /// Whether the controller is attached to a slider.
  bool get isAttached => _attachedState != null;

  /// Attaches the controller to the state of the slider.
  void attachToState(MultiThumbSliderState state) {
    _attachedState = state;
  }

  /// Detaches the controller from the state of the slider.
  void dispose() {
    _attachedState = null;
  }

  /// Sets the values of the slider.
  ///
  /// The length of the list must be equal to the number of thumbs. If the list
  /// is longer than the number of thumbs, a [RangeError] is thrown.
  /// If the list is shorter than the number of thumbs, the values of the
  /// remaining thumbs are not changed.
  ///
  /// If the controller is not attached to a slider, a [Exception] is thrown.
  void setValues(List<double> values) {
    final attachedState = _attachedState;
    assert(
        attachedState != null,
        "Controller is not attached to a MultiThumbSlider."
        "Do not use the controller before the MultiThumbSlider is built.");

    if (attachedState == null) {
      throw Exception("Controller is not attached to a MultiThumbSlider. Do not"
          "use the controller before the MultiThumbSlider is built.");
    }
    for (int i = 0; i < values.length; i++) {
      attachedState.valueListeners[i].value = values[i];
    }
  }

  /// Returns the values of the slider.
  ///
  /// If the controller is not attached to a slider, a [Exception] is thrown.
  List<double> getValues() {
    final attachedState = _attachedState;
    assert(
        attachedState != null,
        "Controller is not attached to a MultiThumbSlider."
        "Do not use the controller before the MultiThumbSlider is built.");

    if (attachedState == null) {
      throw Exception("Controller is not attached to a MultiThumbSlider. Do not"
          "use the controller before the MultiThumbSlider is built.");
    }

    return attachedState.valueListeners.map((e) => e.value).toList();
  }

  /// Changes the value of the thumb at the given index.
  ///
  /// If the controller is not attached to a slider, a [Exception] is thrown.
  /// If the index is out of bounds, a [RangeError] is thrown.
  void setValueAtIndex(int index, double value) {
    final attachedState = _attachedState;
    assert(
        attachedState != null,
        "Controller is not attached to a MultiThumbSlider."
        "Do not use the controller before the MultiThumbSlider is built.");

    if (attachedState == null) {
      throw Exception("Controller is not attached to a MultiThumbSlider. Do not"
          "use the controller before the MultiThumbSlider is built.");
    }

    attachedState.valueListeners[index].value = value;
  }

  /// Adds a thumb at the given value.
  ///
  /// If the controller is not attached to a slider, a [Exception] is thrown.
  /// If the slider has more than 20 thumbs and the overdrag behaviour is set to
  /// [ThumbOverdragBehaviour.move], you will get a AssertionError, but not an exception.
  /// This is because the performance of the slider will be very bad, but it is
  /// still possible to add more than 20 thumbs in your own risk.
  ///
  /// The new thumb will be added at correct index, so that the list of values
  /// is still sorted.
  int addThumbAtValue(double value) {
    final attachedState = _attachedState;
    assert(
        attachedState != null,
        "Controller is not attached to a MultiThumbSlider."
        "Do not use the controller before the MultiThumbSlider is built.");

    if (attachedState == null) {
      throw Exception("Controller is not attached to a MultiThumbSlider. Do not"
          "use the controller before the MultiThumbSlider is built.");
    }

    assert(
        attachedState.widget.overdragBehaviour != ThumbOverdragBehaviour.move ||
            attachedState.valueListeners.length < 19,
        "Warning: avoid adding more than 20 thumbs when using the move overdrag"
        "behaviour. This will cause performance issues.");

    final valueNotifier = ValueNotifier(value);
    for (int i = 0; i < attachedState.valueListeners.length; i++) {
      final currentValue = attachedState.valueListeners[i].value;
      if (currentValue > value) {
        attachedState.insertThumb(i, valueNotifier);
        return i;
      }
    }
    attachedState.insertThumb(
        attachedState.valueListeners.length, valueNotifier);
    return attachedState.valueListeners.length - 1;
  }

  /// Removes the thumb at the given index.
  ///
  /// If the controller is not attached to a slider, a [Exception] is thrown.
  /// If the index is out of bounds, a [RangeError] is thrown.
  /// If the slider has only 3 thumbs, a [Exception] is thrown. The slider must
  /// have at least 3 thumbs. For less thumbs, use the [Slider] or the
  /// [RangeSlider].
  bool removeThumbAtIndex(int index) {
    final attachedState = _attachedState;
    assert(
        attachedState != null,
        "Controller is not attached to a MultiThumbSlider."
        "Do not use the controller before the MultiThumbSlider is built.");
    if (attachedState == null) {
      throw Exception("Controller is not attached to a MultiThumbSlider. Do not"
          "use the controller before the MultiThumbSlider is built.");
    }
    assert(
        attachedState.valueListeners.length != 3,
        "Cannot remove thumb, only 3 thumbs are left."
        " The slider must have at least 3 thumbs.");
    if (attachedState.valueListeners.length == 3) {
      throw Exception("The slider must have at least 3 thumbs.");
    }

    if (index < 0 || index >= attachedState.valueListeners.length) {
      return false;
    }

    attachedState.removeThumb(index);
    return true;
  }
}
