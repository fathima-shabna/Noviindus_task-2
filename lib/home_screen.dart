import 'package:flutter/material.dart';
import 'add_feeds_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131313), // Slightly lighter black
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 16,
                bottom: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Hello Maria',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Welcome back to Section',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 22,
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?u=maria',
                    ),
                  ),
                ],
              ),
            ),

            // Horizontal Category Section
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildCategoryChip(
                    'Explore',
                    isActive: true,
                    icon: Icons.explore_outlined,
                  ),
                  const SizedBox(width: 8),
                  // Vertical Divider look-alike
                  _buildCategoryChip('Trending'),
                  const SizedBox(width: 8),
                  _buildCategoryChip('All Categories'),
                  const SizedBox(width: 8),
                  _buildCategoryChip('Physics'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Feed Section
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
                  // const SizedBox(height: 2),
                  _buildFeedItem(
                    userName: 'Gokul Krishna',
                    timeAgo: '5 days ago',
                    imageUrl:
                        'https://images.unsplash.com/photo-1544717305-2782549b5136?q=80&w=600',
                    userImageUrl: 'https://i.pravatar.cc/150?u=gokul',
                    description:
                        'Lorem ipsum dolor sit amet consectetur. Leo ac lorem faucli bus facilisis tellus. At vitae dis commodo nunc sollicitudin elementum suspendisse.. See More',
                  ),
                  const SizedBox(
                    height: 100,
                  ), // Spacing for bottom accessibility
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0, right: 0.0),
        child: SizedBox(
          width: 65,
          height: 65,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddFeedsScreen()),
              );
            },
            backgroundColor: const Color(0xFFC60000),
            elevation: 4,
            shape: const CircleBorder(),
            child: const Icon(Icons.add, color: Colors.white, size: 36),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildCategoryChip(
    String label, {
    bool isActive = false,
    IconData? icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF321313) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive
              ? const Color(0xFF4A1010)
              : Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: const Color(0xFFC60000), size: 16),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white.withOpacity(0.6),
              fontSize: 13,
              fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
            ),
          ),
        ],
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
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A), // Feed item background
      ),
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
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
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
