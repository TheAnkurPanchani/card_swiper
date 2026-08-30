import 'swiper_plugin.dart';
import 'transformer_page_view/index_controller.dart';

class SwipeIndexControllerEvent extends IndexControllerEventBase {
  SwipeIndexControllerEvent({required this.pos, required super.animation})
    : super(needToResetTimer: false);
  final double pos;
}

class BuildIndexControllerEvent extends IndexControllerEventBase {
  BuildIndexControllerEvent({required super.animation, required this.config})
    : super(needToResetTimer: false);
  final SwiperPluginConfig config;
}

class AutoPlaySwiperControllerEvent extends IndexControllerEventBase {
  AutoPlaySwiperControllerEvent({
    required super.animation,
    required this.autoplay,
  }) : super(needToResetTimer: false);

  AutoPlaySwiperControllerEvent.start({required bool animation})
    : this(animation: animation, autoplay: true);
  AutoPlaySwiperControllerEvent.stop({required bool animation})
    : this(animation: animation, autoplay: false);
  final bool autoplay;
}

class SwiperController extends IndexController {
  void startAutoplay({bool animation = true}) {
    event = AutoPlaySwiperControllerEvent.start(animation: animation);
    notifyListeners();
  }

  void stopAutoplay({bool animation = true}) {
    event = AutoPlaySwiperControllerEvent.stop(animation: animation);
    notifyListeners();
  }
}
