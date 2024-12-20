import 'package:flutter/material.dart';
import 'package:spotify_group7/data/functions/api.dart';
import 'package:spotify_group7/design_system/widgets/song_card/artis_horizontal.dart';

import '../../data/functions/token_manager.dart';
import '../../data/models/artists.dart';
import '../../design_system/constant/list_item.dart';

class ListArtistHome extends StatefulWidget {
  const ListArtistHome({super.key});

  @override
  State<ListArtistHome> createState() => _ListArtistHomeState();
}

class _ListArtistHomeState extends State<ListArtistHome> {
  List<Artists> artists = [];

  @override
  void initState() {
    super.initState();
    _loadArtist();
  }

  _loadArtist() async {
    List<Artists> loadedArtist = [];
    for (String artistId in listIdArtists) {
      try {
        bool isTokenValid = await TokenManager.refreshAccessToken();

        if (!isTokenValid) {
          print("Failed to refresh access token. Skip artist id $artistId");
          continue;
        }

        Artists artistData = await ArtistApi().fetchArtist(artistId);
        loadedArtist.add(artistData);
      } catch (e) {
        print("Error loading artist $e");
      }
    }

    setState(() {
      artists = loadedArtist;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
          // Perbesar ukuran SizedBox agar ada cukup ruang untuk gambar lebih besar
          height: 600,  // Sesuaikan tinggi sesuai kebutuhan
          child: artists.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
            itemCount: artists.length,
            itemBuilder: (BuildContext context, int index) {
              Artists artist = artists[index];
              return ArtistTile(
                  artist: artist,
              );
            },
          ),
        ),
      ),
    );
  }
}