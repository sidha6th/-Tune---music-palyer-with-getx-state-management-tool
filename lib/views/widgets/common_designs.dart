import 'package:tune_in/exports/exports.dart';

//common music controll icons
musicControllerIcon({icon, builder}) {
  return IconButton(
    onPressed: () {
      builder();
    },
    icon: Icon(
      icon,
      size: 35,
    ),
    color: Colors.black,
  );
}

const Widget noDatafound = Text(
  'No Songs Found',
  style: TextStyle(
      color: Colors.white,
      fontSize: 15,
      fontWeight: FontWeight.bold),
);
