import 'dart:math';

import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'features/my_tutorials_section.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mohab Gamal | Flutter Developer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: GoogleFonts.poppins().fontFamily,
        scaffoldBackgroundColor: const Color(0xFF0A1128),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          displayLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  
  // Define section keys for scrolling
  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _servicesKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _tutorialsKey = GlobalKey(); // Added new key for tutorials section
  final GlobalKey _contactKey = GlobalKey();
  
  Color _appBarColor = Colors.transparent;
  bool _showShadow = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Updated TabController length to include the new tutorials tab
    _tabController = TabController(length: 5, vsync: this);
  }

  void _onScroll() {
    if (_scrollController.offset > 10 && _appBarColor != const Color.fromARGB(255, 8, 29, 97)) {
      setState(() {
        _appBarColor = const Color.fromARGB(255, 3, 17, 67);
        _showShadow = true;
      });
    } else if (_scrollController.offset <= 10 && _appBarColor != Colors.transparent) {
      setState(() {
        _appBarColor = Colors.transparent;
        _showShadow = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSection(int index) {
    _tabController.animateTo(index);
    
    // Scroll to the appropriate section with animation
    // Updated keys array to include tutorials key
    final keys = [_aboutKey, _servicesKey, _projectsKey, _tutorialsKey, _contactKey];
    if (index >= 0 && index < keys.length) {
      final context = keys[index].currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOutCubic,
          alignment: 0.0,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scrollbar(
        controller: _scrollController,
        
        child: Stack(
          children: [
            // Background gradient with subtle animation
            AnimatedContainer(
              duration: const Duration(seconds: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0A1128),
                    Color(0xFF0F2167),
                    Color(0xFF0A1128),
                  ],
                ),
              ),
            ),
            
            // Background animated code (with improved animation)
            Positioned.fill(
              child: AnimatedOpacity(
                duration: const Duration(seconds: 1),
                opacity: 0.2,
                child: CustomPaint(
                  painter: CodeBackgroundPainter(),
                ),
              ),
            ),
            
            // Main content
            SafeArea(
              child: CustomScrollView(
                controller: _scrollController,
                slivers: [
                  // App Bar
                  SliverAppBar(
                    backgroundColor: _appBarColor,
                    elevation: 0,
                    floating: true,
                    pinned: true,
                    expandedHeight: 70,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        decoration: BoxDecoration(
                          color: _appBarColor,
                          borderRadius: BorderRadius.circular(10),
                          
                        ),
                      ),
                    ),
                    title: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 100.0),
                      child: Row(
                        children: [
                          const SizedBox(height: 50),
                          Image.asset('assets/images/logo.png', width: 60),
                          const Spacer(),
                          LayoutBuilder(
                            builder: (context, constraints) {
                              if (MediaQuery.of(context).size.width > 600) {
                                return Row(
                                  children: [
                                    NavButton(title: 'Skills', onTap: () => _scrollToSection(0)),
                                    NavButton(title: 'Experience', onTap: () => _scrollToSection(1)),
                                    NavButton(title: 'Projects', onTap: () => _scrollToSection(2)),
                                    NavButton(title: 'Tutorials', onTap: () => _scrollToSection(3)), // Added new nav button
                                    NavButton(title: 'Contact', onTap: () => _scrollToSection(4)), // Updated index
                                  ],
                                );
                              } else {
                                return IconButton(
                                  icon: const Icon(Icons.menu),
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) => MobileNavMenu(
                                        onItemTap: _scrollToSection,
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  // Hero Section
                  SliverToBoxAdapter(
                    child: HeroSection(key: _heroKey, onContactMeTap: () => _scrollToSection(4), onViewProjectsTap: () => _scrollToSection(2)),
                  ),
                  
                  // About Section
                  SliverToBoxAdapter(
                    child: SkillsSection(key: _aboutKey),
                  ),
                  
                  // Services Section
                  SliverToBoxAdapter(
                    child: ExperienceSection(key: _servicesKey),
                  ),
                  
                  // Projects Section
                  SliverToBoxAdapter(
                    child: ProjectsSection(key: _projectsKey),
                  ),
                  
                  // Tutorials Section (New)
                  SliverToBoxAdapter(
                    child: TutorialsSection(key: _tutorialsKey),
                  ),
                  
                  // Contact Section
                  SliverToBoxAdapter(
                    child: ContactSection(key: _contactKey),
                  ),
                  
                  // Footer
                  SliverToBoxAdapter(
                    child: Footer(onNavTap: _scrollToSection),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavButton extends StatefulWidget {
  final String title;
  final VoidCallback onTap;
  
  const NavButton({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  State<NavButton> createState() => _NavButtonState();
}

class _NavButtonState extends State<NavButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: InkWell(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _isHovered ? Colors.blue.withOpacity(0.2) : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _isHovered ? Colors.blue.withOpacity(0.5) : Colors.transparent,
                width: 1,
              ),
            ),
            child: Text(
              widget.title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: _isHovered ? Colors.blue[300] : Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class MobileNavMenu extends StatelessWidget {
  final Function(int) onItemTap;

  const MobileNavMenu({
    super.key,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0A1128),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('Skills', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              onItemTap(0);
            },
          ),
          ListTile(
            title: const Text('Experience', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              onItemTap(1);
            },
          ),
          ListTile(
            title: const Text('Projects', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              onItemTap(2);
            },
          ),
          ListTile(
            title: const Text('Tutorials', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              onItemTap(3);
            },
          ),
          ListTile(
            title: const Text('Contact', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              onItemTap(4);
            },
          ),
        ],
      ),
    );
  }
} 
class NavItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  
  const NavItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: GoogleFonts.poppins(color: Colors.white),
      ),
      onTap: onTap,
    );
  }
}

class CodeBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Drawing improved code-like elements in the background
    final paint = Paint()
      ..color = Colors.blueAccent.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
      
    // Draw more interesting code-like patterns
    for (int i = 0; i < 30; i++) {
      final dy = i * 40.0;
      final width = (i % 5 + 1) * 100.0;
      final startX = (i % 3) * 50.0;
      
      // Main line
      canvas.drawLine(
        Offset(startX, dy),
        Offset(startX + width, dy),
        paint,
      );
      
      // Small perpendicular lines (branches)
      if (i % 2 == 0) {
        for (int j = 0; j < 3; j++) {
          final branchX = startX + j * 80;
          canvas.drawLine(
            Offset(branchX, dy),
            Offset(branchX, dy - 15),
            paint,
          );
        }
      }
      
      // Add some "brackets"
      if (i % 4 == 0) {
        final bracketX = startX + width + 20;
        canvas.drawLine(
          Offset(bracketX, dy - 20),
          Offset(bracketX, dy + 20),
          paint,
        );
        canvas.drawLine(
          Offset(bracketX, dy - 20),
          Offset(bracketX + 10, dy - 20),
          paint,
        );
        canvas.drawLine(
          Offset(bracketX, dy + 20),
          Offset(bracketX + 10, dy + 20),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HeroSection extends StatefulWidget {
  final VoidCallback onContactMeTap;
  final VoidCallback onViewProjectsTap;
  
  const HeroSection({
    super.key,
    required this.onContactMeTap,
    required this.onViewProjectsTap,
  });

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;
  late Animation<double> _imageAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    
    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    
    _slideIn = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    
    _imageAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeOut),
      ),
    );
    
    // Start the animation after a brief delay
    Future.delayed(const Duration(milliseconds: 200), () {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Stack(
        children: [
          // Background elements
          Positioned(
            right: -100,
            top: MediaQuery.of(context).size.height * 0.2,
            child: AnimatedOpacity(
              duration: const Duration(seconds: 1),
              opacity: 0.1,
              child: FlutterLogo(
                size: MediaQuery.of(context).size.width * 0.7,
              ),
            ),
          ),

          // Main content
          Center(
            child: isMobile
                ? _buildMobileContent()
                : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 40),
                            child: FadeTransition(
                              opacity: _fadeIn,
                              child: SlideTransition(
                                position: _slideIn,
                                child: _buildTextContent(),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 4,
                          child: FadeTransition(
                            opacity: _imageAnimation,
                            child: ScaleTransition(
                              scale: _imageAnimation,
                              child: _buildProfileImage(),
                            ),
                          ),
                        ),
                      ],
                    ),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Hello, I'm",
          style: GoogleFonts.poppins(
            fontSize: 24,
            color: Colors.blue[200],
          ),
        ),
        const SizedBox(height: 15),
        Text(
          "Mohab Gamal",
          style: GoogleFonts.poppins(
            fontSize: 60,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..shader = const LinearGradient(
                colors: [
                  Colors.blue,
                  Colors.lightBlueAccent,
                  Colors.white,
                ],
              ).createShader(const Rect.fromLTWH(0.0, 0.0, 300.0, 80.0)),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 50,
          child: AnimatedTextKit(
            repeatForever: true,
            animatedTexts: [
              TypewriterAnimatedText(
                'Flutter Developer',
                textStyle: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                speed: const Duration(milliseconds: 100),
              ),
              TypewriterAnimatedText(
                'Software Engineer',
                textStyle: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                speed: const Duration(milliseconds: 100),
              ),
             
            ],
          ),
        ),
        const SizedBox(height: 30),
        Text(
          "Mobile Software Engineer with extensive experience in \n developing, integrating, testing, deploying, and maintaining mobile apps.",
          style: GoogleFonts.poppins(
            fontSize: 18,
            color: Colors.grey[300],
          ),
        ),
        const SizedBox(height: 50),
        Row(
          children: [
            ElevatedButton(
              onPressed: widget.onContactMeTap,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                backgroundColor: Colors.blue[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                "Contact Me",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
             const SizedBox(width: 20),

                 ElevatedButton(
                onPressed: () {
                  // Download CV action
                  // This would launch a URL to download the CV
                  launchUrl(Uri.parse("https://drive.google.com/uc?export=download&id=1Btyo7zcoICWfkwDvif6LJ_Ij-wZ8yI8J"));
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.blue[600],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.download,color: Colors.white,),
                    const SizedBox(width: 10),
                    Text(
                      "Download CV",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(width: 20),
            OutlinedButton(
              onPressed: widget.onViewProjectsTap,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                side: const BorderSide(color: Colors.blue, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                "View Projects",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[300],
                ),
              ),
            ),
                       
          ],
        ),
        const SizedBox(height: 50),
  Row(
  mainAxisAlignment: MainAxisAlignment.start,
  children: [
    SocialIconButton(
      icon: FontAwesomeIcons.github,
      url: "https://github.com/themohabgamal",
    ),
    SocialIconButton(
      icon: FontAwesomeIcons.linkedin,
      url: "https://linkedin.com/in/themohabgamal",
    ),
    SocialIconButton(
      icon: FontAwesomeIcons.youtube,
      url: "https://youtube.com/@themohabgamal",
    ),
    SocialIconButton(
      icon: FontAwesomeIcons.phone,
      url: "tel:+201159028516", // Replace with your actual number
    ),
    SocialIconButton(
      icon: FontAwesomeIcons.whatsapp,
      url: "https://wa.me/201159028516", // Replace with your WhatsApp number (no + or dashes)
    ),
    SocialIconButton(
      icon: FontAwesomeIcons.envelope,
      url: "mailto:muhabgamalx2@gmail.com", // Replace with your email
    ),
  ],
)

    
      ],
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Container(
        height: 700,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
        
        ),
        child: Stack(
  alignment: Alignment.center,
  children: [
    // Background image 1
    Positioned.fill(
      child: Image.asset(
        'assets/images/bg.png',
        fit: BoxFit.fill,
                opacity:  const AlwaysStoppedAnimation<double>(0.5),

      ),
    ),

    // Background image 2 (layered on top of bg.png)
    Positioned.fill(
      child: Image.asset(
        'assets/images/bg-1.png',
        fit: BoxFit.cover,
      ),
    ),

    // Animated Profile Image
 CircleAvatar(
  radius: 400, // Half of the diameter
  backgroundImage: AssetImage('assets/images/mohab_profile.png',),
  backgroundColor: Colors.transparent,
),

  ],)
        
      
    ));
  }

  Widget _buildMobileContent() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          FadeTransition(
            opacity: _imageAnimation,
            child: ScaleTransition(
              scale: _imageAnimation,
              child: _buildProfileImage(),
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: FadeTransition(
              opacity: _fadeIn,
              child: SlideTransition(
                position: _slideIn,
                child: _buildTextContent(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final String path;
  final String url;
  
  const SocialButton({
    super.key,
    required this.path,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: InkWell(
        onTap: () async {
          if (await canLaunch(url)) {
            await launch(url);
          }
        },
        child: Container(
          width: 45,
          height: 45,
          child: Center(
            child: Image.asset(
              path,
              width: 40,
            ),
          ),
        ),
      ),
    );
  }
}

class SkillsSection extends StatefulWidget {
  const SkillsSection({super.key});
  @override
  State createState() => _SkillsSectionState();
}

class _SkillsSectionState extends State<SkillsSection> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final ScrollController _scrollController = ScrollController();
  int _expandedIndex = 0;
  int? _hoveredIndex;
  
  final List<SkillCategory> _skillCategories = [
    SkillCategory(
      number: "01",
      title: "State Management",
      description: "Implementation of various state management solutions for optimal data flow in Flutter applications including BLoC, Cubit, Riverpod, and Provider.",
      skills: ["BLoC", "Cubit", "Riverpod", "Provider"],
      iconData: Icons.route,
      color: Colors.blue,
    ),
    SkillCategory(
      number: "02",
      title: "Architecture & Design Patterns",
      description: "Building scalable and maintainable applications with proven architecture patterns such as Clean Architecture and MVVM.",
      skills: ["Clean Architecture", "MVVM"],
      iconData: Icons.architecture,
      color: Colors.blue,
    ),
    SkillCategory(
      number: "03",
      title: "Networking & APIs",
      description: "Creating robust communication channels between your app and external services using REST APIs, WebSockets, and Real-Time Communication.",
      skills: ["REST APIs", "WebSockets", "Real-Time Communication"],
      iconData: Icons.cloud_sync,
      color: Colors.blue,
    ),
    SkillCategory(
      number: "04",
      title: "Database & Storage",
      description: "Implementing efficient data persistence solutions for your applications with Hive, PocketBase, Firestore, and Supabase.",
      skills: ["Hive", "PocketBase", "Firestore", "Supabase"],
      iconData: Icons.storage,
      color: Colors.blue,
    ),
    SkillCategory(
      number: "05",
      title: "Payment & Transactions",
      description: "Integrating secure payment gateways and managing financial transactions with Stripe, Paymob, and PayPal.",
      skills: ["Stripe", "Paymob", "PayPal"],
      iconData: Icons.payment,
      color: Colors.blue,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Column(
        children: [
          // Section Header
          SlideTransition(
            position: Tween(
              begin: const Offset(0, 0.3),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: _controller,
              curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
            )),
            child: FadeTransition(
              opacity: Tween(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: _controller,
                  curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
                ),
              ),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      "My Skills",
                      style: GoogleFonts.poppins(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 700),
                      child: Text(
                        "I don’t just write code , I craft experiences, pixel by pixel.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          height: 1.6,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ),
          ),
          // Skills Accordion
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWideScreen = constraints.maxWidth > 768;
                return isWideScreen
                    ? _buildWideAccordion(constraints.maxWidth)
                    : _buildNarrowAccordion();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWideAccordion(double maxWidth) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1200),
      child: Column(
        children: List.generate(_skillCategories.length, (index) {
          final category = _skillCategories[index];
          final isExpanded = _expandedIndex == index;
          final isHovered = _hoveredIndex == index;
          
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: _controller,
                curve: Interval(
                  0.2 + (index * 0.1),
                  0.6 + (index * 0.1),
                  curve: Curves.easeOut,
                ),
              ),
            ),
            child: MouseRegion(
              onEnter: (_) => setState(() => _hoveredIndex = index),
              onExit: (_) => setState(() => _hoveredIndex = null),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _expandedIndex = index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.only(bottom: 15),
                  height: 110,
                  decoration: BoxDecoration(
                    color: isHovered
                        ? _getGradientColor(category.color)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                   
                   
                  ),
                  transform: isHovered && !isExpanded
                      ? Matrix4.translationValues(0, -5, 0)
                      : Matrix4.identity(),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Row(
                      children: [
                        // Left section - Number + Title
                        Container(
                          width: 300,
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            children: [
                              Text(
                                category.number,
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: isExpanded
                                      ? Colors.white
                                      : category.color,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Text(
                                  category.title,
                                  style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: isExpanded
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.9),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Right section - Description
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: isExpanded
                                      ? Colors.white.withOpacity(0.2)
                                      : Colors.grey.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    category.description,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      height: 1.6,
                                      color: isExpanded
                                          ? Colors.white.withOpacity(0.9)
                                          : Colors.white.withOpacity(0.7),
                                    ),
                                  ),
                                ),
                                // Arrow icon
                                Container(
                                  width: 40,
                                  height: 40,
                                  margin: const EdgeInsets.only(left: 20),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isExpanded
                                        ? Colors.white.withOpacity(0.15)
                                        : category.color.withOpacity(0.15),
                                  ),
                                  child: Icon(
                                    isExpanded
                                        ? Icons.arrow_upward
                                        : Icons.arrow_downward,
                                    color: isExpanded
                                        ? Colors.white
                                        : category.color,
                                    size: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildNarrowAccordion() {
    return Column(
      children: List.generate(_skillCategories.length, (index) {
        final category = _skillCategories[index];
        final isExpanded = _expandedIndex == index;
        final isHovered = _hoveredIndex == index;
        
        return FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
              parent: _controller,
              curve: Interval(
                0.2 + (index * 0.1),
                0.6 + (index * 0.1),
                curve: Curves.easeOut,
              ),
            ),
          ),
          child: MouseRegion(
            onEnter: (_) => setState(() => _hoveredIndex = index),
            onExit: (_) => setState(() => _hoveredIndex = null),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _expandedIndex = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(bottom: 15),
                transform: isHovered && !isExpanded
                    ? Matrix4.translationValues(0, -5, 0)
                    : Matrix4.identity(),
                decoration: BoxDecoration(
                  color: isExpanded
                      ? _getGradientColor(category.color)
                      : isHovered
                          ? const Color(0xFF2D2D2D) // Slightly lighter when hovered
                          : const Color(0xFF1E1E1E), // Dark theme card color
                  borderRadius: BorderRadius.circular(10),
                 
                  
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header (always visible)
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Text(
                              category.number,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: isExpanded
                                    ? Colors.white
                                    : category.color,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                category.title,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isExpanded
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ),
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isExpanded
                                    ? Colors.white.withOpacity(0.15)
                                    : category.color.withOpacity(0.15),
                              ),
                              child: Icon(
                                isExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: isExpanded
                                    ? Colors.white
                                    : category.color,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Content (visible when expanded)
                      AnimatedCrossFade(
                        duration: const Duration(milliseconds: 300),
                        crossFadeState: isExpanded
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        firstChild: const SizedBox(height: 0),
                        secondChild: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: 20,
                          ),
                          child: Text(
                            category.description,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              height: 1.6,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Color _getGradientColor(Color baseColor) {
    // Darker gradient colors for dark theme
    if (baseColor == Colors.purple) {
      return const Color(0xFF3949AB); // Deeper purple
    } else if (baseColor == Colors.blue) {
      return const Color(0xFF1565C0); // Deeper blue
    } else if (baseColor == Colors.indigo) {
      return const Color(0xFF3949AB); // Deeper indigo
    }
    return baseColor;
  }
}

class SkillCategory {
  final String number;
  final String title;
  final String description;
  final List<String> skills;
  final IconData iconData;
  final Color color;

  SkillCategory({
    required this.number,
    required this.title,
    required this.description,
    required this.skills,
    required this.iconData,
    required this.color,
  });
}

class GlassmorphicContainer extends StatelessWidget {
  final Widget child;
  const GlassmorphicContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: child,
    );
  }
}
class ExperienceSection extends StatefulWidget {
  const ExperienceSection({super.key});

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _visible = false;

 final List<ExperienceItem> _experiences = [
  ExperienceItem(
    company: "Genius Systems",
    position: "Mid-Level Flutter Developer",
    period: "Nov 2024 – Present",
    description: "Building a startup e-commerce app focused on a female audience, offering both shopping and beauty salon booking. Implemented responsive UI, integrated complex backend APIs, and optimized user experience for production-ready delivery.",
    technologies: ["Flutter", "Firebase", "REST APIs", "Clean Architecture", "GetX", "UI/UX Design"],
    logoIcon: Icons.shopping_bag,
  ),
  ExperienceItem(
    company: "Meister",
    position: "Flutter Developer",
    period: "Mar 2024 – Nov 2024",
    description: "Delivered high-quality mobile applications for clients in Libya and KSA. Ensured client satisfaction through agile workflows and clean, scalable code. Collaborated with a team of developers to optimize app performance and deployment.",
    technologies: ["Flutter", "Bloc", "Firebase", "Firebase Messaging", "CI/CD", "Arabic Localization"],
    logoIcon: Icons.mobile_friendly,
  ),
  ExperienceItem(
    company: "Fzgroup",
    position: "Flutter Developer (Remote)",
    period: "Oct 2023 – Mar 2024",
    description: "Developed BLE-based communication features, including device discovery, pairing, and data transmission. Also contributed to a fitness app with interactive workout features and intuitive UI.",
    technologies: ["Flutter", "BLE", "Bluetooth", "Fitness APIs", "Dart Streams", "State Management"],
    logoIcon: Icons.bluetooth_connected,
  ),
  ExperienceItem(
    company: "YouTube",
    position: "Content Creator @YouTube",
    period: "2023 – Present",
    description: "Created and published over 65 Flutter development videos with 100K+ views and 3000+ hours of watch time. Educated the Flutter community through tutorials, tips, and hands-on app builds.",
    technologies: ["Flutter", "Video Editing", "Content Strategy", "Community Engagement", "Tutorials"],
    logoIcon: Icons.play_circle_fill,
  ),
];


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();
    
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _visible = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Experience Header
          FadeTransition(
            opacity: Tween<double>(begin: 0, end: 1).animate(
              CurvedAnimation(
                parent: _controller,
                curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  Text(
                    "Professional Experience",
                    style: GoogleFonts.poppins(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..shader = const LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.white,
                          ],
                        ).createShader(const Rect.fromLTWH(0.0, 0.0, 350.0, 70.0)),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "My professional journey in mobile development",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[300],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 60),
          
          // Timeline
          LayoutBuilder(
            builder: (context, constraints) {
              bool isWideScreen = constraints.maxWidth > 800;
              return _buildExperienceTimeline(isWideScreen);
            }
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceTimeline(bool isWideScreen) {
    return Stack(
      children: [
        // Center line
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: 2,
              color: Colors.blue.withOpacity(0.3),
            ),
          ),
        ),
        
        // Experience items
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 100),
          child: Column(
            children: List.generate(_experiences.length, (index) {
              bool isLeft = isWideScreen ? index % 2 == 0 : false;
              
              return SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(isLeft ? -0.5 : 0.5, 0),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: _controller,
                  curve: Interval(
                    0.2 + (index * 0.15),
                    0.6 + (index * 0.15),
                    curve: Curves.easeOut,
                  ),
                )),
                child: FadeTransition(
                  opacity: Tween<double>(begin: 0, end: 1).animate(
                    CurvedAnimation(
                      parent: _controller,
                      curve: Interval(
                        0.2 + (index * 0.15),
                        0.6 + (index * 0.15),
                        curve: Curves.easeOut,
                      ),
                    ),
                  ),
                  child: _buildExperienceItem(
                    _experiences[index], 
                    isLeft,
                    isWideScreen,
                    index == _experiences.length - 1,
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildExperienceItem(
    ExperienceItem experience, 
    bool isLeft, 
    bool isWideScreen,
    bool isLast,
  ) {
    final experienceCard = ExperienceCard(
      experience: experience,
      isLeft: isLeft,
    );
    
    if (!isWideScreen) {
      // Mobile view - always left aligned
      return Padding(
        padding: EdgeInsets.only(bottom: isLast ? 0 : 40),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline node
            Column(
              children: [
                const SizedBox(height: 20),
                _buildTimelineNode(experience.logoIcon),
              ],
            ),
            const SizedBox(width: 20),
            // Experience card
            Expanded(child: experienceCard),
          ],
        ),
      );
    }
    
    // Desktop view - alternating left and right
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side content
          Expanded(
            child: isLeft
                ? experienceCard
                : const SizedBox.shrink(),
          ),
          
          // Timeline node
          Column(
            children: [
              const SizedBox(height: 20),
              _buildTimelineNode(experience.logoIcon),
            ],
          ),
          
          // Right side content
          Expanded(
            child: isLeft
                ? const SizedBox.shrink()
                : experienceCard,
          ),
        ],
      ),
    );
  }
  
  Widget _buildTimelineNode(IconData icon) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.15),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.blue.withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Icon(
        icon,
        color: Colors.blue[300],
        size: 24,
      ),
    );
  }
}

class ExperienceCard extends StatefulWidget {
  final ExperienceItem experience;
  final bool isLeft;
  
  const ExperienceCard({
    super.key,
    required this.experience,
    required this.isLeft,
  });

  @override
  State<ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<ExperienceCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _isHovered ? Colors.blue.withOpacity(0.15) : Colors.white.withOpacity(0.05),
              _isHovered ? Colors.lightBlue.withOpacity(0.1) : Colors.white.withOpacity(0.02),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isHovered ? Colors.blue.withOpacity(0.3) : Colors.white.withOpacity(0.1),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered ? Colors.blue.withOpacity(0.1) : Colors.transparent,
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: widget.isLeft 
              ? CrossAxisAlignment.end 
              : CrossAxisAlignment.start,
          children: [
            Text(
              widget.experience.period,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.blue[300],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.experience.position,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.experience.company,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[300],
              ),
            ),
            
            const SizedBox(height: 12),
            Text(
              widget.experience.description,
              style: GoogleFonts.poppins(
                fontSize: 14,
                height: 1.5,
                color: Colors.grey[400],
              ),
              textAlign: widget.isLeft ? TextAlign.right : TextAlign.left,
            ),
            
            const SizedBox(height: 15),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: widget.isLeft ? WrapAlignment.end : WrapAlignment.start,
              children: widget.experience.technologies.map((tech) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    tech,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue[200],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class ExperienceItem {
  final String company;
  final String position;
  final String period;
  final String description;
  final List<String> technologies;
  final IconData logoIcon;
  
  ExperienceItem({
    required this.company,
    required this.position,
    required this.period,
    required this.description,
    required this.technologies,
    required this.logoIcon,
  });
}
class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
    
      child: Column(
        children: [
          // Section Header
          Column(
            children: [
              Text(
                "My Latest Projects",
                style: GoogleFonts.poppins(
                  fontSize: 42,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Showcasing innovative mobile solutions built with Flutter",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                height: 4,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    colors: [Colors.blueAccent, Colors.transparent],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),

          // Projects Grid - Always 4 columns if width allows
          LayoutBuilder(
            builder: (context, constraints) {
              final availableWidth = constraints.maxWidth;
              final itemWidth = 280.0;
              final spacing = 20.0;
              final crossAxisCount = min(4, availableWidth ~/ (itemWidth + spacing));
              
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: spacing,
                  mainAxisSpacing: spacing,
                  childAspectRatio: 0.8,
                ),
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  return ProjectCard(
                    project: projects[index],
                  );
                },
              );
            },
          ),

          const SizedBox(height: 60),
          
          // Call to Action
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                gradient: const LinearGradient(
                  colors: [Colors.blueAccent, Colors.lightBlue],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: InkWell(
                onTap: () {
                  launchUrl(Uri.parse("https://github.com/themohabgamal"));
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Explore More on GitHub",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.arrow_forward, size: 20, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final Project project;

  const ProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      color: Colors.white.withOpacity(0.05),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Project Image
          SizedBox(
            height: 250,
            width: double.infinity,
            child: Image.asset(
              project.imagePath,
              fit: BoxFit.cover,
            ),
          ),

          // Content Section
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.blueAccent.withOpacity(0.2),
                  ),
                  child: Text(
                    project.category,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Title
                Text(
                  project.title,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),

                // Description
                Text(
                  project.description,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),

                // Tech Chips
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: project.technologies.map((tech) {
                    return Chip(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.blueAccent.withOpacity(0.3)),
                      ),
                      label: Text(
                        tech,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // Buttons
                Row(
                  children: [
                    if (project.playStoreUrl != null)
                      _GlassIconButton(
                        icon: 'assets/images/playstore.png',
                        onTap: () => _launchURL(project.playStoreUrl),
                      ),
                    if (project.appStoreUrl != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: _GlassIconButton(
                          icon: 'assets/images/appstore.png',
                          onTap: () => _launchURL(project.appStoreUrl),
                        ),
                      ),
                    const Spacer(),
                    if (project.githubUrl != null)
                      _GlassIconButton(
                        icon: 'assets/images/github-sign.png',
                        onTap: () => _launchURL(project.githubUrl),
                      ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _launchURL(String? url) async {
    if (url == null) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _GlassIconButton extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;

  const _GlassIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.blueAccent.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Image.asset(
          icon,
          width: 24,
          height: 24,
        ),
      ),
    );
  }
}
// Project Model
class Project {
  final String title;
  final String category;
  final String description;
  final String imagePath;
  final List<String> technologies;
  final String? githubUrl;
  final String? appStoreUrl;
  final String? playStoreUrl;

  const Project({
    required this.title,
    required this.category,
    required this.description,
    required this.imagePath,
    required this.technologies,
    this.githubUrl,
    this.appStoreUrl,
    this.playStoreUrl,
  });
}

final List<Project> projects = [
  Project(
    title: "Beneshty",
    category: "E-Commerce",
    description: "With more than 500k User base, Beneshty is a platform for buying and selling products. ",
    imagePath: "assets/images/beneshty.png",
    technologies: ["Clean Arch","Payment","Notifications"],
    playStoreUrl: "https://play.google.com/store/apps/details?id=com.BeNeshtyStore&hl=en",
    appStoreUrl: "https://apps.apple.com/eg/app/beneshty/id1596605724?l=en",
  ),

  Project(
    title: "المنصة",
    category: "Education",
    description: "A complete educational platform for teachers and students. ",
    imagePath: "assets/images/manasa.jpeg",
    technologies: [ "Video Streaming", "Screenshots Disabled", "Payments"],
    playStoreUrl: "https://play.google.com/store/apps/details?id=com.mickode.elmnasa&pli=1",
  ),
  Project(
    title: "EasyBio",
    category: "Education",
    description: "A teacher assistant app that enhances the educational experience by providing a platform for viewing instructional videos and streaming content.",
    imagePath: "assets/images/drrrr.jpeg",
    technologies: ["Flutter", "Video Streaming", "Subscriptions"],
    playStoreUrl: "https://play.google.com/store/apps/details?id=com.mickode.easy_bio&hl=en"
  ),
  Project(
    title: "Wassla",
    category: "E-Commerce",
    description: "AI-powered eCommerce app with recommendation system, admin dashboard, payment gateway, and chatbot product search.",
    imagePath: "assets/images/wassla.png",
    technologies: [ "AI Recommendations", "Paymob", "Chatbot"],
    githubUrl: "https://github.com/themohabgamal/Wassla?tab=readme-ov-file",
  ),
];
class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Section Title
          Text(
            "CONTACT",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white70,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Get In Touch",
            style: GoogleFonts.poppins(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 40),

          // Contact Information - Centered
          Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 60,
            children: [
              _buildContactItem(
                icon: Icons.email,
                text: "muhabgamalx2@gmail.com",
                onTap: () => launchUrl(Uri.parse("mailto:muhabgamalx2@gmail.com")),),
              _buildContactItem(
                icon: Icons.phone,
                text: "+20 115 902 8516",
                onTap: () => launchUrl(Uri.parse("tel:+201159028516")),),
              _buildContactItem(
                icon: Icons.location_on,
                text: "Cairo, Egypt",
                onTap: () {}),
            ],
          ),
          const SizedBox(height: 40),

      
        ],
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 16),
            Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, VoidCallback onTap) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}
class Footer extends StatelessWidget {
  final void Function(int) onNavTap;

  const Footer({super.key, required this.onNavTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png', width: 80),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "Flutter Developer | Mobile App Specialist",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 30),
          LayoutBuilder(
            builder: (context, constraints) {
              final navLinks = [
                {"title": "Home", "section": "home"},
                {"title": "Skills", "section": "skills"},
                {"title": "Experience", "section": "experience"},
                {"title": "Projects", "section": "projects"},
                {"title": "Contact", "section": "contact"},
              ];

              Widget buildLinks(List<Map<String, String>> links) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: links.map((link) {
                    return FooterLink(
                      title: link['title']!,
                      onTap: () => onNavTap(navLinks.indexOf(link)),
                    );
                  }).toList(),
                );
              }

              if (constraints.maxWidth > 600) {
                return buildLinks(navLinks);
              } else {
                return Column(
                  children: [
                    buildLinks(navLinks.sublist(0, 3)), // Home, About, Services
                    const SizedBox(height: 10),
                    buildLinks(navLinks.sublist(3)),    // Projects, Contact
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SocialIconButton(icon: FontAwesomeIcons.github, url: "https://github.com/themohabgamal"),
              SocialIconButton(icon: FontAwesomeIcons.linkedin, url: "https://linkedin.com/in/themohabgamal"),
              SocialIconButton(icon: FontAwesomeIcons.youtube, url: "https://youtube.com/@themohabgamal"),
            ],
          ),
          const SizedBox(height: 30),
          Text(
            "© ${DateTime.now().year} Mohab Gamal. All rights reserved.",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}

class FooterLink extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  
  const FooterLink({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: InkWell(
        onTap: onTap,
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class SocialIconButton extends StatelessWidget {
  final IconData icon;
  final String url;
  
  const SocialIconButton({
    super.key,
    required this.icon,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: InkWell(
        onTap: () async {
          if (await canLaunch(url)) {
            await launch(url);
          }
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: FaIcon(
              icon,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}