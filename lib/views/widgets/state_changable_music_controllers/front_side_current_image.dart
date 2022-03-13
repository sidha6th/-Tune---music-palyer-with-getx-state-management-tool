import 'package:tune_in/controller/controller.dart';
import 'package:tune_in/exports/exports.dart';

class FrontSideSongImage extends StatelessWidget {
  const FrontSideSongImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
        final PlayerController controller = Get.find<PlayerController>();
    return ValueListenableBuilder(
      valueListenable: controller.currentSongImageNotifier,
      builder: (context, dynamic value, child) {
        return QueryArtworkWidget(
          artworkHeight: MediaQuery.of(context).size.height * 0.1,
          artworkWidth: MediaQuery.of(context).size.width * 0.13,
          nullArtworkWidget: ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: Image(
              width: MediaQuery.of(context).size.width * 0.13,
              height: MediaQuery.of(context).size.height * 0.1,
              image: const AssetImage('assets/images/DefaultMusicImg.png'),
            ),
          ),
          id: value,
          type: ArtworkType.AUDIO,
          artworkBorder: BorderRadius.circular(5),
        );
      },
    );
  }
}
