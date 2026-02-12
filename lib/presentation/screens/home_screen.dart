import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/home_provider.dart';
import '../../data/models/feed_model.dart';
import '../widgets/feed_video_player.dart';
import 'add_feeds_screen.dart';
import 'my_feed_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().fetchCategories();
      context.read<HomeProvider>().fetchFeeds();
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF131313),
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
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyFeedScreen(),
                        ),
                      );
                    },
                    child: const CircleAvatar(
                      radius: 22,
                      backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/150?u=maria',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Horizontal Category Section
            if (homeProvider.categories.isNotEmpty)
              SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: homeProvider.categories.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final category = homeProvider.categories[index];
                    final isActive =
                        homeProvider.selectedCategoryId == category.id ||
                        (homeProvider.selectedCategoryId == null && index == 0);

                    return GestureDetector(
                      onTap: () => homeProvider.selectCategory(category.id),
                      child: _buildCategoryChip(
                        category.title ?? 'Unknown',
                        isActive: isActive,
                        icon: index == 0 ? Icons.explore_outlined : null,
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 16),

            // Feed Section
            Expanded(
              child: homeProvider.isLoading && homeProvider.feeds.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFC60000),
                      ),
                    )
                  : homeProvider.error != null
                  ? Center(child: Text('Error: ${homeProvider.error}'))
                  : RefreshIndicator(
                      onRefresh: () async {
                        await homeProvider.fetchCategories();
                        await homeProvider.fetchFeeds();
                      },
                      color: const Color(0xFFC60000),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: homeProvider.feeds.length,
                        itemBuilder: (context, index) {
                          final feed = homeProvider.feeds[index];
                          final isPlaying =
                              homeProvider.activeVideoIndex == index;
                          return FeedItemWidget(
                            feed: feed,
                            isPlaying: isPlaying,
                            onVideoInit: () {
                              homeProvider.setActiveVideo(index);
                            },
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: SizedBox(
          width: 76,
          height: 76,
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
            child: const Icon(Icons.add, color: Colors.white, size: 48),
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF321313) : Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isActive ? const Color(0xFF4A1010) : const Color(0xFF333333),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: const Color(0xFFC60000), size: 16),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
              fontSize: 14,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class FeedItemWidget extends StatefulWidget {
  final Feed feed;
  final bool isPlaying;
  final VoidCallback onVideoInit;

  const FeedItemWidget({
    super.key,
    required this.feed,
    required this.isPlaying,
    required this.onVideoInit,
  });

  @override
  State<FeedItemWidget> createState() => _FeedItemWidgetState();
}

class _FeedItemWidgetState extends State<FeedItemWidget> {
  bool _isDescriptionExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Info Header
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey[800],
                  backgroundImage: NetworkImage(
                    widget.feed.userImageUrl ?? 'https://i.pravatar.cc/150',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.feed.userName ?? 'User',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        widget.feed.timeAgo ?? 'Just now',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Video Player Area - Portrait & Seamless
          if (widget.feed.video != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: GestureDetector(
                onTap: widget.isPlaying ? null : widget.onVideoInit,
                child: widget.isPlaying
                    ? FeedVideoPlayer(
                        key: ValueKey(widget.feed.id ?? widget.feed.video),
                        videoUrl: widget.feed.video!,
                        thumbnailUrl: widget.feed.image,
                        autoPlay: true,
                      )
                    : Stack(
                        alignment: Alignment.center,
                        children: [
                          AspectRatio(
                            aspectRatio:
                                16 / 9, // Sane default until initialized
                            child: widget.feed.image != null
                                ? Image.network(
                                    widget.feed.image!,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                : Container(color: Colors.black),
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 1.5,
                              ),
                            ),
                            child: const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

          // Description
          if (widget.feed.description != null &&
              widget.feed.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: _buildDescription(widget.feed.description!),
            ),
        ],
      ),
    );
  }

  Widget _buildDescription(String text) {
    const int truncateAt = 100;
    final bool isLong = text.length > truncateAt;

    if (!isLong || _isDescriptionExpanded) {
      return Text(
        text,
        style: TextStyle(
          color: Colors.white.withOpacity(0.8),
          fontSize: 13,
          height: 1.4,
        ),
      );
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: Colors.white.withOpacity(0.8),
          fontSize: 13,
          height: 1.4,
        ),
        children: [
          TextSpan(text: text.substring(0, truncateAt)),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: GestureDetector(
              onTap: () => setState(() => _isDescriptionExpanded = true),
              child: const Text(
                '... See More',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
