import 'package:event_finder/theme/theme.dart';
import 'package:event_finder/widgets/custom_button.dart';
import 'package:flutter/material.dart';

import '../../models/consts.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 750),
      vsync: this,
    );
    _controller.animateTo((_currentPage + 1) / onboardingPageModels.length);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: primaryGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: Column(
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (BuildContext context, Widget? child) {
                    return Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: LinearProgressIndicator(
                          color: secondaryColor,
                          backgroundColor: primaryColorTransparent,
                          minHeight: 8,
                          value: _controller.value),
                    );
                  },
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (idx) {
                      setState(() {
                        _currentPage = idx;
                        _controller.animateTo(
                            (_currentPage + 1) / onboardingPageModels.length);
                      });
                    },
                    children: _getPageModelWidgets(),
                  ),
                ),
                _getButtonView()
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _getPageModelWidgets() {
    return onboardingPageModels
        .map((pageModel) => Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Image.asset(
                      'assets/images/onboarding/${pageModel.imageUrl}.png',
                      color: pageModel.title == 'Nocstar' ? primaryWhite : null,
                    ),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(pageModel.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: pageModel.title == 'Nocstar'
                                      ? secondaryColor
                                      : pageModel.textColor,
                                )),
                      ),
                      Container(
                        constraints: const BoxConstraints(maxWidth: 280),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 8.0),
                        child: Text(pageModel.description,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: pageModel.textColor,
                                )),
                      )
                    ])),
              ],
            ))
        .toList();
  }

  Widget _getButtonView() {
    if (_currentPage + 1 == onboardingPageModels.length) {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: CustomButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'login');
                    },
                    buttonText: 'Login'),
              ),
              const SizedBox(
                width: 30,
              ),
              Expanded(
                child: CustomButton(
                    onPressed: () {
                      Navigator.pushNamed(context, 'register');
                    },
                    buttonText: 'Registrieren'),
              ),
            ],
          ),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomButton(
              onPressed: () {
                _pageController.animateToPage(onboardingPageModels.length - 1,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.linear);
              },
              buttonText: 'Los Geht\'s'),
        ],
      );
    }
  }
}
