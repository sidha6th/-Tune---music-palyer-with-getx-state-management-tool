import 'package:tune_in/controller/controller.dart';
import 'package:tune_in/exports/exports.dart';
import 'package:tune_in/views/widgets/state_changable_music_controllers/player_controller_loop_button.dart';
import 'package:tune_in/views/widgets/state_changable_music_controllers/player_controller_shuffle.dart';

class NowplayingController extends StatelessWidget {
  const NowplayingController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PlayerController controller = Get.find<PlayerController>();
    const controllerheight = 50;
    double width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width,
      height: controllerheight.toDouble(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const LoopIcon(),
          IconButton(
            onPressed: () {
              controller.songprevious();
            },
            icon: const Icon(
              Icons.skip_previous,
              size: 40,
            ),
            color: Colors.white,
          ),
          const Playbutton(
            isdark: false,
          ),
          IconButton(
            onPressed: () {
              controller.playnext();
            },
            icon: const Icon(
              Icons.skip_next,
              size: 40,
            ),
            color: Colors.white,
          ),
          const ShuffleIcon(),
        ],
      ),
    );
  }
}
