import 'package:tune_in/controller/controller.dart';
import 'package:tune_in/exports/exports.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final PlayerController controller = Get.put(PlayerController());
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(AllSongsAdapter().typeId)) {
    Hive.registerAdapter(
      AllSongsAdapter(),
    );
  }
  if (!Hive.isAdapterRegistered(OnlyModelplaylistAdapter().typeId)) {
    Hive.registerAdapter(
      OnlyModelplaylistAdapter(),
    );
  }
  if (!Hive.isAdapterRegistered(ModelPlaylistsongsAdapter().typeId)) {
    Hive.registerAdapter(
      ModelPlaylistsongsAdapter(),
    );
  }
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    return GetMaterialApp(
      theme: ThemeData(
        fontFamily: 'font1',
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      debugShowCheckedModeBanner: false,
      title: 'tune',
      home: const TuneinScreenSplash(),
    );
  }
}
