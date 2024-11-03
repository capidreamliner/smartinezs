import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_icon/animated_icon.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _contentFadeController;
  late Animation<double> _logoSizeAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _contentFadeAnimation;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _logoAnimationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _contentFadeController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _logoSizeAnimation = Tween<double>(begin: 1.0, end: 0.5).animate(
      CurvedAnimation(parent: _logoAnimationController, curve: Curves.easeInOut),
    );

    _logoFadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _logoAnimationController, curve: Curves.easeInOut),
    );

    _contentFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _contentFadeController, curve: Curves.easeIn),
    );

    // Sequence of animations
    Future.delayed(const Duration(seconds: 3), () {
      _logoAnimationController.forward();
    });

    Future.delayed(const Duration(seconds: 6), () {
      _contentFadeController.forward();
    });
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _contentFadeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCard() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(seconds: 1),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: const Color(0xFFF59F42),
      body: DecoratedBox(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/noise.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    Center(
                      child: AnimatedBuilder(
                        animation: _logoAnimationController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _logoFadeAnimation.value,
                            child: Transform.scale(
                              scale: _logoSizeAnimation.value,
                              child: Image(
                                image: AssetImage("assets/logo.png"),
                                fit: BoxFit.contain,
                                width: 700,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Center(
                      child: FadeTransition(
                        opacity: _contentFadeAnimation,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(
                              image: AssetImage("assets/logo2.png"),
                              fit: BoxFit.contain,
                              width: 100,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'HI THERE!',
                              style: GoogleFonts.bagelFatOne(
                                fontSize: width > 700? 120: 70,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Nice to meet you',
                              style: GoogleFonts.leagueSpartan(
                                fontSize: width > 700? 50: 40,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _scrollToCard,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: CircleBorder(),
                              ),
                              child: AnimateIcon(
                                key: UniqueKey(),
                                onTap: () {},
                                iconType: IconType.continueAnimation,
                                height: 70,
                                width: 70,
                                color: const Color(0xFFF59F42),
                                animateIcon: AnimateIcons.downArrow,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Content(),
            ],
          ),
        ),
      ),
    );
  }
}