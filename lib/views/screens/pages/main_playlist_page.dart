import 'package:tune_in/exports/exports.dart';
import 'package:tune_in/controller/controller.dart';

class MainPlaylist extends StatelessWidget {
  const MainPlaylist({Key? key, List? audios}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PlayerController controller = Get.find<PlayerController>();
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(
          height: height * 0.015,
        ),
        //================================================ pinned playlist tile section ================================================//
        ListTile(
          tileColor: Colors.white.withOpacity(0.3),
          onTap: () {
            controller.getThePinnedSongs();
            Get.to(
              const PinnedList(
                removeOption: true,
              ),
            );
          },
          leading: const Icon(
            Icons.push_pin,
            color: Colors.green,
            size: 30,
          ),
          title: Text(
            'Pinned Songs',
            style: TextStyle(
              fontSize: width * 0.054,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: Obx(
            () => controller.pinnedSongNotifier.isEmpty
                ? const SizedBox()
                : Text(
                    '${controller.pinnedSongNotifier.length.toString()} Songs',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(
              Colors.white.withOpacity(
                0.5,
              ),
            ),
          ),
          onPressed: () {
            showdialoge(
              context: context,
              title: 'Create playlist',
              playlist: false,
              delete: false,
              other: true,
            );
          },
          child: const Text(
            'Add playlists',
          ),
        ),
        //=======================================user playlist section====================================================//
        controller.playlistNotifier.isNotEmpty
            ? Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 20, bottom: 10),
                    child: Text(
                      'Playlists',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ],
              )
            : const SizedBox(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Obx(
              () {
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 20,
                    crossAxisCount: 2,
                  ),
                  itemCount: controller.playlistNotifier.length,
                  itemBuilder: (BuildContext context, int index) {
                    OnlyModelplaylist playlist =
                        controller.playlistNotifier[index];
                    return InkWell(
                      onLongPress: () async {
                        return await showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: const Text('Are You sure want to remove'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: const Text(
                                    'No',
                                    style: TextStyle(color: Colors.blueGrey),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    controller
                                        .deleteplaylist(playlist.playlistKey);
                                    Navigator.of(context).pop(true);
                                  },
                                  child: const Text(
                                    'Yes',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                        );
                      },
                      onTap: () {
                        controller.alreadyAddedSongkeysInUserPlaylist.clear();
                        controller.getCurrespondingPlaylistSongs(
                            playlist.playlistKey!);
                        Get.to(
                          Userplaylistsong(
                            playlistkey: playlist.playlistKey,
                            isplaylist: true,
                            title: playlist.playlistName!,
                            removeOption: true,
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: const DecorationImage(
                              image: AssetImage('assets/images/playlist.jpg'),
                              fit: BoxFit.contain),
                        ),
                        child: Center(
                          child: Text(
                            playlist.playlistName.toString().length >= 10
                                ? playlist.playlistName!
                                    .toUpperCase()
                                    .substring(0, 10)
                                : playlist.playlistName!.toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
