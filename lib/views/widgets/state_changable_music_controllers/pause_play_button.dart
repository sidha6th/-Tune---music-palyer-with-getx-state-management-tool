import 'package:tune_in/exports/exports.dart';
import 'package:tune_in/controller/controller.dart';

class Playbutton extends StatelessWidget {
  const Playbutton({
    required this.isdark,
    Key? key,
  }) : super(key: key);
  final bool isdark;
  @override
  Widget build(BuildContext context) {
    final PlayerController controller = Get.find<PlayerController>();
    return Obx(
      () {
        return controller.isbuttonchanged.value == true
            ? IconButton(
                onPressed: () {
                  controller.songpause();
                },
                icon: const Icon(
                  Icons.pause,
                  size: 35,
                ),
                color: isdark == true ? Colors.black : Colors.white,
              )
            : IconButton(
                onPressed: () {
                  controller.playsong();
                },
                icon: const Icon(
                  Icons.play_arrow,
                  size: 35,
                ),
                color: isdark == true ? Colors.black : Colors.white,
              );
      },
    );
  }
}
