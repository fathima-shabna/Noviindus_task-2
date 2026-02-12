import 'package:flutter/material.dart';

class MyFeedScreen extends StatelessWidget {
  const MyFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'My Feed',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Feed List
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildFeedItem(
                    userName: 'Anagha Krishna',
                    timeAgo: '5 days ago',
                    imageUrl:
                        'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?q=80&w=600',
                    userImageUrl: 'https://i.pravatar.cc/150?u=anagha',
                    description:
                        'Lorem ipsum dolor sit amet consectetur. Leo ac lorem faucli bus facilisis tellus. At vitae dis commodo nunc sollicitudin elementum suspendisse..',
                  ),
                  _buildFeedItem(
                    userName: 'Gokul Krishna',
                    timeAgo: '5 days ago',
                    imageUrl:
                        'https://images.unsplash.com/photo-1544717305-2782549b5136?q=80&w=600',
                    userImageUrl: 'https://i.pravatar.cc/150?u=gokul',
                    description:
                        'Lorem ipsum dolor sit amet consectetur. Leo ac lorem faucli bus facilisis tellus. At vitae dis commodo nunc sollicitudin elementum suspendisse.. See More',
                  ),
                  _buildFeedItem(
                    userName: 'Michel Jhon',
                    timeAgo: '5 days ago',
                    imageUrl:
                        'https://images.unsplash.com/photo-1570129477492-45c003edd2be?q=80&w=600',
                    userImageUrl: 'https://i.pravatar.cc/150?u=michel',
                    description:
                        'Lorem ipsum dolor sit amet consectetur. Leo ac lorem faucli bus facilisis tellus. At vitae dis commodo nunc sollicitudin elementum suspendisse..',
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedItem({
    required String userName,
    required String timeAgo,
    required String imageUrl,
    required String userImageUrl,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: const BoxDecoration(color: Color(0xFF1A1A1A)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(userImageUrl),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      timeAgo,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Media Preview
          Stack(
            alignment: Alignment.center,
            children: [
              Image.network(
                imageUrl,
                height: 380,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 380,
                  color: Colors.grey[900],
                  child: const Icon(Icons.error_outline, color: Colors.white),
                ),
              ),
              // Play Button Overlay
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.8),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ],
          ),

          // Description
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  height: 1.5,
                ),
                children: [TextSpan(text: description)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
