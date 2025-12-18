import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Autoplay stays false after next() if autoplay is disabled', (tester) async {
    final controller = SwiperController();
    int currentIndex = 0;
    await tester.pumpWidget(MaterialApp(
      home: Swiper(
        controller: controller,
        autoplay: false,
        autoplayDelay: 100, // Short delay for testing
        itemBuilder: (context, index) {
          return Text('$index');
        },
        itemCount: 10,
        onIndexChanged: (index) {
          currentIndex = index;
        },
      ),
    ));

    expect(find.text('0'), findsOneWidget);
    expect(currentIndex, 0);

    // Initial wait to ensure no autoplay starts
    await tester.pump(const Duration(milliseconds: 200));
    expect(currentIndex, 0);

    // Trigger next
    // The controller.next() calls the internal logic.
    // We need to await the Future returned by next() if possible,
    // or just pump enough time for animation.
    controller.next();
    await tester.pumpAndSettle();

    expect(currentIndex, 1);
    expect(find.text('1'), findsOneWidget);

    // Wait for potential autoplay delay (100ms set in widget)
    // If the bug exists, this will trigger another move to index 2
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpAndSettle(); // Allow animation to complete if it triggered

    // Should still be at 1
    expect(currentIndex, 1);
    expect(find.text('1'), findsOneWidget);
  });
}
