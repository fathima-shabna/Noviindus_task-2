import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/add_feed_provider.dart';
import '../../providers/home_provider.dart';

class AddFeedsScreen extends StatefulWidget {
  const AddFeedsScreen({super.key});

  @override
  State<AddFeedsScreen> createState() => _AddFeedsScreenState();
}

class _AddFeedsScreenState extends State<AddFeedsScreen> {
  final TextEditingController _descController = TextEditingController();

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final addFeedProvider = context.watch<AddFeedProvider>();
    final homeProvider = context.watch<HomeProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFF131313),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
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
                      'Add Feeds',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: addFeedProvider.isLoading
                          ? null
                          : () async {
                              addFeedProvider.setDescription(
                                _descController.text,
                              );
                              final success = await addFeedProvider
                                  .uploadFeed();
                              if (success && mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Feed uploaded successfully!',
                                    ),
                                  ),
                                );
                                Navigator.pop(context);
                              }
                            },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF211010),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFF4A1010)),
                        ),
                        child: Text(
                          addFeedProvider.isLoading
                              ? 'Uploading...'
                              : 'Share Post',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (addFeedProvider.isLoading)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                  child: Column(
                    children: [
                      LinearProgressIndicator(
                        value: addFeedProvider.uploadProgress,
                        backgroundColor: Colors.white10,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFFC60000),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${(addFeedProvider.uploadProgress * 100).toInt()}% uploaded',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),

              if (addFeedProvider.error != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Text(
                    addFeedProvider.error!,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ),

              const SizedBox(height: 10),

              // Dashed Container for Video
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () => addFeedProvider.pickVideo(),
                  child: CustomPaint(
                    painter: DashedRectPainter(
                      color: Colors.white.withOpacity(0.3),
                    ),
                    child: Container(
                      height: 270,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: addFeedProvider.videoFile != null
                          ? const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 60,
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/Group 2361.png',
                                  height: 60,
                                ),
                                const SizedBox(height: 20),
                                const Text(
                                  'Select a video from Gallery',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Dashed Container for Thumbnail
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () => addFeedProvider.pickImage(),
                  child: CustomPaint(
                    painter: DashedRectPainter(
                      color: Colors.white.withOpacity(0.3),
                    ),
                    child: Container(
                      height: 140,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: addFeedProvider.imageFile != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.file(
                                addFeedProvider.imageFile!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/Group 2364.png',
                                  height: 40,
                                ),
                                const SizedBox(width: 16),
                                const Text(
                                  'Add a Thumbnail',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Add Description
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Add Description',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _descController,
                  maxLines: 4,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 13,
                    height: 1.5,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter your description here...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                    border: InputBorder.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(color: Colors.white10),
              ),
              const SizedBox(height: 16),

              // Categories This Project
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Categories This Project',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'View All',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.chevron_right,
                          color: Colors.white.withOpacity(0.6),
                          size: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Wrap(
                  spacing: 11,
                  runSpacing: 12,
                  children: homeProvider.categories.map((category) {
                    final isSelected = addFeedProvider.selectedCategories
                        .contains(category.id);
                    return GestureDetector(
                      onTap: () =>
                          addFeedProvider.toggleCategory(category.id ?? ''),
                      child: _buildCategoryItem(
                        category.title ?? 'Unknown',
                        isSelected: isSelected,
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String label, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF321313) : const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected
              ? const Color(0xFFC60000)
              : const Color.fromARGB(255, 101, 22, 22).withOpacity(0.6),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
    );
  }
}

class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double dashWidth;

  DashedRectPainter({
    this.color = Colors.white,
    this.strokeWidth = 1.0,
    this.gap = 12.0,
    this.dashWidth = 14.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    Path path = Path();
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        const Radius.circular(16),
      ),
    );

    _drawDashedPath(canvas, path, paint);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    Path dashedPath = Path();
    for (var metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        dashedPath.addPath(
          metric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + gap;
      }
    }
    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
