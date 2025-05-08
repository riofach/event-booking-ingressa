import 'package:flutter/material.dart';
import '../../core/themes/app_colors.dart';
import '../../core/utils/page_transition.dart';
import '../widgets/primary_button.dart';
import 'auth/login_page.dart';
import 'home_page.dart';
import '../../core/utils/auth_storage.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _numPages = 2;
  // Untuk animasi crossfade dan animasi lainnya
  late AnimationController _animationController;
  late Animation<double> _pageAnimation;
  double _currentPageValue = 0.0;

  final List<String> _backgroundImages = [
    'assets/images/onboarding_bg.png',
    'assets/images/onboarding2_bg.png',
  ];

  final List<String> _titles = [
    'Discover\nAmazing Event\nIn Your City',
    'Experience\nThe Ultimate\nLocal Event Right',
  ];

  final List<String> _buttonTexts = ['Next', 'Get Started'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _pageAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_animationController);

    // Mendengarkan perubahan halaman secara real-time untuk animasi smooth
    _pageController.addListener(() {
      setState(() {
        _currentPageValue = _pageController.page ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      PageTransition.slideLeft(
        page: const LoginPage(),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutQuad,
      ),
    );
  }

  void _navigateToNext() {
    if (_currentPage < _numPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _navigateToLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background images dengan crossfade
          _buildBackgroundImages(),

          // Content slider
          PageView.builder(
            controller: _pageController,
            itemCount: _numPages,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
                // Memicu animasi ketika halaman berubah
                if (page == 1) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }
              });
            },
            itemBuilder: (context, index) {
              // Memberikan efek parallax pada konten
              return _buildPage(index);
            },
          ),

          // Skip button di pojok kanan atas (fixed position)
          Positioned(
            top: 60,
            right: 16,
            child: GestureDetector(
              onTap: _navigateToLogin,
              child: Row(
                children: [
                  Text(
                    'Skip',
                    style: TextStyle(
                      fontFamily: 'Nunito Sans',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: AppColors.white950,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.white950,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          // Back button - muncul hanya pada halaman kedua
          AnimatedBuilder(
            animation: _pageAnimation,
            builder: (context, child) {
              return Positioned(
                top: 60,
                left: 16,
                child: Opacity(
                  opacity: _pageAnimation.value,
                  child: Transform.translate(
                    offset: Offset(-20 * (1 - _pageAnimation.value), 0),
                    child: GestureDetector(
                      onTap: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeInOutCubic,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Background dengan crossfade
  Widget _buildBackgroundImages() {
    return Stack(
      children: [
        // Background dasar
        Positioned.fill(child: Container(color: AppColors.dark950)),

        // Gambar pertama dengan opacity yang berubah berdasarkan page value
        Positioned.fill(
          child: Opacity(
            opacity: 0.4 * (1 - _currentPageValue.clamp(0.0, 1.0)),
            child: Image.asset(_backgroundImages[0], fit: BoxFit.cover),
          ),
        ),

        // Gambar kedua dengan opacity yang berubah berdasarkan page value
        Positioned.fill(
          child: Opacity(
            opacity: 0.4 * _currentPageValue.clamp(0.0, 1.0),
            child: Image.asset(_backgroundImages[1], fit: BoxFit.cover),
          ),
        ),
      ],
    );
  }

  // Membangun halaman individual
  Widget _buildPage(int index) {
    // Nilai offset untuk efek parallax pada teks
    final double parallaxOffset = index - _currentPageValue;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text content dengan efek parallax
          Transform.translate(
            offset: Offset(30 * parallaxOffset, 0),
            child: Opacity(
              opacity: 1 - (parallaxOffset.abs() * 0.5).clamp(0.0, 1.0),
              child: Text(
                _titles[index],
                style: const TextStyle(
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.w800,
                  fontSize: 30,
                  color: Colors.white,
                  height: 1.33,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Subtitle
          Transform.translate(
            offset: Offset(25 * parallaxOffset, 0),
            child: Opacity(
              opacity: (1 - (parallaxOffset.abs() * 0.5).clamp(0.0, 1.0)) * 0.8,
              child: Text(
                'The best event we have prepared for you',
                style: TextStyle(
                  fontFamily: 'Nunito Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: AppColors.white950,
                  height: 1.5,
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),

          // Pagination dots yang bergerak smooth
          _buildSmoothPaginationIndicator(),
          const SizedBox(height: 60),

          // Button section dengan animasi fade
          Transform.translate(
            offset: Offset(20 * parallaxOffset, 0),
            child: Opacity(
              opacity: 1 - (parallaxOffset.abs() * 0.5).clamp(0.0, 1.0),
              child: PrimaryButton(
                text: _buttonTexts[index],
                onPressed: _navigateToNext,
              ),
            ),
          ),
          const SizedBox(height: 28),

          // Login text
          Center(
            child: GestureDetector(
              onTap: _navigateToLogin,
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'Nunito Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: AppColors.white950,
                    height: 1.5,
                  ),
                  children: const [
                    TextSpan(text: 'Already have an account? '),
                    TextSpan(
                      text: 'Sign In',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  // Indikator halaman dengan animasi smooth
  Widget _buildSmoothPaginationIndicator() {
    return SizedBox(
      width: 100,
      child: Stack(
        children: [
          // Indikator statis
          Row(
            children: [
              Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.white950.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(360),
                ),
              ),
              const SizedBox(width: 4),
              Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.white950.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(360),
                ),
              ),
            ],
          ),

          // Indikator aktif dengan animasi
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            left: _currentPage * 52, // 48 width + 4 space
            child: Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.white950,
                borderRadius: BorderRadius.circular(360),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
