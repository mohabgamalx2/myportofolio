import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

class TutorialsSection extends StatefulWidget {
  const TutorialsSection({super.key});

  @override
  State<TutorialsSection> createState() => _TutorialsSectionState();
}

class _TutorialsSectionState extends State<TutorialsSection> {
  final List<YouTubeVideo> _videos = [
    YouTubeVideo(
      id: '1',
      title: 'Solve all Gradle Problems in Flutter',
      videoId: 'P4CEaxoS0sU', 
      videoUrl: 'https://www.youtube.com/watch?v=P4CEaxoS0sU',
    ),
    YouTubeVideo(
      id: '2',
      title: 'Flutter Payments With Paymob The Easy Way',
      videoId: '59nQISso7c8',
      videoUrl: 'https://www.youtube.com/watch?v=59nQISso7c8',
    ),
    YouTubeVideo(
      id: '3',
      title: 'Firebase Push Notifications in Flutter',
      videoId: 'Mctc831axv0',
      videoUrl: 'https://www.youtube.com/watch?v=Mctc831axv0',
    ),
    YouTubeVideo(
      id: '4',
      title: 'Flutter Maps using Open Street Maps',
      videoId: 'S8eh77Pha0g',
      videoUrl: 'https://www.youtube.com/watch?v=S8eh77Pha0g',
    ),
  ];

  int _currentVideoIndex = 0;
  final CarouselSliderController? _carouselController = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isDesktop = screenSize.width > 900;
    final isTablet = screenSize.width <= 900 && screenSize.width > 600;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80.0),
    
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Modern Section Header
          Column(
            children: [
              Text(
                'MY TUTORIALS',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.7),
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Learn With Me',
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Section Description
          SizedBox(
            width: isDesktop ? 700 : isTablet ? 500 : 300,
            child: Text(
              'Premium Flutter tutorials to boost your development skills',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.8),
                height: 1.5,
              ),
            ),
          ),
          
          const SizedBox(height: 50),
          
          // Video Carousel with Modern Styling
          SizedBox(
            width: screenSize.width * (isDesktop ? 1 : 0.9),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CarouselSlider.builder(
                  carouselController: _carouselController,
                  options: CarouselOptions(
                    height: isDesktop ? 500 : isTablet ? 320 : 240,
                    viewportFraction: isDesktop ? 0.39 : 0.85,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.2,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentVideoIndex = index;
                      });
                    },
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 5),
                    autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  ),
                  itemCount: _videos.length,
                  itemBuilder: (context, index, realIndex) {
                    return AnimatedScale(
                      duration: const Duration(milliseconds: 300),
                      scale: _currentVideoIndex == index ? 1.0 : 0.9,
                      child: VideoThumbnailCard(
                        video: _videos[index],
                        onTap: () => _launchURL(_videos[index].videoUrl),
                        isActive: _currentVideoIndex == index,
                      ),
                    );
                  },
                ),
                
                // Navigation arrows with hover effects
                if (isDesktop || isTablet)
                  Positioned(
                    left: 0,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => _carouselController!.previousPage(),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (isDesktop || isTablet)
                  Positioned(
                    right: 0,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => _carouselController!.nextPage(),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Modern Dot Indicators
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _videos.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _carouselController!.animateToPage(entry.key),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _currentVideoIndex == entry.key ? 24 : 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: _currentVideoIndex == entry.key 
                        ? Colors.red 
                        : Colors.white.withOpacity(0.4),
                  ),
                ),
              );
            }).toList(),
          ),
          
          // Modern CTA Button
          const SizedBox(height: 50),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => _launchURL('https://www.youtube.com/@muhabgamalx2'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.red,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 0,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.play_circle_filled, color: Colors.red),
                    SizedBox(width: 12),
                    Text(
                      'WATCH ALL VIDEOS',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class VideoThumbnailCard extends StatelessWidget {
  final YouTubeVideo video;
  final VoidCallback onTap;
  final bool isActive;
  
  const VideoThumbnailCard({
    super.key,
    required this.video,
    required this.onTap,
    this.isActive = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              if (isActive)
                BoxShadow(
                  color: Colors.red.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: const Offset(0, 10),
                ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                // Thumbnail with gradient overlay
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            'https://img.youtube.com/vi/${video.videoId}/maxresdefault.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[900],
                                child: const Center(
                                  child: Icon(
                                    Icons.play_circle_outline,
                                    color: Colors.white54,
                                    size: 50,
                                  ),
                                ),
                              );
                            },
                          ),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.7),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                // Content overlay
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.9),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          video.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'NEW',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.play_circle_filled,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Play button center
                Positioned.fill(
                  child: Center(
                    child: AnimatedOpacity(
                      opacity: isActive ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withOpacity(0.5),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class YouTubeVideo {
  final String id;
  final String title;
  final String videoId;
  final String videoUrl;
  
  YouTubeVideo({
    required this.id,
    required this.title,
    required this.videoId,
    required this.videoUrl,
  });
}