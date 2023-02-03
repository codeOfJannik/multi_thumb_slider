import 'package:flutter_test/flutter_test.dart';
import 'package:multi_thumb_slider/src/thumb_lock_behaviour.dart';

void main() {
  group("Test isStartLocked", () {
    test("for .both", () {
      expect(ThumbLockBehaviour.both.isStartLocked, isTrue);
    });

    test("for .start", () {
      expect(ThumbLockBehaviour.start.isStartLocked, isTrue);
    });

    test("for .end", () {
      expect(ThumbLockBehaviour.end.isStartLocked, isFalse);
    });

    test("for .none", () {
      expect(ThumbLockBehaviour.none.isStartLocked, isFalse);
    });
  });

  group("Test isEndLocked", () {
    test("for .both", () {
      expect(ThumbLockBehaviour.both.isEndLocked, isTrue);
    });

    test("for .start", () {
      expect(ThumbLockBehaviour.start.isEndLocked, isFalse);
    });

    test("for .end", () {
      expect(ThumbLockBehaviour.end.isEndLocked, isTrue);
    });

    test("for .none", () {
      expect(ThumbLockBehaviour.none.isEndLocked, isFalse);
    });
  });
}
