import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/my_feed_provider.dart';
import '../../data/models/feed_model.dart';
import '../widgets/feed_video_player.dart';

class MyFeedScreen extends StatefulWidget {
  const MyFeedScreen({super.key});

  @override
  State<MyFeedScreen> createState() => _MyFeedScreenState();
}

class _MyFeedScreenState extends State<MyFeedScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MyFeedProvider>().fetchMyFeeds(isRefresh: true);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<MyFeedProvider>().fetchMyFeeds();
    }
  }

  @override
  Widget build(BuildContext context) {
    final myFeedProvider = context.watch<MyFeedProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: SafeArea(
        child: Column(
          children: [
            // Header
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
                    'My Feeds',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => myFeedProvider.fetchMyFeeds(isRefresh: true),
                color: const Color(0xFFC60000),
                child:
                    myFeedProvider.isLoading && myFeedProvider.myFeeds.isEmpty
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFFC60000),
                        ),
                      )
                    : myFeedProvider.myFeeds.isEmpty
                    ? ListView(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: Center(
                              child: Text(
                                'No feeds uploaded yet',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.zero,
                        itemCount:
                            myFeedProvider.myFeeds.length +
                            (myFeedProvider.isLoadingMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == myFeedProvider.myFeeds.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFFC60000),
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          }

                          final feed = myFeedProvider.myFeeds[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 24),
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Video Section (Intrinsic Aspect Ratio)
                                if (feed.video != null)
                                  FeedVideoPlayer(
                                    videoUrl: feed.video!,
                                    thumbnailUrl: feed.image,
                                  ),

                                // Feed Details
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          feed.description ?? '',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(
                                              0.7,
                                            ),
                                            fontSize: 13,
                                            height: 1.5,
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.grey,
                                          size: 20,
                                        ),
                                        onPressed: () => _showDeleteDialog(
                                          context,
                                          myFeedProvider,
                                          feed,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    MyFeedProvider provider,
    Feed feed,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Delete Feed', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to delete this post?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await provider.deleteFeed(feed.id!);
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Feed deleted successfully')),
                );
              }
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Color(0xFFC60000)),
            ),
          ),
        ],
      ),
    );
  }
}
