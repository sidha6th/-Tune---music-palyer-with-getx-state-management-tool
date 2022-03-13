import 'package:tune_in/controller/controller.dart';
import 'package:tune_in/exports/exports.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({Key? key, required this.width}) : super(key: key);
  final double width;

  final String songName = 'song name';
  @override
  Widget build(BuildContext context) {
    final PlayerController controller = Get.find<PlayerController>();
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(
          0.6,
        ),
      ),
      height: MediaQuery.of(context).size.height * 0.08,
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.all(5.0),
            child: FrontSideSongImage(),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      'Now playing',
                    ),
                  ),
                  //======================song name should be show here=================//
                  Expanded(
                    child: Obx(
                      () {
                        return Marquee(
                          text: controller.currentSongNameNotifier.value.isEmpty
                              ? 'Unknown'
                              : controller.currentSongNameNotifier.value,
                          style: TextStyle(
                            fontSize: width * 0.04,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                musicControllerIcon(
                  icon: Icons.skip_previous,
                  builder: () {
                    controller.songprevious();
                  },
                ),
                const Playbutton(isdark: true,),
                musicControllerIcon(
                  icon: Icons.skip_next,
                  builder: () {
                    controller.playnext();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
