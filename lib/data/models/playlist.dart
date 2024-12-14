import 'package:spotify_group7/data/models/music.dart';

class PlaylistModel {
  final String id;
  final String authorId;
  final String? title;
  final String? count;
  final String? imageUrl;
  List<Music>? musics;

  PlaylistModel({
    required this.id,
    required this.authorId,
    required this.title,
    required this.count,
    required this.imageUrl,
    this.musics,
  });

  factory PlaylistModel.fromMap(Map<String, dynamic> map) {
    return PlaylistModel(
        id: map['id'] ?? '',
        authorId: map['owner']['id'],
        title: map['name'] ?? '',
        count: '${map['tracks']['total'] ?? 0} songs',
        imageUrl: map['images'] != null && map['images'].isNotEmpty ? map['images'][0]['url'] : '',
        musics: map['tracks'] == null || map['tracks']['items'].isEmpty ? null : List<Music>.from(map['tracks']['items'].map((item) => Music.fromMap(item['track'])))
    );
  }
}