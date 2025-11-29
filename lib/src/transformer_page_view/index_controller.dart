import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

abstract class IndexControllerEventBase {
  IndexControllerEventBase({
    required this.animation,
    required this.needToResetTimer,
  });

  final bool animation;
  final bool needToResetTimer;

  final completer = Completer<void>();
  Future<void> get future => completer.future;
  void complete() {
    if (!completer.isCompleted) {
      completer.complete();
    }
  }
}

mixin TargetedPositionControllerEvent on IndexControllerEventBase {
  double get targetPosition;
}
mixin StepBasedIndexControllerEvent on TargetedPositionControllerEvent {
  int get step;
  int calcNextIndex({
    required int currentIndex,
    required int itemCount,
    required bool loop,
    required bool reverse,
  }) {
    var cIndex = currentIndex;
    if (reverse) {
      cIndex -= step;
    } else {
      cIndex += step;
    }

    if (!loop) {
      if (cIndex >= itemCount) {
        cIndex = itemCount - 1;
      } else if (cIndex < 0) {
        cIndex = 0;
      }
    }
    return cIndex;
  }
}

class NextIndexControllerEvent extends IndexControllerEventBase
    with TargetedPositionControllerEvent, StepBasedIndexControllerEvent {
  NextIndexControllerEvent({
    required bool animation,
    bool needToResetTimer = false,
  }) : super(
          animation: animation,
          needToResetTimer: needToResetTimer,
        );

  @override
  int get step => 1;

  @override
  double get targetPosition => 0;
}

class PrevIndexControllerEvent extends IndexControllerEventBase
    with TargetedPositionControllerEvent, StepBasedIndexControllerEvent {
  PrevIndexControllerEvent({
    required bool animation,
    bool needToResetTimer = false,
  }) : super(
          animation: animation,
          needToResetTimer: needToResetTimer,
        );
  @override
  int get step => -1;

  @override
  double get targetPosition => 1;
}

class MoveIndexControllerEvent extends IndexControllerEventBase
    with TargetedPositionControllerEvent {
  MoveIndexControllerEvent({
    required this.newIndex,
    required this.oldIndex,
    required bool animation,
    bool needToResetTimer = false,
  }) : super(
          animation: animation,
          needToResetTimer: needToResetTimer,
        );
  final int newIndex;
  final int oldIndex;
  @override
  double get targetPosition => newIndex > oldIndex ? 1 : 0;
}

class IndexController extends ChangeNotifier {
  IndexControllerEventBase? event;
  int index = 0;
  Future<void> move(
    int index, {
    bool animation = true,
    bool needToResetTimer = true,
  }) {
    final e = event = MoveIndexControllerEvent(
      animation: animation,
      newIndex: index,
      oldIndex: this.index,
      needToResetTimer: needToResetTimer,
    );
    notifyListeners();
    return e.future;
  }

  Future<void> next({
    bool animation = true,
    bool needToResetTimer = true,
  }) {
    final e = event = NextIndexControllerEvent(
      animation: animation,
      needToResetTimer: needToResetTimer,
    );
    notifyListeners();
    return e.future;
  }

  Future<void> previous({
    bool animation = true,
    bool needToResetTimer = true,
  }) {
    final e = event = PrevIndexControllerEvent(
      animation: animation,
      needToResetTimer: needToResetTimer,
    );
    notifyListeners();
    return e.future;
  }
}
