/// Defines the behaviour of the thumb when it is dragged over the previous or
/// next thumb.
enum ThumbOverdragBehaviour {
  /// The thumb will stop at the previous or next thumb.
  /// This is the default behaviour.
  stop,

  /// The thumb will start to move all previous or next thumbs that are overdragged.
  /// For a large amount of thumbs, this can cause performance issues.
  move,

  /// The thumb can be dragged over the previous or next thumb without changing
  /// the position of the previous or next thumb.
  cross;
}
