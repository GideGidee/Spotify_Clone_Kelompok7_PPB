import 'package:flutter/material.dart';
import 'package:spotify_group7/data/functions/api.dart';
import 'package:spotify_group7/data/models/music.dart';
import 'package:spotify_group7/design_system/styles/padding_col.dart';
import 'package:spotify_group7/design_system/styles/typograph_col.dart';
import 'package:spotify_group7/design_system/widgets/song_card/custom_song_card.dart';
import 'package:spotify_group7/presentation/home/list_album.dart';
import 'package:spotify_group7/presentation/home/list_artist.dart';
import 'package:spotify_group7/presentation/music_player/music_player.dart';
import '../../data/functions/token_manager.dart';
import '../../design_system/constant/list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Music> musicList = [];

  @override

  void initState(){
    super.initState();
    _loadMusic();
  }

  _loadMusic()async{
    List<Music> loadedMusic = [];
    for (String muiscId in listIdTracks) {
      try {
        bool isTokenValid = await TokenManager.refreshAccessToken();

        if (!isTokenValid) {
          print("Failed to refresh access token. Skip artist id $muiscId");
          continue;
        }

        Music musicData = await MusicApi().fetchMusic(muiscId);
        loadedMusic.add(musicData);
      } catch (e) {
        print("Error loading artist $e");
      }
    }

    setState(() {
      musicList = loadedMusic;
    });
  }

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 40,
                  width: 300,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 40),
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 128,
                  width: 300,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: PaddingCol.xxxl),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  "Today's Hits",
                  style: TypographCol.h1,
                ),
              ),
              SizedBox(height: PaddingCol.md),
              SizedBox(
                height: 200, // Mengatur tinggi untuk tampilan horizontal
                child: musicList.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : GridView.builder(
                  scrollDirection: Axis.horizontal, // Orientasi horizontal
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1, // Tetap 1 item per baris untuk horizontal
                    childAspectRatio: 1, // Atur agar proporsional
                  ),
                  itemCount: musicList.length,
                  itemBuilder: (context, index) {
                    Music music = musicList[index];
                    return CustomSongCard(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => MusicPlayer(music: music),
                          ),
                        );
                      },
                      imagePath: music.songImage ?? "default_song_url",
                      title1: music.songName ?? "Name not Found",
                      title2: music.artistName ?? "Artist name not found",
                    );
                  },
                ),
              ),

              SizedBox(height: PaddingCol.xxxl),
              
              TabBar(
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(
                    child: Text(
                      "Artist",
                      style: TypographCol.h2,
                    ),
                  ),
                  Tab(
                      child: Text(
                        "Album",
                        style: TypographCol.h2,
                      )),
                ],
              ),
              SizedBox(
                height: 500,
                child: TabBarView(
                  children: [
                    ListArtistHome(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: ListAlbumHome(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
