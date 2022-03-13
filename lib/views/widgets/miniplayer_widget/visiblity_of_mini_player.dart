import 'package:tune_in/controller/controller.dart';
import 'package:tune_in/exports/exports.dart';

class MiniPlayerObxWidget extends StatelessWidget {
  const MiniPlayerObxWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GetX<PlayerController>(
      builder: (controller) => Visibility(
        replacement: const SizedBox(),
        visible: controller.isplayed.value,
        child: OpenContainer(
          transitionType: ContainerTransitionType.fade,
          transitionDuration: const Duration(milliseconds: 600),
          closedBuilder: (BuildContext ctx, action,) => MiniPlayer(
            width: size.width,
          ),
          openBuilder: (BuildContext context, action) {
            return const NowPlaying();
          },
        ),
      ),
    );
  }
}
