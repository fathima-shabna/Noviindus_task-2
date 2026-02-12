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

    return Feed(
      id: json['id'],
      video: json['video'],
      image: json['image'],
      description: json['description'],
      userName: userData?['name'] ?? 'User',
      userImageUrl:
          userData?['image'] ?? 'https://i.pravatar.cc/150', // Premium fallback
      timeAgo: formattedTime,
    );
  }
}
