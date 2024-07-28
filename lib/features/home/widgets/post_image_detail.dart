import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:photo_view/photo_view.dart';

class FullScreenImage extends StatefulWidget {
  final String imageUrl;

  const FullScreenImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  Offset _offset = Offset.zero;
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.black.withOpacity(0.7),
        actions: [
          IconButton(
            icon: Icon(Icons.info, color: Colors.white),
            onPressed: () {
              // Thực hiện hành động khi nhấn vào icon
            },
          ),
          IconButton(
            icon: Icon(Icons.share, color: Colors.white),
            onPressed: () {
              // Thực hiện hành động khi nhấn vào icon
            },
          ),
        ],
      ),
      body: GestureDetector(
        onVerticalDragStart: (_) => setState(() => _isDragging = true),
        onVerticalDragUpdate: (details) {
          setState(() {
            _offset += details.delta;
          });
        },
        onVerticalDragEnd: (_) {
          if (_offset.distance > 100) {
            Navigator.of(context).pop();
          } else {
            setState(() {
              _offset = Offset.zero;
              _isDragging = false;
            });
          }
        },
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: Duration(milliseconds: 200),
              curve: Curves.easeOut,
              top: _isDragging ? _offset.dy : 0,
              bottom: _isDragging ? -_offset.dy : 0,
              left: 0,
              right: 0,
              child: PhotoView(
                imageProvider: CachedNetworkImageProvider(
                widget.imageUrl,
                cacheManager: 
                  CacheManager(
                    Config(
                      'customCacheKey',
                      stalePeriod: const Duration(days: 7), 
                      maxNrOfCacheObjects: 100, 
                    ),
                  ),
                ),
                backgroundDecoration: BoxDecoration(color: Colors.black),
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.covered * 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
