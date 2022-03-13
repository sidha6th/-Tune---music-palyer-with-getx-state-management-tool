import 'package:tune_in/controller/controller.dart';
import 'package:tune_in/exports/exports.dart';

class TuneinScreenSplash extends StatelessWidget {
  const TuneinScreenSplash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PlayerController controller = Get.find<PlayerController>();
    gotolibrary() async {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      final isaccepted = pref.getBool('accepted');
      if (isaccepted == null || isaccepted == false) {
        Get.to(
          const IntroScreen(),
        );
      } else {
        await controller.fetchSong(accepted: true);
        await controller.getplaylist();
        await controller.getThePinnedSongs();
        await controller.getUserPlaylistSongs();
      }
    }

    return FutureBuilder(
      future: gotolibrary(),
      builder: (
        context,
        snapshot,
      ) {
        return Scaffold(
          backgroundColor: Colors.blueGrey[900],
          body: AnimatedSplashScreen(
            backgroundColor: Colors.black.withOpacity(
              0,
            ),
            splashTransition: SplashTransition.fadeTransition,
            animationDuration: const Duration(
              milliseconds: 500,
            ),
            splash: Image(
              width: MediaQuery.of(context).size.width * 0.5,
              image: const AssetImage(
                'assets/images/logo.png',
              ),
            ),
            nextScreen:const BottomNavigation(),
          ),
        );
      },
    );
  }
}
