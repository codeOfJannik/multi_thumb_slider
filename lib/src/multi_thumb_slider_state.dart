import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:multi_thumb_slider/multi_thumb_slider.dart';

/// The state of the [MultiThumbSlider].
///
/// This class is responsible for handling the logic of the slider.
/// It is not meant to be used directly, but rather through the [MultiThumbSlider]
/// widget.
///
/// To update the values of the slider, use the [MultiThumbSliderController].
class MultiThumbSliderState extends State<MultiThumbSlider> {
  /// The controller of the slider.
  MultiThumbSliderController? controller;

  /// The listeners of the values of the slider.
  ///
  ///  These are used to update the thumbs when the [GestureDetector]s are dragged.
  List<ValueNotifier<double>> valueListeners = [];

  @override
  void didUpdateWidget(covariant MultiThumbSlider oldWidget) {
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.dispose();
      controller = widget.controller ?? MultiThumbSliderController();
      controller?.attachToState(this);
    }

    final oldInitialValues = oldWidget.initalSliderValues;
    final newInitialValues = widget.initalSliderValues;

    if (oldInitialValues != null &&
        newInitialValues != null &&
        !oldInitialValues.equals(newInitialValues)) {
      valueListeners.clear();
      _setValueNotifiers();
    }

    final oldInitialThumbAmount = oldWidget.initialThumbAmount;
    final newInitialThumbAmount = widget.initialThumbAmount;
    if (newInitialThumbAmount == null) return;
    if (oldInitialThumbAmount == newInitialThumbAmount) return;
    valueListeners.clear();
    _setValueNotifiers();

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  /// If a controller is not provided, a new one is created.
  /// The controller is then attached to the state.
  @override
  void initState() {
    controller = widget.controller ?? MultiThumbSliderController();
    controller?.attachToState(this);
    _setValueNotifiers();
    super.initState();
  }

  /// Registers the listener for the new value notifier. The value notifier is
  /// then added to the list of value listeners in setState. This adds a new
  /// thumb to the slider.
  void insertThumb(int index, ValueNotifier<double> valueNotifier) {
    valueNotifier.addListener(_notifyParent);
    setState(() {
      valueListeners.insert(index, valueNotifier);
    });
  }

  /// Removes the first thumb and sets the value of the new first thumb to 0.
  void _onRemoveLockedFirst() {
    if (valueListeners.length == 1) return;
    final listenerToRemove = valueListeners.first;
    listenerToRemove.dispose();
    setState(() {
      valueListeners.removeAt(0);
      valueListeners.first.value = 0;
    });
  }

  /// Removes the last thumb and sets the value of the new last thumb to 1.
  void _onRemoveLockedLast() {
    if (valueListeners.length == 1) return;
    final listenerToRemove = valueListeners.last;
    listenerToRemove.dispose();
    setState(() {
      valueListeners.removeLast();
      valueListeners.last.value = 1;
    });
  }

  /// Removes the thumb at the given [index].
  ///
  /// If the thumb is the first or last thumb and that thumb is locked
  /// the second thumb or the second last thumb is set to 0 or 1 respectively.
  /// So removing the first thumb or last thumb when locked will effectively
  /// remove the second thumb or second last thumb.
  void removeThumb(int index) {
    if (index == 0 && widget.lockBehaviour.isStartLocked) {
      _onRemoveLockedFirst();
      return;
    }

    if (index == valueListeners.length - 1 &&
        widget.lockBehaviour.isEndLocked) {
      _onRemoveLockedLast();
      return;
    }

    valueListeners[index].dispose();
    setState(() => valueListeners.removeAt(index));
  }

  /// Callback for when the user starts dragging a thumb.
  ///
  /// The [index] is the index of the thumb that is being dragged and maps to a
  /// value notifier. The [details] are the details of the drag event.
  ///
  /// This method is called by the [GestureDetector]'s [onHorizontalDragUpdate].
  /// Based on the [ThumbLockBehaviour] it's checked if the thumb is locked.
  ///
  /// If it's not locked the new value is calculated.
  /// Based on the [ThumbOverdragBehaviour] the new value is then handled.
  void _handleDragUpdate(int index, DragUpdateDetails details) {
    if (index == 0 && widget.lockBehaviour.isStartLocked) return;
    if (index == valueListeners.length - 1 &&
        widget.lockBehaviour.isEndLocked) {
      return;
    }

    final valueListener = valueListeners[index];
    final contextSize = context.size;
    if (contextSize == null) return;
    final dragDelta = details.delta.dx / contextSize.width;
    double newValue = valueListener.value + dragDelta;
    if (newValue < 0) {
      newValue = 0;
    } else if (newValue > 1) {
      newValue = 1;
    }

    switch (widget.overdragBehaviour) {
      case ThumbOverdragBehaviour.stop:
        _handleDragUpdateStop(index, newValue);
        break;
      case ThumbOverdragBehaviour.move:
        _handleDragUpdateMove(index, newValue);
        break;
      case ThumbOverdragBehaviour.cross:
        _handleDragUpdateCross(index, newValue);
        break;
    }
  }

  /// Returns the value for the given index.
  ///
  /// If the index is the first or last index and the thumb is locked, the value
  /// is set to 0 or 1 respectively.
  double _getValueForIndex(int index, List<double> initialValues) {
    if (widget.lockBehaviour.isStartLocked && index == 0) return 0;
    if (widget.lockBehaviour.isEndLocked && index == initialValues.length - 1) {
      return 1;
    }
    return initialValues[index];
  }

  /// Creates value notifiers for the initial slider amount/initial slider values.
  ///
  /// The value notifiers are then added to the list of value listeners.
  /// The change listener of the value notifier is set to [_notifyParent].
  ///
  /// If the initial thumb amount is set the inital values are calculated so
  /// that the thumbs are evenly distributed.
  void _setValueNotifiers() {
    final initalSliderValues = widget.initalSliderValues;
    final sliderAmount = widget.initialThumbAmount;

    if (initalSliderValues != null && initalSliderValues.isNotEmpty) {
      for (int i = 0; i < initalSliderValues.length; i++) {
        final valueForIndex = _getValueForIndex(i, initalSliderValues);
        final valueNotifier = ValueNotifier(valueForIndex);
        valueNotifier.addListener(_notifyParent);
        valueListeners.add(valueNotifier);
      }
      return;
    }

    if (sliderAmount == null) return;
    for (int i = 0; i < sliderAmount; i++) {
      final valueNotifier = ValueNotifier(i / (sliderAmount - 1));
      valueNotifier.addListener(_notifyParent);
      valueListeners.add(valueNotifier);
    }
  }

  /// Callback for when the user drags a thumb to notify the parent.
  void _notifyParent() {
    widget.valuesChanged(valueListeners.map((e) => e.value).toList());
  }

  /// If [ThumbOverdragBehaviour.move] is set and the thumb is moved in negative
  /// direction.
  ///
  /// If the thumb is moved over any previous thumbs, the previous thumbs are
  /// moved to the [newValue].
  void _moveLeftIfSmaller(int index, double newValue) {
    for (int i = index - 1; i >= 0; i--) {
      final nextValueListener = valueListeners[i];
      if (nextValueListener.value > newValue) {
        nextValueListener.value = newValue;
      }
    }
  }

  /// If [ThumbOverdragBehaviour.move] is set and the thumb is moved in positive
  /// direction.
  ///
  /// If the thumb is moved over any next thumbs, the next thumbs are moved to
  /// the [newValue].
  void _moveRightIfLarger(int index, double newValue) {
    for (int i = index + 1; i < valueListeners.length; i++) {
      final nextValueListener = valueListeners[i];
      if (nextValueListener.value < newValue) {
        nextValueListener.value = newValue;
      }
    }
  }

  /// If [ThumbOverdragBehaviour.move] is set, this method is called to handle
  /// the drag.
  ///
  /// The [index] is the index of the thumb that is being dragged and maps to a
  /// value notifier. The [newValue] is the new position of the thumb. The new
  /// position is compared to the previous position to determine if the thumb is
  /// moved in positive or negative direction. Based on the direction the
  /// [_moveLeftIfSmaller] or [_moveRightIfLarger] method is called.
  void _handleDragUpdateMove(int index, double newValue) {
    final valueListener = valueListeners[index];
    final oldValue = valueListener.value;
    valueListener.value = newValue;
    if (newValue > oldValue) {
      _moveRightIfLarger(index, newValue);
    } else {
      _moveLeftIfSmaller(index, newValue);
    }
  }

  /// If [ThumbOverdragBehaviour.stop] is set, this method is called to handle
  /// the drag.
  ///
  /// The [index] is the index of the thumb that is being dragged and maps to a
  /// value notifier. The [newValue] is the new position of the thumb. The value
  /// of the new position is compared to the max and min values. Those values
  /// are the values of the previous and next thumb to avoid that the thumbs
  /// overlap. If the new value is smaller than the min value, the min value is
  /// set. If the new value is larger than the max value, the max value is set.
  /// Otherwise the new value is set.
  void _handleDragUpdateStop(int index, double newValue) {
    final valueListener = valueListeners[index];
    final double minValue = index != 0 ? valueListeners[index - 1].value : 0;
    final double maxValue = index != valueListeners.length - 1
        ? valueListeners[index + 1].value
        : 1;

    if (newValue > maxValue) {
      valueListener.value = maxValue;
      return;
    }

    if (newValue < minValue) {
      valueListener.value = minValue;
      return;
    }

    valueListener.value = newValue;
  }

  /// If [ThumbOverdragBehaviour.cross] is set, this method is called to handle
  /// the drag.
  /// The [index] is the index of the thumb that is being dragged and maps to a
  /// value notifier. The [newValue] is the new position of the thumb. The value
  /// of the value notifier is set to the new value.
  void _handleDragUpdateCross(int index, double newValue) {
    final valueListener = valueListeners[index];
    valueListener.value = newValue;
  }

  /// Check if the thumb at [index] should ignore gestures.
  ///
  /// There are three cases where the thumb should ignore gestures:
  /// 1. The thumb is the first thumb and the start thumb is locked.
  /// 2. The thumb is the last thumb and the end thumb is locked.
  /// 3. The thumb is all the way to the right, the [ThumbOverdragBehaviour]
  /// is set to [ThumbOverdragBehaviour.stop] and the thumb covers the previous
  /// thumb. This is to avoid that thumbs are in a deadlocked state for
  /// [ThumbOverdragBehaviour.stop].
  bool _ignoreDrag(int index) {
    if (index == 0 && widget.lockBehaviour.isStartLocked) {
      return true;
    }
    if (index == valueListeners.length - 1 &&
        widget.lockBehaviour.isEndLocked) {
      return true;
    }

    if (widget.overdragBehaviour != ThumbOverdragBehaviour.stop) return false;
    final currentValue = valueListeners[index].value;

    if (currentValue > 0.98) {
      final previousValue = valueListeners[index - 1].value;
      return currentValue - previousValue < 0.02;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final thumbBuilder = widget.thumbBuilder;
    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          Center(
            child: widget.background ??
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
          ),
          ...valueListeners.mapIndexed((index, valueListener) {
            final handle = GestureDetector(
                behavior: HitTestBehavior.translucent,
                onHorizontalDragUpdate: (details) =>
                    _handleDragUpdate(index, details),
                child: thumbBuilder != null
                    ? thumbBuilder.call(context, index)
                    : const DefaultThumb());
            return Positioned.fill(
              child: AnimatedBuilder(
                animation: valueListener,
                builder: (context, child) {
                  return Align(
                    alignment: Alignment(valueListener.value * 2 - 1, .5),
                    child: IgnorePointer(
                        ignoring: _ignoreDrag(index), child: child),
                  );
                },
                child: handle,
              ),
            );
          }).toList()
        ],
      ),
    );
  }
}
