import 'package:tune_in/exports/exports.dart';
import 'package:tune_in/controller/controller.dart';

class AlbumSongs extends StatelessWidget {
  const AlbumSongs({Key? key, this.albumname}) : super(key: key);

  final String? albumname;
  @override
  Widget build(BuildContext context) {
    final PlayerController controller = Get.find<PlayerController>();

    //final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.blueGrey[800],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_outlined,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(
          0.2,
        ),
        title: Text(
          albumname!,
        ),
      ),
      //backgroundColor: Colors.black.withOpacity(0),
      body: Column(
        children: [
          Obx(
            () {
              controller.currespodingAlbumSongs.clear();
              controller.albumSongPaths.clear();
              controller.albumPlaylist.clear();
              for (var item in controller.allSongsNotifier) {
                if (item.albums.toString() == albumname.toString()) {
                  AllSongs songs = AllSongs(
                    duration: item.duration,
                    image: item.image,
                    ispinned: item.ispinned,
                    key: item.key,
                    name: item.name,
                    songdata: item.songdata,
                  );
                  controller.currespodingAlbumSongs.add(
                    songs,
                  );
                }
              }
              for (var songpath in controller.currespodingAlbumSongs) {
                controller.albumSongPaths.add(songpath.songdata!);
              }
              return Expanded(
                child: ListView.builder(
                  itemBuilder: (
                    BuildContext context,
                    int index,
                  ) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 20,
                      ),
                      child: Tile(
                          onTap: () {
                            controller.albumTileClickAction(index);
                          },
                          songImage:
                              controller.currespodingAlbumSongs[index].image,
                          playlist: false,
                          title: controller.currespodingAlbumSongs[index].name,
                          index: index),
                    );
                  },
                  itemCount: controller.currespodingAlbumSongs.length,
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: const MiniPlayerObxWidget(),
    );
  }
}
