import 'package:tune_in/controller/controller.dart';
import 'package:tune_in/exports/exports.dart';

int currentIndex = -1;

class Addsongpage extends StatelessWidget {
  const Addsongpage({
    Key? key,
    required this.title,
    this.playlistkey,
  }) : super(key: key);
  final int? playlistkey;
  final String title;
  @override
  Widget build(BuildContext context) {
    final PlayerController controller = Get.find<PlayerController>();
    var width = MediaQuery.of(context).size.width;
    //var height=MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined),
          onPressed: () {
            Get.back();
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white.withOpacity(0.2),
        title: Text(
          title,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              currentIcon = add;
              currentIndex = -1;
              controller.remainingSongsNotifier.clear();
              controller.getplaylist();
              Get.back();
            },
            child: const Text('save'),
          )
        ],
      ),
      backgroundColor: Colors.blueGrey[800],
      body: Obx(
        () {
          return ListView.builder(
            itemCount: controller.remainingSongsNotifier.length,
            itemBuilder: (BuildContext context, int index) {
              final remainingSongs = controller.remainingSongsNotifier[index];
              return ListTile(
                leading: QueryArtworkWidget(
                  nullArtworkWidget: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: const Image(
                      width: 50,
                      image: AssetImage('assets/images/DefaultMusicImg.png'),
                    ),
                  ),
                  id: remainingSongs.image!,
                  type: ArtworkType.AUDIO,
                  artworkBorder: BorderRadius.circular(5),
                ),
                title: remainingSongs.name!.length > 18
                    ? Text(
                        remainingSongs.name!.substring(0, 19),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: width * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Text(
                        remainingSongs.name ?? 'unknown',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: width * 0.05,
                            fontWeight: FontWeight.bold),
                      ),
                trailing: AddRemoveBtn(
                  builder1: () {
                    if (currentIndex != index) {
                      // final currentaddingsongs = ModelPlaylistsongs(
                      //     songname: remainingSongs.name,
                      //     duration: remainingSongs.duration,
                      //     image: remainingSongs.image,
                      //     playlistKey: playlistkey,
                      //     songdata: remainingSongs.songdata,
                      //     songkey: remainingSongs.key);
                      controller.addSongToUserPlaylist(
                        playlistkey!,
                        controller.remainingSongsNotifier[index],
                      );
                      currentIndex = index;
                      currentIcon = remove;
                    } else {
                      controller.removeSongFromUserPlaylist(
                        key: controller.remainingSongsNotifier[index].key!,
                        index: index,
                      );
                      currentIndex = -1;
                      currentIcon = add;
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
