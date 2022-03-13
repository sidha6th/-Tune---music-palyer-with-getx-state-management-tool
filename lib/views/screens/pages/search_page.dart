import 'package:flutter/cupertino.dart';
import 'package:tune_in/exports/exports.dart';
import 'package:tune_in/controller/controller.dart';

class Searchpage extends StatelessWidget {
  const Searchpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PlayerController controller = Get.find<PlayerController>();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined),
          onPressed: () {
            Get.back();
          },
        ),
        elevation: 0,
        backgroundColor: Colors.blueGrey.shade900.withOpacity(0.2),
        title: CupertinoSearchTextField(
          backgroundColor: Colors.white,
          controller: controller.searchdata,
          onChanged: (value) {
            controller.getTheSearchList(
              value: value,
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Obx(
          () {
            return controller.searchSongsList.isNotEmpty
                ? ListView.separated(
                    itemCount: controller.searchSongsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      AllSongs songs = controller.searchSongsList[index];
                      return Tile(
                        playlist: false,
                        index: index,
                        onTap: () {
                          controller.searchedSong = songs.songdata!;
                          controller.songNameForNotification = songs.name;
                          controller.selectedSongindex = index;
                          controller.currentSongDuration =
                              songs.duration.toString();
                          controller.playerinit(
                            songPath: controller.searchedSong,
                            startingindex: controller.selectedSongindex,
                            search: true,
                          );
                        },
                        title: (songs.name ?? 'Unknown'),
                        songImage: songs.image ?? -1,
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: const AssetImage(
                          'assets/images/no-data-found.png',
                        ),
                        width: size.shortestSide,
                      ),
                      noDatafound,
                    ],
                  );
          },
        ),
      ),
    );
  }
}
