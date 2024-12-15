import 'package:get/get.dart';
import 'package:spotify_group7/data/functions/api.dart';
import 'package:spotify_group7/data/models/album.dart';
import 'package:spotify_group7/data/models/artists.dart';
import 'package:spotify_group7/data/models/music.dart';

import '../../data/functions/token_manager.dart';

class ArtistController extends GetxController {
  var artist = Rx<Artists?>(null);
  var artistTracks = <Music>[].obs;
  var artistAlbums = <Albums>[].obs;

  void setArtist(Artists artistData){
    artist.value = artistData;
  }

  void getArtistTop(String id) async {
    bool isTokenValid = await TokenManager.refreshAccessToken();
    if (!isTokenValid) {
      return;
    }
    try {
      List<Music> musicData = await ArtistApi().fetchArtistTracks(id);
      artistTracks.value = musicData;
    } catch (e) {
      print('Error fetching user info: $e');
    }

    try {
      List<Albums> albumData = await ArtistApi().fetchArtistAlbums(id);
      artistAlbums.value = albumData;
    } catch (e){
      print(e);
    }
  }
}