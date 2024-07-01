import 'package:flutter/material.dart';

class ParallaxedPage extends StatefulWidget {
  const ParallaxedPage({super.key});

  @override
  State<ParallaxedPage> createState() => _ParallaxedPageState();
}

class PagePosition {
  final double page;
  final double position;

  PagePosition(this.page, this.position);
}

class _ParallaxedPageState extends State<ParallaxedPage> {
  final _pageController = PageController(viewportFraction: .8);
  final pageValue = ValueNotifier<PagePosition>(PagePosition(0, 0));

  @override
  void initState() {
    super.initState();
    _pageController.addListener(listen);
  }

  void listen() {
    pageValue.value = PagePosition(
      _pageController.page!,
      _pageController.offset,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 300,
          child: PageView.builder(
            controller: _pageController,
            itemCount: 10,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    width: 300,
                    height: 300,
                    child: ValueListenableBuilder(
                      valueListenable: pageValue,
                      builder: (context, value, child) {
                        double parallaxFactor = 0.5;
                        double xOffset = (value.page - index).clamp(-1.0, 1.0) *
                            parallaxFactor *
                            MediaQuery.of(context).size.width;

                        return FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Transform.translate(
                            offset: Offset(xOffset, 0.0),
                            child: Image.network(
                              'https://picsum.photos/500/200#$index',
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
