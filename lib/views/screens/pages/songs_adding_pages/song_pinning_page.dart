import 'package:tune_in/exports/exports.dart';
import 'package:tune_in/controller/controller.dart';

List<AllSongs> tempPinning = [];

class PinThesongpage extends StatelessWidget {
  const PinThesongpage({
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
              onPressed: () async {
                await controller.pinTheSong(tempPinning, context);
                await controller.getThePinnedSongs();
                currentIcon = add;
                currentIndex = -1;
                Get.back();

                controller.pinnedPlaylist.clear();

                controller.getPinnedSongsPaths(controller.pinnedsongpaths);
              },
              child: const Text('save'))
        ],
      ),
      backgroundColor: Colors.blueGrey[800],
      body: Obx(
        () {
          List<AllSongs> temp = [];
          temp.clear();
          for (var item in controller.allSongsNotifier) {
            if (item.ispinned == false || item.ispinned == null) {
              final tempdata = AllSongs(
                albums: item.albums,
                duration: item.duration,
                image: item.image,
                ispinned: item.ispinned,
                key: item.key,
                name: item.name,
                songdata: item.songdata,
              );
              temp.add(tempdata);
            }
          }
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: QueryArtworkWidget(
                  nullArtworkWidget: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: const Image(
                        width: 50,
                        image: AssetImage('assets/images/DefaultMusicImg.png'),
                      )),
                  id: temp[index].image!,
                  type: ArtworkType.AUDIO,
                  artworkBorder: BorderRadius.circular(5),
                ),
                title: temp[index].name!.length > 24
                    ? Text(
                        temp[index].name!.substring(0, 24),
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: width * 0.04,
                            fontWeight: FontWeight.w200),
                      )
                    : Text(
                        temp[index].name ?? 'unknown',
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: width * 0.04,
                            fontWeight: FontWeight.w200),
                      ),
                trailing: AddRemoveBtn(
                  builder1: () {
                    if (currentIndex != index) {
                      final pinnedSong = AllSongs(
                          name: temp[index].name,
                          ispinned: true,
                          albums: temp[index].albums,
                          duration: temp[index].duration,
                          songdata: temp[index].songdata,
                          image: temp[index].image,
                          key: temp[index].key);
                      tempPinning.add(pinnedSong);
                      currentIcon = remove;
                      currentIndex = index;
                    } else {
                      tempPinning.removeAt(index);
                      currentIndex = -1;
                      currentIcon = add;
                    }
                  },
                ),
              );
            },
            itemCount: temp.length,
          );
        },
      ),
    );
  }
}
