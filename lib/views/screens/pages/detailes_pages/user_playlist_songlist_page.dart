import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tune_in/controller/controller.dart';
import 'package:tune_in/exports/exports.dart';

class Userplaylistsong extends StatelessWidget {
  const Userplaylistsong(
      {Key? key,
      required this.title,
      required this.removeOption,
      required this.isplaylist,
      this.playlistkey})
      : super(key: key);
  final String title;
  final bool removeOption;
  final bool isplaylist;
  final int? playlistkey;
  @override
  Widget build(BuildContext context) {
    final PlayerController controller = Get.find<PlayerController>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_outlined,
          ),
          onPressed: () {
            Get.back(
            );
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(
          0.2,
        ),
        title: Text(
          title,
        ),
        actions: [
          IconButton(
            onPressed: () {
              controller.getRemaingSongsForUserPlaylist();
              currentIcon = add;
              currentIndex = -1;
              Get.to(Addsongpage(
                    playlistkey: playlistkey,
                    title: 'Add song',
                  ),
              );
            },
            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.blueGrey[800],
      body: Obx(
        () {
          controller.getCurrespondingPlaylistSongs(playlistkey!);
          return controller.currespondingPlaylistsong.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 20,
                      ),
                      child: Slidable(
                        endActionPane: ActionPane(
                          motion: const BehindMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (
                                context,
                              ) async {
                                await controller.removeSongFromUserPlaylist(
                                    key: controller
                                        .currespondingPlaylistsong[index]
                                        .currespondingSongDeletingkey,
                                    index: index);
                                controller.currespondingPlaylistSongPath
                                    .clear();
                                for (var item
                                    in controller.currespondingPlaylistsong) {
                                  controller.currespondingPlaylistSongPath.add(
                                    item.songdata!,
                                  );
                                  controller.getPlaylistSongsPaths(
                                    controller.currespondingPlaylistSongPath,
                                  );
                                }
                              },
                              backgroundColor: const Color(
                                0xFFFFFFFF,
                              ).withOpacity(
                                0.5,
                              ),
                              foregroundColor: Colors.red,
                              icon: Icons.delete,
                              label: 'Remove',
                            ),
                          ],
                        ),
                        child: Tile(
                          onTap: () {
                            controller.playlistSongTileClickAction(index);
                          },
                          songImage:
                              controller.currespondingPlaylistsong[index].image,
                          playlist: false,
                          title: controller
                              .currespondingPlaylistsong[index].songname,
                          index: index,
                        ),
                      ),
                    );
                  },
                  itemCount: controller.currespondingPlaylistsong.length,
                )
              : const Center(child: noDatafound);
        },
      ),
      bottomNavigationBar: const MiniPlayerObxWidget(),
    );
  }
}
