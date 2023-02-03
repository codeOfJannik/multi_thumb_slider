/// Defines the behaviour of the most left and most right thumb. If the
/// behaviour is set to [ThumbLockBehaviour.start] or [ThumbLockBehaviour.both],
/// the most left thumb will not be able to be dragged.
/// If the behaviour is set to [ThumbLockBehaviour.end] or
/// [ThumbLockBehaviour.both], the most right thumb will not be able to be dragged.
/// This is the default behaviour.
enum ThumbLockBehaviour {
  /// None of the thumbs will be locked.
  none,

  /// The start/left thumb will be locked.
  start,

  /// The end/right thumb will be locked.
  end,

  /// Both thumbs will be locked.
  /// This is the default behaviour.
  both;

  /// Returns true if the start thumb is locked.
  bool get isStartLocked => this == start || this == both;

  /// Returns true if the end thumb is locked.
  bool get isEndLocked => this == end || this == both;
}
