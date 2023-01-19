import 'package:abaad/view/screen/onboard/onboarding_card.dart';
import 'package:abaad/view/screen/onboard/onboarding_footer.dart';
import 'package:flutter/material.dart';
import 'package:abaad/util/images.dart';
import 'on_boarding_data.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
   PageController _controller;
  int _currentPage = 0;
  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PageView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: OnBoardingData.contents.length,
            controller: _controller,
            onPageChanged: (value) {
              _currentPage = value;
              _controller.animateToPage(
                _currentPage,
                duration: const Duration(milliseconds: 600),
                curve: Curves.ease,
              );
              setState(() {});
            },
            // onPageChanged: (value) => setState(() => _currentPage = value),
            itemBuilder: (BuildContext context, int index) {
              final onboardingContent = OnBoardingData.contents[index];
              return OnBoardingCard(
                onboardingContent: onboardingContent,
                currentPage: _currentPage,
                pageController: _controller,
              );
            },
          ),
          Positioned(
            bottom: 40.0,
            left: 90.0,
            right: 90.0,
            child: OnBoardingFooter(
              onboardingContent: const OnboardingModel(
                title: 'title',
                image: Images.bed,
                color: Colors.red,
              ),
              currentPage: _currentPage,
              pageController: _controller,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}


// SizeConfig().init(context);
    // double width = SizeConfig.screenW!;
    // double height = SizeConfig.screenH!;
      // backgroundColor: OnBoardingData.contents[_currentPage],

//       class SizeConfig {
//   static MediaQueryData? _mediaQueryData;
//   static double? screenW;
//   static double? screenH;
//   static double? blockH;
//   static double? blockV;

//   void init(BuildContext context) {
//     _mediaQueryData = MediaQuery.of(context);
//     screenW = _mediaQueryData!.size.width;
//     screenH = _mediaQueryData!.size.height;
//     blockH = screenW! / 100;
//     blockV = screenH! / 100;
//   }
// }