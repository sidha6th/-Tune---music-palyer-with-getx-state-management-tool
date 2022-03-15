import 'package:tune_in/exports/exports.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tune_in/controller/controller.dart';

TextEditingController playlistcreation = TextEditingController();

class Library extends StatelessWidget {
  const Library({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    PlayerController controller = Get.find<PlayerController>();

    return Column(
      children: [
        Obx(
          () {
            return controller.allSongsNotifier.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.allSongsNotifier.length,
                    itemBuilder: (
                      ctx,
                      intex,
                    ) {
                      AllSongs song = controller.allSongsNotifier[intex];
                      //custom list tile
                      return Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.02),
                            child: Slidable(
                              endActionPane: ActionPane(
                                motion: const BehindMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (
                                      ctx,
                                    ) {
                                      controller.getRemainingPlaylist(
                                        controller.allSongsNotifier[intex].key!,
                                      );
                                      //=============================================== playlist Adding alert box ===========================================================//
                                      showDialog(
                                        context: context,
                                        builder: (
                                          ctx,
                                        ) {
                                          return AlertDialog(
                                            backgroundColor: Colors.white,
                                            title: Text(
                                              'add to playlist',
                                              style: TextStyle(
                                                fontSize: size.width * 0.05,
                                                color: Colors.black,
                                              ),
                                            ),
                                            content: SizedBox(
                                              width: double.maxFinite,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextField(
                                                    controller:
                                                        playlistcreation,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Get.back(
                                                          );
                                                        },
                                                        child: Text(
                                                          'Not Now',
                                                          style: TextStyle(
                                                            fontSize:
                                                                size.width *
                                                                    0.04,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          if (playlistcreation
                                                              .text
                                                              .trim()
                                                              .isNotEmpty) {
                                                            controller
                                                                .addplaylist(
                                                              playlistname:
                                                                  playlistcreation
                                                                      .text,
                                                              fromlibrary: true,
                                                              songs: song,
                                                            );
                                                            ScaffoldMessenger
                                                                .of(
                                                              ctx,
                                                            ).showSnackBar(
                                                              SnackBar(
                                                                dismissDirection:
                                                                    DismissDirection
                                                                        .horizontal,
                                                                backgroundColor:
                                                                    Colors
                                                                        .blueGrey,
                                                                content: Text(
                                                                  'Song Added successfully',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        size.width *
                                                                            0.02,
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                            Get.back(
                                                            );
                                                          }
                                                          playlistcreation
                                                              .clear();
                                                        },
                                                        child: Text(
                                                          'Create and Add',
                                                          style: TextStyle(
                                                            fontSize:
                                                                size.width *
                                                                    0.04,
                                                            color: Colors.green,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  controller.remainingPlaylists
                                                          .isEmpty
                                                      ? const SizedBox()
                                                      : Text(
                                                          'Playlists',
                                                          style: TextStyle(
                                                            fontSize:
                                                                size.width *
                                                                    0.04,
                                                            color: Colors
                                                                .blueAccent,
                                                          ),
                                                        ),
                                                  Flexible(
                                                    child: ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: controller
                                                          .remainingPlaylists
                                                          .length,
                                                      itemBuilder: (
                                                        BuildContext context,
                                                        int index,
                                                      ) {
                                                        return ListTile(
                                                          leading: const Icon(
                                                            Icons.playlist_add,
                                                            color:
                                                                Colors.blueGrey,
                                                          ),
                                                          onTap: () {
                                                            controller
                                                                .addSongToUserPlaylist(
                                                              controller
                                                                  .playlistNotifier[
                                                                      index]
                                                                  .playlistKey!,
                                                              song,
                                                            );
                                                            ScaffoldMessenger
                                                                .of(
                                                              ctx,
                                                            ).showSnackBar(
                                                              const SnackBar(
                                                                backgroundColor:
                                                                    Colors
                                                                        .blueGrey,
                                                                content: Text(
                                                                  'Song Added successfully',
                                                                ),
                                                                behavior:
                                                                    SnackBarBehavior
                                                                        .floating,
                                                              ),
                                                            );
                                                            Get.back(
                                                            );
                                                          },
                                                          title: Text(
                                                            controller
                                                                .remainingPlaylists[
                                                                    index]
                                                                .playlistName!,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                      //===============================================ends playlist Adding alert box ===========================================================//
                                    },
                                    backgroundColor: const Color(
                                      0xFFFFFFFF,
                                    ).withOpacity(0.5),
                                    foregroundColor: Colors.white,
                                    icon: Icons.add,
                                    label: 'Add',
                                  ),
                                ],
                              ),
                              child: Tile(
                                isLibrary: true,
                                onTap: () {
                                  controller.libraryPageTileClickAction(
                                      song, intex);
                                  Get.to(
                                    NowPlaying(
                                      songImage: song.image,
                                      songName: song.name??'Unknown',
                                    ),
                                  );
                                },isPinned: song.ispinned??false,
                                songImage: song.image,
                                title: song.name??'Unknown',
                                index: intex,
                                playlist: false,
                                song: song,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      );
                    },
                  )
                : Flexible(
                    child: Center(
                      child: Image.asset(
                        'assets/images/fetch error.png',
                        width: size.width * 0.5,
                      ),
                    ),
                  );
          },
        )
      ],
    );
  }
}
