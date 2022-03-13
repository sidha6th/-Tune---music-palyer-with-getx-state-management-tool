import 'package:tune_in/controller/controller.dart';
import 'package:tune_in/exports/exports.dart';

const Icon unpined =  Icon(
  Icons.push_pin_outlined,
  color: Colors.white,
);
const Icon pinned =  Icon(
  Icons.push_pin,
  color: Colors.red,
);

class ColorChangeIcon extends StatelessWidget {
  const ColorChangeIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PlayerController controller = Get.find<PlayerController>();
    return Obx(() {
      return IconButton(
        onPressed: () async {
          //print('current playing song is ${controller.isCurrentsongPinned}');
          if (controller.isCurrentsongPinned.value != true) {
            await controller.pinSongFromNowplaying(
              context,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                duration: Duration(
                  milliseconds: 150,
                ),
                backgroundColor: Colors.blueGrey,
                content: Text(
                  'Song Pinned',
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else {
            await controller.unPinSongFromNowplaying(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                duration: Duration(
                  milliseconds: 150,
                ),
                backgroundColor: Colors.blueGrey,
                content: Text(
                  'Song Unpinned',
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        icon: controller.isCurrentsongPinned.value != true ? unpined : pinned,
      );
    });
  }
}
