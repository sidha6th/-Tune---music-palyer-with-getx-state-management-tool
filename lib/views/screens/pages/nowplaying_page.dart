import 'package:tune_in/controller/controller.dart';
import 'package:tune_in/exports/exports.dart';

class NowPlaying extends StatelessWidget {
  const NowPlaying(
      {Key? key, this.value = 100.0, this.songName = '', this.songImage})
      : super(key: key);
  final double value;
  final String? songName;
  final dynamic songImage;

  @override
  Widget build(BuildContext context) {
    final PlayerController controller = Get.find<PlayerController>();
    //const controllerheight = 50;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.blueGrey[800],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down_outlined),
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: const Color(0XFFFFFFFF).withOpacity(0.2),
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        centerTitle: true,
        title: const Text('Now Playing'),
      ),
      body: Column(
        children: [
          SizedBox(
            height: height * 0.08,
            child: Center(
              child: Obx(
                () {
                  return controller.currentSongNameNotifier.value.length > 20
                      ? Marquee(
                          text: controller.currentSongNameNotifier.value,
                          style: TextStyle(fontSize: width * 0.050),
                        )
                      : Text(
                          controller.currentSongNameNotifier.value,
                          style: TextStyle(
                            fontSize: width * 0.050,
                          ),
                        );
                },
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
//================here the song image and progress bar controll of the song================//
          const Expanded(
            flex: 2,
            child: CurrentSongImage(),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.08,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (
                          BuildContext context,
                        ) {
                          return controller.getTimer(
                            context,
                          );
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.timer,
                      color: Colors.white,
                    ),
                  ),
                  const ColorChangeIcon()
                ],
              ),
            ),
          ),
          const Sliderclass(),
          const NowplayingController()
          //================need to edit ==============//
        ],
      ),
    );
  }
}
