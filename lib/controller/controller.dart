import 'package:tune_in/exports/exports.dart';
import 'package:tune_in/views/screens/pages/library_page.dart';

//============================== provider class starts from here ==============================//
class PlayerController extends GetxController {
//==================icon========================//
  Icon unpined = const Icon(
    Icons.push_pin_outlined,
    color: Colors.white,
  );
  Icon pinned = const Icon(
    Icons.push_pin,
    color: Colors.red,
  );
//===================icon=======================//

  //================== pages ====================//
  List pages = [
    const Library(),
    const Albums(),
    const MainPlaylist(),
    const Settings(),
  ];
  //================== pages ====================//
  //================== titles ===================//
  List titles = [
    'Library',
    'Albums',
    'Playlist',
    'Settings',
  ];
  //================== titles ===================//

  final TextEditingController searchdata = TextEditingController();
  final RxInt bottonintexnotifier = 0.obs;
  //
  Duration currentPosition = const Duration(seconds: 0);
  Duration dur = const Duration(seconds: 0);
  double curr = 0;
  ValueNotifier<int> dura = ValueNotifier(0);
  ValueNotifier<int?> currentSongImageNotifier = ValueNotifier(-1);
  //

  RxList<ModelPlaylistsongs> currespondingPlaylistsong =
      <ModelPlaylistsongs>[].obs;
  RxBool isbuttonchanged = false.obs;

  String? searchedSong;
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> queriedsong = [];
  //================== changing modes of play songs with list ==================//
  List<Audio> allSongsplayList = [];
  List<Audio> pinnedPlaylist = [];
  List<Audio> albumPlaylist = [];
  List<Audio> playlistSongsList = [];
  //================= changing modes of play songs with list ===================//
  RxList<AllSongs> remainingSongsNotifier = <AllSongs>[].obs;
  //this notifier for list the remainig songs in the songs adding section//
  List<int> alreadyAddedSongkeysInUserPlaylist = [];
  RxList<AllSongs> allSongsNotifier = <AllSongs>[].obs;
  RxList<AllSongs> searchSongsList = <AllSongs>[].obs;
  RxList<AllSongs> pinnedSongNotifier = <AllSongs>[].obs;
  RxList<ModelAlbum> albumSongNotifier = <ModelAlbum>[].obs;
  RxList<ModelAlbum> currespondingAlbumSongNotifier = <ModelAlbum>[].obs;
  RxList<OnlyModelplaylist> playlistNotifier = <OnlyModelplaylist>[].obs;
  RxList<ModelPlaylistsongs> playlistSongsNotifier = <ModelPlaylistsongs>[].obs;
  List<OnlyModelplaylist> remainingPlaylists = [];
  final AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
  int? currentPlaylistKey;
  String? currentplayingsongpath;
// its for update ui with currespods to the current songs changes //
  RxString currentSongNameNotifier = 'Unknown'.obs;
  RxBool isCurrentsongPinned = false.obs;
  int? currentSongkey;
  String? songNameForNotification;
  int? songImgForNotification;

//its for update ui with currespods to the current songs changes//
  LoopMode loop = LoopMode.playlist;

//=============== song path to play the audio==================//
  List<String> currespondingPlaylistSongPath = [];
  List<AllSongs> currespodingAlbumSongs = [];
  List<String> albumSongPaths = [];
  List<String> pinnedsongpaths = [];
  List<String> allsongpath = [];
//=============== song path to play the audio==================//
//
  bool isPlayingFromPlaylist = false;
  bool isPlayingFromPinnedList = false;
//

  RxBool isplayed = false.obs;
  bool isPinned = false;
  //bool isplaying = false;
  //String? currentplayingsongname;
  //dynamic currentplayingsongimg;
  int? currentsongindex;
  Duration? duration;
  int? selectedSongindex;
  int? selectedSongKey;
  String? currentSongDuration;
  int wheretoPlay = 1;

//================================ path initializing function ==============================//
  getAllSongsPaths(List<String> songPathList) {
    for (var element in songPathList) {
      final audio = Audio.file(element,
          metas: Metas(
            title: songNameForNotification,
          ));
      allSongsplayList.add(audio);
    }
  }

  getAlbumSongsPaths(List<String> songPathList) {
    for (var element in songPathList) {
      final audio = Audio.file(element,
          metas: Metas(
            title: songNameForNotification,
          ));
      albumPlaylist.add(audio);
    }
  }

  getPinnedSongsPaths(List<String> songPathList) {
    for (var element in songPathList) {
      final audio = Audio.file(element,
          metas: Metas(
            title: songNameForNotification,
          ));
      pinnedPlaylist.add(audio);
    }
  }

  getPlaylistSongsPaths(List<String> songPathList) {
    for (var element in songPathList) {
      final audio = Audio.file(element,
          metas: Metas(
            title: songNameForNotification,
          ));
      playlistSongsList.add(audio);
    }
  }

//================================ end of path initializing function==============================//

//======================== modes of playlist controller ==================//
  whereToPlaysongs() {
    if (wheretoPlay == 1) {
      return allSongsplayList;
    } else if (wheretoPlay == 2) {
      return pinnedPlaylist;
    } else if (wheretoPlay == 3) {
      return playlistSongsList;
    } else if (wheretoPlay == 4) {
      return albumPlaylist;
    }
  }
//======================== end of modes of playlist controller ==================//

//============ box ==============//
  Future<Box<AllSongs>> allSongsBox() async {
    final allSongBox = await Hive.openBox<AllSongs>('songbox');
    return allSongBox;
  }

  Future<Box<OnlyModelplaylist>> onlymodelplaylistBox() async {
    final onlymodelplaylistBox =
        await Hive.openBox<OnlyModelplaylist>('playlistbox');
    return onlymodelplaylistBox;
  }

  Future<Box<ModelPlaylistsongs>> playlistsongsBox() async {
    final playlistsongsBox =
        await Hive.openBox<ModelPlaylistsongs>('playlistSongbox');
    return playlistsongsBox;
  }
//============ box ==============//

//=========================song fetch section========================//
  fetchSong({required bool accepted}) async {
    if (await _audioQuery.permissionsStatus() != true) {
      await _audioQuery.permissionsRequest();
    }
    List<AllSongs> list = [];
    queriedsong = await _audioQuery.querySongs();
    final allSongBox = await allSongsBox();
    allSongsNotifier.clear();
    if (allSongBox.values.isEmpty) {
      for (var songs in queriedsong) {
        AllSongs allsongdata = AllSongs(
            name: songs.title,
            albums: songs.album,
            duration: songs.duration,
            songdata: songs.data,
            image: songs.id);
        int _key = await allSongBox.add(allsongdata);
        allsongdata.key = _key;
        await allSongBox.put(allsongdata.key, allsongdata);
        allSongsNotifier.add(allsongdata);
      }
    } else {
      List<String> songname = [];
      songname.clear();
      list.addAll(allSongBox.values);
      for (var item in list) {
        songname.add(item.name!);
      }
      var k = 0;
      for (var i = 0; i < queriedsong.length; i++) {
        if (songname[k] != queriedsong[i].title) {
          AllSongs songdata = AllSongs(
            name: queriedsong[i].title,
            songdata: queriedsong[i].data,
            duration: queriedsong[i].duration,
            albums: queriedsong[i].album,
            image: queriedsong[i].id,
          );
          int _key = await allSongBox.add(songdata);
          songdata.key = _key;
          await allSongBox.put(songdata.key, songdata);
        } else {
          k++;
        }
      }
      allSongsNotifier.addAll(allSongBox.values);
    }
    list.clear();
    queriedsong.clear();
    listtoalbums();
  }
//========================= end of song fetch section=========================//

//=============================================data functions=====================================================//
//============ end of Search songs list function ==================//
  getTheSearchList({
    String? value,
    bool initial = false,
  }) {
    if (initial == true) {
      searchSongsList.clear();
      searchSongsList.addAll(
        allSongsNotifier,
      );
    } else {
      searchSongsList.clear();
      if (value != null) {
        for (var item in allSongsNotifier) {
          if (item.name.toString().toLowerCase().contains(
                value.toString().toLowerCase(),
              )) {
            searchSongsList.add(
              item,
            );
          }
        }
      }
    }
  }
//============ end of Search songs list function ==================//

  //==============      ===add song paths =========================//
  addPinnedSongPaths() {
    controller.pinnedsongpaths.clear();
    for (var songpath in controller.pinnedSongNotifier) {
      controller.pinnedsongpaths.add(
        songpath.songdata!,
      );
    }
  }

  //===================end of add song paths ======================//
//==============================album data function===========================//
  listtoalbums() {
    List<String?> albumName = [];
    albumName.clear();
    for (var songs in allSongsNotifier) {
      albumName.add(songs.albums);
    }
    albumName = albumName.toSet().toList();
    albumSongNotifier.clear();
    int a = 0;
    for (var i = 0; i < allSongsNotifier.length; i++) {
      if (albumName[a] == allSongsNotifier[i].albums) {
        ModelAlbum albumdata = ModelAlbum(
            albumname: allSongsNotifier[i].albums,
            image: allSongsNotifier[i].image);
        albumSongNotifier.add(albumdata);
        a++;
      }
    }
  }
//==========================end of album data function=========================//

//===============================playlist data functions=========================//

  getRemainingPlaylist(int key) async {
    Box<OnlyModelplaylist> allplaylist = await onlymodelplaylistBox();
    List<int> unUsedPlaylistKeys = [];
    List<int> allPlaylistkeys = [];
    List<int> usedplaylistkeys = [];
    allPlaylistkeys.clear();
    usedplaylistkeys.clear();
    unUsedPlaylistKeys.clear();
    remainingPlaylists.clear();
    if (playlistNotifier.isEmpty) {
    } else if (playlistSongsNotifier.isEmpty) {
      remainingPlaylists.addAll(playlistNotifier);
    } else {
      for (var item in playlistSongsNotifier) {
        if (key == item.songkey) {
          usedplaylistkeys.add(item.playlistKey!);
        }
      }
      for (var item in playlistNotifier) {
        allPlaylistkeys.add(item.playlistKey!);
      }
      unUsedPlaylistKeys = allPlaylistkeys
          .where((item) => !usedplaylistkeys.contains(item))
          .toList();
      if (unUsedPlaylistKeys.isNotEmpty) {
        for (var item in unUsedPlaylistKeys) {
          OnlyModelplaylist? playlist = allplaylist.get(item);
          remainingPlaylists.add(playlist!);
        }
      }
    }
  }

//its only for playlist tile details
  getplaylist() async {
    playlistNotifier.clear();
    final playlistbox = await onlymodelplaylistBox();
    playlistNotifier.addAll(playlistbox.values);
  }

  addplaylist(
      {required String playlistname,
      bool? fromlibrary,
      AllSongs? songs}) async {
    final playlistbox = await onlymodelplaylistBox();
    final playlist = OnlyModelplaylist(playlistName: playlistname);
    int _key = await playlistbox.add(playlist);
    playlist.playlistKey = _key;
    await playlistbox.put(playlist.playlistKey, playlist);
    playlistNotifier.add(playlist);
    if (fromlibrary == true) {
      await addSongToUserPlaylist(playlist.playlistKey!, songs!);
    }
  }

  deleteplaylist(int? playlistkey) async {
    final playlistbox = await onlymodelplaylistBox();
    final playlistSongsbox = await playlistsongsBox();
    ModelPlaylistsongs key = ModelPlaylistsongs();
    for (var i = 0; i < playlistSongsNotifier.length; i++) {
      if (playlistSongsNotifier[i].playlistKey == playlistkey) {
        key.currespondingSongDeletingkey =
            playlistSongsNotifier[i].currespondingSongDeletingkey;
        await playlistSongsbox.delete(key.currespondingSongDeletingkey);
      }
    }
    await playlistbox.delete(playlistkey);
    await getplaylist();
    await getUserPlaylistSongs();
  }

//=============================end of playlist data functions========================//

//=============================user playlist song functions==========================//
//its for playlist songs details
  addSongToUserPlaylist(int currespondingPlaylistKey, AllSongs songdata) async {
    Box<ModelPlaylistsongs> userplaylist = await playlistsongsBox();
    ModelPlaylistsongs userplaylistsongs = ModelPlaylistsongs(
      playlistKey: currespondingPlaylistKey,
      duration: songdata.duration,
      image: songdata.image,
      songdata: songdata.songdata,
      songkey: songdata.key,
      songname: songdata.name,
    );
    int _key = await userplaylist.add(userplaylistsongs);
    userplaylistsongs.currespondingSongDeletingkey = _key;
    await userplaylist.put(
        userplaylistsongs.currespondingSongDeletingkey, userplaylistsongs);
    if (isPlayingFromPlaylist == true) {
      if (songdata.songdata != null) {
        assetsAudioPlayer.playlist!.add(
          Audio(
            songdata.songdata!,
          ),
        );
      }
    }
    await getUserPlaylistSongs();
  }

  getUserPlaylistSongs() async {
    playlistSongsNotifier.clear();
    Box<ModelPlaylistsongs> userplaylist = await playlistsongsBox();
    playlistSongsNotifier.addAll(userplaylist.values);
  }

  removeSongFromUserPlaylist({int? key, required int index}) async {
    //first check is played the song alredy or not then only delte the song and also check where from the song is playing//
    if (isPlayingFromPlaylist == true) {
      assetsAudioPlayer.playlist!.removeAtIndex(index);
    }
    Box<ModelPlaylistsongs> userplaylist = await playlistsongsBox();
    await userplaylist.delete(key);
    await getUserPlaylistSongs();
  }

  getCurrespondingPlaylistSongs(int playlistKey) {
    currespondingPlaylistSongPath.clear();
    currespondingPlaylistsong.clear();
    playlistSongsList.clear();
    for (var item in playlistSongsNotifier) {
      if (item.playlistKey == playlistKey) {
        final userplaylistdata = ModelPlaylistsongs(
          songname: item.songname,
          duration: item.duration,
          image: item.image,
          songdata: item.songdata,
          songkey: item.songkey,
          currespondingSongDeletingkey: item.currespondingSongDeletingkey,
        );
        currespondingPlaylistsong.add(userplaylistdata);
      }
    }
  }

//!!!!!its for get the  remainig songs to add into user creating playlist!!!!!//
  getRemaingSongsForUserPlaylist() async {
    Box<AllSongs> allSongs = await allSongsBox();
    remainingSongsNotifier.clear();
    if (currespondingPlaylistsong.isEmpty) {
      remainingSongsNotifier.addAll(allSongsNotifier);
    } else if (allSongsNotifier.length == currespondingPlaylistsong.length) {
      remainingSongsNotifier.clear();
    } else {
      List<int> allkeys = [];
      List<int> currplaylistsongkeys = [];
      allkeys.clear();
      currplaylistsongkeys.clear();
      for (var item in allSongsNotifier) {
        allkeys.add(item.key!);
      }
      for (var item in currespondingPlaylistsong) {
        currplaylistsongkeys.add(item.songkey!);
      }
      allkeys = allkeys
          .where(
            (item) => !currplaylistsongkeys.contains(item),
          )
          .toList();
      for (var i = 0; i < allkeys.length; i++) {
        AllSongs? song = allSongs.get(allkeys[i]);
        remainingSongsNotifier.add(song!);
      }
    }
  }

//============================= end of user playlist song functions=============================//

//==================================pinned song functions===============================//
  unPinTheSongfromLibrary(
    AllSongs? song,
    int index,
  ) async {
    if (song == null) {
      return;
    }
    Box<AllSongs> allsongbox = await allSongsBox();
    final tempdata = AllSongs(
      albums: song.albums,
      duration: song.duration,
      image: song.image,
      ispinned: false,
      key: song.key,
      name: song.name,
      songdata: song.songdata,
    );
    await allsongbox.put(song.key!, tempdata);
    allSongsNotifier[index] = tempdata;
    if (isPlayingFromPinnedList == true) {
      if (song.songdata != null) {
        assetsAudioPlayer.playlist!.add(
          Audio(song.songdata!),
        );
      }
    }
    if (currentSongNameNotifier.value == song.name) {
      isCurrentsongPinned.value = false;
    }
    pinnedsongpaths.clear();
    for (var songpath in pinnedSongNotifier) {
      pinnedsongpaths.add(
        songpath.songdata!,
      );
    }
    getThePinnedSongs();
    update();
  }

  pinTheSongfromLibrary(
    AllSongs? song,
    int index,
  ) async {
    if (song == null) {
      return;
    }
    Box<AllSongs> allsongbox = await allSongsBox();
    final tempdata = AllSongs(
      albums: song.albums,
      duration: song.duration,
      image: song.image,
      ispinned: true,
      key: song.key,
      name: song.name,
      songdata: song.songdata,
    );
    await allsongbox.put(song.key!, tempdata);
    allSongsNotifier[index] = tempdata;
    if (isPlayingFromPinnedList == true) {
      if (song.songdata != null) {
        assetsAudioPlayer.playlist!.add(
          Audio(song.songdata!),
        );
      }
    }
    if (currentSongNameNotifier.value == song.name) {
      isCurrentsongPinned.value = true;
    }
    getThePinnedSongs();
    update();
  }

  pinTheSong(
    List<AllSongs> data,
    BuildContext context,
  ) async {
    Box<AllSongs> allsongbox = await allSongsBox();
    for (var item in data) {
      int? key = item.key;
      final tempdata = AllSongs(
        albums: item.albums,
        duration: item.duration,
        image: item.image,
        ispinned: item.ispinned,
        key: item.key,
        name: item.name,
        songdata: item.songdata,
      );
      await allsongbox.put(key!, tempdata);
      if (isPlayingFromPinnedList == true) {
        if (item.songdata != null) {
          assetsAudioPlayer.playlist!.add(
            Audio(item.songdata!),
          );
        }
      }
      if (currentSongNameNotifier.value == item.name) {
        isCurrentsongPinned.value = true;
      }
    }
    allSongsNotifier.clear();
    allSongsNotifier.addAll(allsongbox.values);
    await getThePinnedSongs();
    pinnedsongpaths.clear();
    for (var songpath in pinnedSongNotifier) {
      pinnedsongpaths.add(
        songpath.songdata!,
      );
    }
  }

  unPinTheSong({
    required int key,
    required AllSongs data,
    required int index,
  }) async {
    if (isPlayingFromPinnedList == true) {
      assetsAudioPlayer.playlist!.removeAtIndex(index);
      if (data.name == currentSongNameNotifier.value) {
        assetsAudioPlayer.next();
      }
    }
    if (currentSongNameNotifier.value == data.name) {
      isCurrentsongPinned.value = false;
    }
    Box<AllSongs> allsongbox = await allSongsBox();
    final pinnedSong = AllSongs(
      name: data.name,
      ispinned: false,
      albums: data.albums,
      songdata: data.songdata,
      duration: data.duration,
      image: data.image,
      key: key,
    );
    await allsongbox.put(key, pinnedSong);
    allSongsNotifier.clear();
    allSongsNotifier.addAll(allsongbox.values);
    await getThePinnedSongs();
    pinnedsongpaths.clear();
    for (var songpath in pinnedSongNotifier) {
      pinnedsongpaths.add(
        songpath.songdata!,
      );
    }
  }

  getThePinnedSongs() {
    pinnedSongNotifier.clear();
    for (var item in allSongsNotifier) {
      if (item.ispinned == true) {
        AllSongs pinnedSong = AllSongs(
            duration: item.duration,
            name: item.name,
            key: item.key,
            image: item.image,
            songdata: item.songdata);
        pinnedSongNotifier.add(pinnedSong);
      }
    }
  }

//================================== end of pinned song functions===========================//

//=====================================player initialization==========================//

  playerinit({
    startingindex = 0,
    search = false,
    songPath,
  }) async {
    isplayed.value = true;
    change();
    await assetsAudioPlayer.open(
      search == true
          ? Audio.file(
              songPath,
              metas: Metas(
                title: songNameForNotification,
              ),
            )
          : Playlist(
              audios: whereToPlaysongs(),
              startIndex: startingindex,
            ),
      autoStart: true,
      showNotification: true,
      loopMode: loop,
    );
    await listenEverything();
    duration = assetsAudioPlayer.current.value!.audio.duration;
    currentsongindex = assetsAudioPlayer.current.value?.index;
    update();
  }

  listenEverything() {
    assetsAudioPlayer.current.listen(
      (event) {
        currentplayingsongpath =
            assetsAudioPlayer.current.value?.audio.audio.path;
        for (var i = 0; i < allSongsNotifier.length; i++) {
          if (currentplayingsongpath == allSongsNotifier[i].songdata) {
            currentSongImageNotifier.value = allSongsNotifier[i].image;
            currentSongImageNotifier.notifyListeners();
            isCurrentsongPinned.value = allSongsNotifier[i].ispinned ?? false;
            currentSongkey = allSongsNotifier[i].key;
            currentSongNameNotifier.value =
                allSongsNotifier[i].name ?? 'Unknown';
          }
        }
      },
    );
  }

  change() {
    assetsAudioPlayer.isPlaying.listen(
      (
        event,
      ) {
        if (assetsAudioPlayer.isPlaying.value == true) {
          isbuttonchanged.value = true;
        } else {
          isbuttonchanged.value = false;
        }
      },
    );
  }

// =================================== Slider section =======================================//
  // ignore: prefer_typing_uninitialized_variables

  totalDuration() {
    assetsAudioPlayer.current.listen(
      (event) {
        dur = event!.audio.duration;
        dura.notifyListeners();
      },
    );
    return ValueListenableBuilder(
      valueListenable: dura,
      builder: (
        BuildContext context,
        int something,
        _,
      ) {
        return Text(
          dur.toString().split('.')[0],
          style: const TextStyle(color: Colors.white),
        );
      },
    );
  }

  getDuration() {
    return StreamBuilder(
      stream: assetsAudioPlayer.currentPosition,
      builder: (context, AsyncSnapshot<Duration> asyncSnapshot) {
        currentPosition = asyncSnapshot.data ?? const Duration();
        return Text(
          currentPosition.toString().split('.')[0],
          style: const TextStyle(
            color: Colors.white,
          ),
        );
      },
    );
  }

  current() {
    curr = currentPosition as double;
    update();
  }

  void changeToSeconds(int seconds) {
    Duration newDuration = Duration(seconds: seconds);
    assetsAudioPlayer.seek(newDuration);
    update();
  }
//=========================== end of slider ==============================//

//=================== song playing controller section =======================//
  playwithindex({index}) async {
    await assetsAudioPlayer.playlistPlayAtIndex(index);
  }

  playsong() async {
    await assetsAudioPlayer.play();
  }

  songpause() async {
    await assetsAudioPlayer.pause();
  }

  songprevious() async {
    await assetsAudioPlayer.previous();
  }

  playnext() async {
    await assetsAudioPlayer.next();
  }
//=================== end of song playing controller section =======================//

//==============================reset the app function=========================//
  clearalldata() async {
    SharedPreferences isaccepted = await SharedPreferences.getInstance();
    await isaccepted.setBool('accepted', false);
    final allsongsbox = await allSongsBox();
    await allsongsbox.clear();
    allSongsNotifier.clear();
    final playlistbox = await onlymodelplaylistBox();
    await playlistbox.clear();
    playlistNotifier.clear();
    final allplaylistsongs = await playlistsongsBox();
    await allplaylistsongs.clear();
    playlistSongsNotifier.clear();
    albumSongNotifier.clear();
    await assetsAudioPlayer.stop();
    pinnedSongNotifier.clear();
    isplayed.value = false;
    bottonintexnotifier.value = 0;
  }
//=============================end of reset the app function=====================//

  //====================== sleep timer switch section ======================//
  String sleepTimerIndicator = '00:00';
  Icon off = const Icon(
    Icons.toggle_off,
    color: Colors.white,
  );
  Icon on = const Icon(
    Icons.toggle_on_outlined,
    color: Colors.green,
  );
  RxBool isConfirmed = false.obs;
  offTheSwitch() {
    icon = off;
    isConfirmed.value = false;
    update();
  }

  //====================== sleep timer switch section ======================//

  String? time;
  String nulltime = '0';
  int count = 0;
  Widget getTimer(BuildContext context) {
    return CustomTimePicker(
      elevation: 2,
      onPositivePressed: (context, time) {
        isConfirmed.value = true;
        icon = on;
        update();
        var usertime = time.toString().substring(11, 16);
        for (var item in usertime.characters) {
          item == '0' ? count++ : count;
        }
        count != 4
            ? sleepTimerIndicator = usertime
            : sleepTimerIndicator = nulltime;
        update();
        String hour = usertime.toString().substring(0, 2);
        String minute = usertime.toString().substring(3, 5);
        int min = int.parse(minute);
        int hr = int.parse(hour);
        hr = hr * 3600;
        min = min * 60;
        int totalseconds = hr + min;
        runtime(totalseconds);
        Get.back();
      },
      onNegativePressed: (context) {
        isConfirmed.value = false;
        icon = off;
        update();
        Get.back();
      },
    );
  }

  runtime(int totalseconds) async {
    await Future.delayed(
      Duration(
        seconds: totalseconds,
      ),
      () async {
        if (isConfirmed.value == true) {
          await assetsAudioPlayer.pause();
        }
      },
    );
    icon = off;
    update();
  }

//===================================================================================//
//===========pinning songs from the now playing functions===============//
  pinSongFromNowplaying(BuildContext context) async {
    Box<AllSongs> allSongBox = await allSongsBox();
    for (var i = 0; i < allSongsNotifier.length; i++) {
      if (currentplayingsongpath == allSongsNotifier[i].songdata) {
        AllSongs song = AllSongs(
            albums: allSongsNotifier[i].albums,
            duration: allSongsNotifier[i].duration,
            image: allSongsNotifier[i].image,
            ispinned: true,
            key: allSongsNotifier[i].key,
            name: allSongsNotifier[i].name,
            songdata: allSongsNotifier[i].songdata);
        await allSongBox.put(currentSongkey, song);
      }
    }
    allSongsNotifier.clear();
    allSongsNotifier.addAll(allSongBox.values);
    getThePinnedSongs();
    isCurrentsongPinned.value = true;
  }

//===========unpinning songs from the now playing functions===============//
  unPinSongFromNowplaying(BuildContext context) async {
    final Box<AllSongs> allSongBox = await allSongsBox();
    for (var i = 0; i < allSongsNotifier.length; i++) {
      if (currentplayingsongpath == allSongsNotifier[i].songdata) {
        final AllSongs song = AllSongs(
          albums: allSongsNotifier[i].albums,
          duration: allSongsNotifier[i].duration,
          image: allSongsNotifier[i].image,
          ispinned: false,
          key: allSongsNotifier[i].key,
          name: allSongsNotifier[i].name,
          songdata: allSongsNotifier[i].songdata,
        );
        await allSongBox.put(
          currentSongkey,
          song,
        );
      }
    }
    allSongsNotifier.clear();
    allSongsNotifier.addAll(allSongBox.values);
    await getThePinnedSongs();
    isCurrentsongPinned.value = false;
  }
//==================================================================================//

// ==================== Tile click actions ========================//
  albumTileClickAction(int index) {
    isPlayingFromPinnedList == true
        ? isPlayingFromPinnedList = false
        : isPlayingFromPinnedList;
    isPlayingFromPlaylist == true
        ? isPlayingFromPlaylist = false
        : isPlayingFromPlaylist;
    wheretoPlay = 4;
    songImgForNotification = currespodingAlbumSongs[index].image;
    songNameForNotification = currespodingAlbumSongs[index].name;
    getAlbumSongsPaths(
      albumSongPaths,
    );
    selectedSongKey = currespodingAlbumSongs[index].key;
    selectedSongindex = index;
    currentSongDuration = currespodingAlbumSongs[index].duration.toString();
    playerinit(
      startingindex: selectedSongindex,
    );
  }

  libraryPageTileClickAction(AllSongs song, int index) {
    isPlayingFromPinnedList = false;
    isPlayingFromPlaylist = false;
    for (var paths in allSongsNotifier) {
      allsongpath.add(
        paths.songdata ?? '',
      );
    }
    songNameForNotification = song.name;
    songImgForNotification = song.image;
    getAllSongsPaths(
      allsongpath,
    );
    wheretoPlay = 1;
    selectedSongindex = index;
    isCurrentsongPinned.value = song.ispinned ?? false;
    currentSongDuration = song.duration.toString();
    playerinit(
      startingindex: selectedSongindex,
    );
  }

  pinnedPageTileClickAction(AllSongs pinnedsong, int index) {
    isPlayingFromPinnedList = true;
    pinnedPlaylist.clear();
    songImgForNotification = pinnedsong.image;
    songNameForNotification = pinnedsong.name;
    wheretoPlay = 2;
    getPinnedSongsPaths(
      pinnedsongpaths,
    );
    // currentplayingsongname = pinnedsong.name;
    // currentplayingsongimg = pinnedsong.image;
    selectedSongKey = pinnedsong.key;
    selectedSongindex = index;
    currentSongDuration = pinnedsong.duration.toString();
    playerinit(
      startingindex: selectedSongindex,
    );
  }

  playlistSongTileClickAction(int index) {
    isPlayingFromPlaylist = true;
    currespondingPlaylistSongPath.clear();
    for (var item in currespondingPlaylistsong) {
      currespondingPlaylistSongPath.add(
        item.songdata!,
      );
    }
    songImgForNotification = controller.currespondingPlaylistsong[index].image;
    songNameForNotification =
        controller.currespondingPlaylistsong[index].songname;
    getPlaylistSongsPaths(
      currespondingPlaylistSongPath,
    );
    wheretoPlay = 3;
    // currentplayingsongimg = controller
    //     .currespondingPlaylistsong[index].image;
    // currentplayingsongname = controller
    //     .currespondingPlaylistsong[index].songname;
    selectedSongKey = controller.currespondingPlaylistsong[index].songkey;
    selectedSongindex = index;
    currentSongDuration =
        controller.currespondingPlaylistsong[index].duration.toString();
    playerinit(
      startingindex: selectedSongindex,
    );
  }

// ==================== End of Tile click Actions ========================//
}
