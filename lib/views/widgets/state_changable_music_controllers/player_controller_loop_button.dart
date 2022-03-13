import 'package:tune_in/exports/exports.dart';
import 'package:tune_in/controller/controller.dart';

Icon icon = const Icon(Icons.repeat, color: Colors.white);

class LoopIcon extends StatefulWidget {
  const LoopIcon({Key? key}) : super(key: key);

  @override
  State<LoopIcon> createState() => _LoopIconState();
}

class _LoopIconState extends State<LoopIcon> {
  final PlayerController controller = Get.find<PlayerController>();
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        if (controller.loop == LoopMode.playlist) {
          controller.loop = LoopMode.single;
          await controller.assetsAudioPlayer.toggleLoop();
          setState(
            () {
              icon = const Icon(
                Icons.repeat_one_rounded,
                color: Colors.blueAccent,
              );
            },
          );
        } else {
          controller.loop = LoopMode.playlist;
          await controller.assetsAudioPlayer.toggleLoop();
          setState(
            () {
              icon = const Icon(Icons.repeat, color: Colors.white);
            },
          );
        }
      },
      icon: icon,
      iconSize: 30,
    );
  }
}
