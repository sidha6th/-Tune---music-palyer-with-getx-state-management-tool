import 'package:tune_in/controller/controller.dart';
import 'package:tune_in/exports/exports.dart';

class Tile extends StatelessWidget {
  const Tile({
    Key? key,
    required this.onTap,
    this.title,
    this.songImage,
    required this.index,
    required this.playlist,
    this.isPinned,
    this.isLibrary,
    this.song,
  }) : super(key: key);
  final bool playlist;
  final int? songImage;
  final int index;
  final String? title;
  final Function onTap;
  final bool? isPinned;
  final bool? isLibrary;
  final AllSongs? song;

  @override
  Widget build(BuildContext context) {
    Icon currentPinIcon;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Colors.black54.withOpacity(0.5),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Bounce(
        duration: const Duration(milliseconds: 50),
        onPressed: () => onTap(),
        child: ListTile(
          leading: playlist == true
              ? Image(
                  image: const AssetImage(
                    'assets/images/playlist.jpg',
                  ),
                  height: height * 0.04)
              : QueryArtworkWidget(
                  nullArtworkWidget: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image(
                      width: width * 0.13,
                      image:
                          const AssetImage('assets/images/DefaultMusicImg.png',),
                    ),
                  ),
                  id: songImage!,
                  artworkWidth: width * 0.13,
                  type: ArtworkType.AUDIO,
                  artworkBorder: BorderRadius.circular(4),
                ),
          title: playlist == true
              ? Padding(
                  padding: EdgeInsets.only(left: width * 0.09),
                  child: title!.length > 20
                      ? Marquee(
                          text: title ?? 'Unknown',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: width * 0.05,
                              fontWeight: FontWeight.w200),
                        )
                      : Text(
                          title ?? 'unknown',
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: width * 0.05,
                              fontWeight: FontWeight.w200),
                        ),
                )
              : Text(
                  title ?? 'unknown',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: width * 0.03,
                      fontWeight: FontWeight.w200),
                ),
          trailing: isLibrary == true
              ? GetBuilder<PlayerController>(builder: (controller) {
                  return IconButton(
                      icon: isPinned == false
                          ? controller.unpined
                          : controller.pinned,
                      onPressed: () async {
                        isPinned == false
                            ? await controller.pinTheSongfromLibrary(
                                song,
                                index,
                              )
                            : await controller.unPinTheSongfromLibrary(
                                song,
                                index,
                              );
                      });
                })
              : const SizedBox(),
        ),
      ),
    );
  }
}
