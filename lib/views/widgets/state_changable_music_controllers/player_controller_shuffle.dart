import 'package:tune_in/exports/exports.dart';

bool shuffle = true;
Icon icon = const Icon(Icons.shuffle, color: Colors.white);

class ShuffleIcon extends StatefulWidget {
  const ShuffleIcon({Key? key}) : super(key: key);

  @override
  State<ShuffleIcon> createState() => _SfflueButtonState();
}

class _SfflueButtonState extends State<ShuffleIcon> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (shuffle == true) {
          setState(
            () {
              icon = const Icon(
                Icons.shuffle,
                color: Colors.blueAccent,
              );
            },
          );
          shuffle = false;
        } else {
          setState(
            () {
              icon = const Icon(Icons.shuffle, color: Colors.white);
              shuffle = true;
            },
          );
        }
      },
      icon: icon,
      iconSize: 30,
    );
  }
}
