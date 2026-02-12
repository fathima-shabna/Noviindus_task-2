import 'package:timeago/timeago.dart' as timeago;

class Feed {
  final int? id;
  final String? video;
  final String? image;
  final String? description;
  final String? userName;
  final String? userImageUrl;
  final String? timeAgo;

  Feed({
    this.id,
    this.video,
    this.image,
    this.description,
    this.userName,
    this.userImageUrl,
    this.timeAgo,
  });

  factory Feed.fromJson(Map<String, dynamic> json) {
    final userData = json['user'] as Map<String, dynamic>?;

    // Format relative time
    String formattedTime = 'Just now';
    if (json['created_at'] != null) {
      try {
        final DateTime dateTime = DateTime.parse(json['created_at']);
        formattedTime = timeago.format(dateTime);
      } catch (e) {
        formattedTime = 'Recently';
      }
    }

    String? imageUrl = json['image'];
    if (imageUrl != null && imageUrl.startsWith('/')) {
      imageUrl = 'https://frijo.noviindus.in$imageUrl';
    }

    String? userImg = userData?['image'];
    if (userImg != null && userImg.startsWith('/')) {
      userImg = 'https://frijo.noviindus.in$userImg';
    }

    return Feed(
      id: json['id'],
      video: json['video'],
      image: imageUrl,
      description: json['description'],
      userName: userData?['name'] ?? 'User',
      userImageUrl: userImg ?? 'https://i.pravatar.cc/150', // Premium fallback
      timeAgo: formattedTime,
    );
  }
}
