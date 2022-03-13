import 'package:tune_in/controller/controller.dart';
import 'package:tune_in/exports/exports.dart';

class Albums extends StatelessWidget {
  const Albums({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PlayerController controller = Get.find<PlayerController>();
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Expanded(
          child: Obx(
            () {
              return controller.albumSongNotifier.isEmpty
                  ? Image.asset(
                      r'assets/images/fetch error.png',
                      width: size.width * 0.5,
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: controller.albumSongNotifier.length,
                      itemBuilder: (BuildContext ctx, int index) {
                        final album = controller.albumSongNotifier[index];
                        return Center(
                          child: Bounce(
                            onPressed: () {
                              Get.to(
                                AlbumSongs(
                                  albumname: album.albumname ?? 'Unknown',
                                ),
                              );
                            },
                            duration: const Duration(milliseconds: 110),
                            child: Cards(
                              albumname: album.albumname ?? '',
                              albumimg: album.image,
                              index: index,
                            ),
                          ),
                        );
                      },
                    );
            },
          ),
        ),
      ],
    );
  }
}
