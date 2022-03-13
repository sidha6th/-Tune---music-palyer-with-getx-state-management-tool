import 'package:tune_in/exports/exports.dart';
import 'package:tune_in/controller/controller.dart';
// ignore: must_be_immutable
class Sliderclass extends StatefulWidget {
  const Sliderclass({
    Key? key,
  }) : super(key: key);
  @override
  _SliderclassState createState() => _SliderclassState();
}

class _SliderclassState extends State<Sliderclass> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PlayerController>(
      builder: (controller) =>
       Column(
          children: [
            StreamBuilder(
      stream: controller.assetsAudioPlayer.currentPosition,
      builder: (context,asyncSnapshot)=> Slider(
        activeColor: Colors.white,
        inactiveColor: Colors.grey,
        value: controller.currentPosition.inSeconds.toDouble(),
        min: 0.0,
        max: controller.dur.inSeconds.toDouble(),
        onChanged: (double newValue) {
          controller.changeToSeconds(controller.curr.toInt());
          controller.curr = newValue;
          setState(() {
            
          });
        },
      ),
    ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: controller.getDuration(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: controller.totalDuration(),
                )
              ],
            )
          ],
        ),
    );
  }
}
