import 'package:card_swiper/card_swiper.dart';
import 'package:material_ui/material_ui.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: InnerSwiper());
  }
}

class InnerSwiper extends StatefulWidget {
  const InnerSwiper({super.key});

  @override
  State<StatefulWidget> createState() {
    return _InnerSwiperState();
  }
}

class _InnerSwiperState extends State<InnerSwiper> {
  late SwiperController controller;

  late List<bool> autoPlayer;

  late List<SwiperController> controllers;

  @override
  void initState() {
    controller = SwiperController();
    autoPlayer = List.generate(10, (index) => false);
    controllers = List.generate(10, (index) => SwiperController());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Swiper(
        loop: false,
        itemCount: 10,
        controller: controller,
        pagination: const SwiperPagination(),
        itemBuilder: (context, index) {
          return Column(
            children: <Widget>[
              SizedBox(
                height: 300.0,
                child: Swiper(
                  controller: controllers[index],
                  pagination: const SwiperPagination(),
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return const ColoredBox(
                      color: Colors.greenAccent,
                      child: Text('jkfjkldsfjd'),
                    );
                  },
                  autoplay: autoPlayer[index],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    autoPlayer[index] = true;
                  });
                },
                child: const Text('Start autoplay'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    autoPlayer[index] = false;
                  });
                },
                child: const Text('End autoplay'),
              ),
              Text('is autoplay: ${autoPlayer[index]}'),
            ],
          );
        },
      ),
    );
  }
}
