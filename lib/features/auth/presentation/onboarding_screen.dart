import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photome/features/auth/domain/onboarding_model.dart';
import 'package:photome/features/auth/providers.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final List<OnboardingPageModel> pages = [
    OnboardingPageModel(
      title: 'Share your beautiful photos.',
      description:
          'Facilis quo maxime sed. Recusandae at consequatur. Possimus quia voluptate. Porro est nesciunt perspiciatis aut amet qui et et aut.',
      image: 'assets/images/undraw_Live_photo_re_4khn.png',
    ),
    OnboardingPageModel(
      title: 'Interact with your feed.',
      description:
          'Magnam et distinctio porro. Doloremque enim ut molestiae labore corporis consequatur enim. Qui saepe assumenda error omnis consequuntur aut velit. Nihil consequuntur animi cupiditate est.',
      image: 'assets/images/undraw_Social_influencer_re_beim.png',
    ),
    OnboardingPageModel(
      title: 'Get together with your friends and have fun.',
      description:
          'Reprehenderit quia amet dolor quia reiciendis dolor quo voluptatem. A tempore qui placeat illum sed architecto similique. Maxime rerum nobis in est.',
      image: 'assets/images/undraw_Work_chat_re_qes4.png',
    ),
  ];

  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        color: pages[_currentPage].bgColor,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: pages.length,
                  onPageChanged: (idx) {
                    setState(() {
                      _currentPage = idx;
                    });
                  },
                  itemBuilder: (context, idx) {
                    final item = pages[idx];
                    return Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Image.asset(
                              item.image,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: Text(
                                  item.title,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: item.textColor,
                                      ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: Text(
                                  item.description,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                        color: item.textColor,
                                      ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: pages
                    .map(
                      (item) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: _currentPage == pages.indexOf(item) ? 20 : 4,
                        height: 4,
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => ref
                          .read(authNotifierProvider.notifier)
                          .toggleBoarding()
                          .whenComplete(
                            () => ref.refresh(authNotifierProvider),
                          ),
                      child: const Text(
                        'Skip',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (_currentPage == pages.length - 1) {
                          await ref
                              .read(authNotifierProvider.notifier)
                              .toggleBoarding()
                              .whenComplete(
                                () => ref.refresh(authNotifierProvider),
                              );
                        } else {
                          await _pageController.animateToPage(
                            _currentPage + 1,
                            curve: Curves.easeInOutCubic,
                            duration: const Duration(milliseconds: 250),
                          );
                        }
                      },
                      child: Text(
                        _currentPage == pages.length - 1 ? 'Finish' : 'Next',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
