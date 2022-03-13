import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tune_in/controller/controller.dart';
import 'package:tune_in/exports/exports.dart';

class PinnedList extends StatelessWidget {
  const PinnedList({Key? key, required this.removeOption}) : super(key: key);
  final bool removeOption;
  @override
  Widget build(BuildContext context) {
    final PlayerController controller = Get.find<PlayerController>();
    controller.addPinnedSongPaths();
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
        title: const Text(
          'Pinned songs',
        ),
        actions: [
          //========================================= song adding section ========================================//
          IconButton(
            onPressed: () {
              currentIcon = add;
              currentIndex = -1;
              Get.to(
                const PinThesongpage(
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
      body: Obx(
        () {
          return controller.pinnedSongNotifier.isNotEmpty
              ? ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    AllSongs pinnedsong = controller.pinnedSongNotifier[index];
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
                              onPressed: (context) async {
                                await controller.unPinTheSong(
                                  key: pinnedsong.key!,
                                  data: pinnedsong,
                                  index: index,
                                );
                                controller.pinnedPlaylist.clear();

                                controller.getPinnedSongsPaths(
                                  controller.pinnedsongpaths,
                                );
                              },
                              backgroundColor: const Color(
                                0xFFFFFFFF,
                              ).withOpacity(
                                0.5,
                              ),
                              foregroundColor: Colors.red,
                              icon: Icons.push_pin_outlined,
                              label: 'Unpin',
                            )
                          ],
                        ),
                        child: Tile(
                          onTap: () {
                            controller.pinnedPageTileClickAction(
                                pinnedsong, index);
                          },
                          songImage: pinnedsong.image,
                          playlist: false,
                          title: pinnedsong.name,
                          index: index,
                        ),
                      ),
                    );
                  },
                  itemCount: controller.pinnedSongNotifier.length,
                )
              : const Center(
                  child: noDatafound,
                );
        },
      ),
      bottomNavigationBar: const MiniPlayerObxWidget(),
    );
  }
}
