import 'package:tune_in/exports/exports.dart';
import 'package:tune_in/controller/controller.dart';

late Icon icon;

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final PlayerController controller = Get.find<PlayerController>();
    if (controller.isConfirmed.value == false) {
      icon = controller.off;
    }
    return Column(
      children: [
        ListTile(
          leading: const Icon(
            Icons.timer,
            color: Colors.white60,
          ),
          title: const Text(
            'Sleep timer',
            style: TextStyle(
              fontSize: 19,
              color: Colors.white,
            ),
          ),
          trailing: Column(
            children: [
              Wrap(
                verticalDirection: VerticalDirection.up,
                children: [
                  Obx(
                    () {
                      return controller.isConfirmed.value == true
                          ? Text(
                              controller.sleepTimerIndicator,
                              style: const TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                              ),
                            )
                          : const SizedBox();
                    },
                  ),
                  GetBuilder<PlayerController>(
                    builder: (contrller) {
                      return IconButton(
                          onPressed: () {
                            if (controller.isConfirmed.value == false) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return controller.getTimer(context);
                                },
                              );
                            } else {
                              controller.offTheSwitch();
                            }
                          },
                          icon: icon);
                    },
                  )
                ],
              )
            ],
          ),
        ),
        const ListTile(
          leading: Icon(
            Icons.memory_rounded,
            color: Colors.greenAccent,
          ),
          title: Text(
            'Version',
            style: TextStyle(
              fontSize: 19,
              color: Colors.white,
            ),
          ),
          trailing: Text('V 1.0.0'),
        ),
        ListTile(
          onTap: () {
            Get.to(
              const AboutPage(),
            );
          },
          leading: const Icon(
            Icons.info_outline,
            color: Colors.white,
          ),
          title: const Text(
            'About',
            style: TextStyle(fontSize: 19, color: Colors.white),
          ),
        ),
        ListTile(
          onTap: () {
            controller.clearalldata();
            Get.to(
              const IntroScreen(),
            );
          },
          leading: const Icon(
            Icons.settings_backup_restore_sharp,
            color: Colors.white,
          ),
          title: const Text(
            'Reset App',
            style: TextStyle(fontSize: 19, color: Colors.red),
          ),
        ),
      ],
    );
  }
}
