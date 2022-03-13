import 'package:tune_in/exports/exports.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        Obx(
          () {
            return controller.bottonintexnotifier.value < 1
                ? IconButton(
                    onPressed: () {
                      controller.getTheSearchList(initial: true);
                      Get.to(
                        const Searchpage(),
                      );
                    },
                    icon: const Icon(Icons.search_rounded),
                  )
                : const SizedBox();
          },
        )
      ],
      title: Obx(
        () {
          return Text(
            controller.titles[controller.bottonintexnotifier.value],
          );
        },
      ),
      elevation: 0,
      backgroundColor: const Color(0XFFC4C4C4).withOpacity(0.2),
    );
  }
}
