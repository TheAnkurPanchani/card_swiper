import 'dart:async';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  for (final layout in [
    SwiperLayout.STACK,
    SwiperLayout.TINDER,
    SwiperLayout.CUSTOM,
  ]) {
    testWidgets('$layout ignores a drag started during an animation',
        (tester) async {
      final controller = SwiperController();
      addTearDown(controller.dispose);
      final changes = <int>[];
      await tester.pumpWidget(
        MaterialApp(
          home: Swiper(
            controller: controller,
            layout: layout,
            itemWidth: 300,
            itemHeight: 200,
            itemCount: 5,
            loop: false,
            customLayoutOption:
                CustomLayoutOption(startIndex: -1, stateCount: 3)
                  ..addTranslate(
                      const [Offset(-300, 0), Offset.zero, Offset(300, 0)]),
            onIndexChanged: changes.add,
            itemBuilder: (_, index) => ColoredBox(
              color: Colors.white,
              child: Center(child: Text('Card $index')),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // The first drag starts while a controller animation holds the lock.
      // It must remain ignored when that animation finishes mid-gesture.
      unawaited(controller.next());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      final skipped =
          await tester.startGesture(tester.getCenter(find.byType(Swiper)));
      await skipped.moveBy(const Offset(-40, 0));
      await tester.pump(const Duration(milliseconds: 350));
      await skipped.moveBy(const Offset(-500, 0));
      await skipped.up();
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(changes, [1]);

      // A fresh gesture still works after the rejected drag.
      await tester.drag(find.byType(Swiper), const Offset(-600, 0));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(changes, [1, 2]);

      // Repeat after a valid drag to catch reuse of stale drag coordinates.
      unawaited(controller.previous());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      final stale =
          await tester.startGesture(tester.getCenter(find.byType(Swiper)));
      await stale.moveBy(const Offset(40, 0));
      await tester.pump(const Duration(milliseconds: 350));
      await stale.moveBy(const Offset(500, 0));
      await stale.up();
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(changes, [1, 2, 1]);

      // Canceling an accepted drag must not prevent the next swipe.
      final canceled =
          await tester.startGesture(tester.getCenter(find.byType(Swiper)));
      await canceled.moveBy(const Offset(-40, 0));
      await canceled.moveBy(const Offset(-40, 0));
      await canceled.cancel();
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(changes, [1, 2, 1]);
      await tester.drag(find.byType(Swiper), const Offset(-600, 0));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(changes, [1, 2, 1, 2]);

      await tester.pumpWidget(const SizedBox.shrink());
    });
  }
}
