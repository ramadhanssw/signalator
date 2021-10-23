import 'package:flutter/material.dart';

class VisualizerColor extends StatelessWidget {
  List<Color> colors = [
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.redAccent,
    Colors.yellowAccent
  ];
  List<int> duration = [900, 700, 600, 800, 500];

  VisualizerColor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List<Widget>.generate(
        18,
        (index) => AudioVisualizer(
          color: colors[index % 4],
          duration: duration[index % 5],
        ),
      ),
    );
  }
}

class AudioVisualizer extends StatefulWidget {
  const AudioVisualizer({Key? key, required this.color, required this.duration})
      : super(key: key);
  final int duration;
  final Color color;

  @override
  _AudioVisualizerState createState() => _AudioVisualizerState();
}

class _AudioVisualizerState extends State<AudioVisualizer>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late Animation<double> animation;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.duration),
    );
    final curvedAnimation = CurvedAnimation(
        parent: animationController, curve: Curves.easeInOutSine);
    animation = Tween<double>(begin: 0, end: 100).animate(curvedAnimation)
      ..addListener(
        () {
          setState(
            () {},
          );
        },
      );
    animationController.repeat(reverse: true);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      width: 10,
      height: animation.value,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
