import 'package:tune_in/exports/exports.dart';

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.blueGrey[800],
      appBar: PreferredSize(
        preferredSize: Size(size.width, 50),
        child: const AppBarWidget(),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const MiniPlayerObxWidget(),
          Obx( () {
              return ConvexAppBar(
                curveSize: 3,
                color: Colors.white.withOpacity(0.5),
                backgroundColor: Colors.transparent,
                onTap: (newindex) {
                  controller.bottonintexnotifier.value = newindex;
                },
                initialActiveIndex: controller.bottonintexnotifier.value,
                elevation: 0,
                items: const [
                  TabItem(
                      icon: Icon(
                        Icons.library_music_outlined,
                      ),
                      activeIcon: Icon(
                        Icons.library_music_rounded,
                      ),
                      title: 'Library'),
                  TabItem(
                    icon: Icon(Icons.album),
                    title: 'Albums',
                  ),
                  TabItem(
                    icon: Icon(
                      Icons.headphones_sharp,
                    ),
                    activeIcon: Icon(
                      Icons.headphones_outlined,
                    ),
                    title: 'Playlist',
                  ),
                  TabItem(
                    icon: Icon(
                      Icons.settings,
                    ),
                    title: 'Settings',
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Obx( () {
          return controller.pages[controller.bottonintexnotifier.value];
        },
      ),
    );
  }
}
