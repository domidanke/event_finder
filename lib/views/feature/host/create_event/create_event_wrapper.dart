import 'package:event_finder/theme/theme.dart';
import 'package:event_finder/views/feature/host/create_event/create_event_page_1.dart';
import 'package:event_finder/views/feature/host/create_event/create_event_page_4.dart';
import 'package:event_finder/widgets/kk_button.dart';
import 'package:flutter/material.dart';

import 'create_event_page_2.dart';
import 'create_event_page_3.dart';

class CreateEventWrapper extends StatefulWidget {
  const CreateEventWrapper({Key? key}) : super(key: key);

  @override
  State<CreateEventWrapper> createState() => _CreateEventWrapperState();
}

class _CreateEventWrapperState extends State<CreateEventWrapper> {
  final pages = [
    const CreateEventPage1(),
    const CreateEventPage2(),
    const CreateEventPage3(),
    const CreateEventPage4(),
  ];
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
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
                          child: item,
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Current page indicator
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: pages
                      .map((item) => AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: _currentPage == pages.indexOf(item) ? 15 : 8,
                            height:
                                _currentPage == pages.indexOf(item) ? 15 : 8,
                            margin: const EdgeInsets.all(2.0),
                            decoration: BoxDecoration(
                                color: _currentPage == pages.indexOf(item)
                                    ? primaryColor
                                    : primaryWhite,
                                borderRadius: BorderRadius.circular(30.0)),
                          ))
                      .toList(),
                ),
              ),

              // Bottom buttons
              SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    KKButton(
                      onPressed: () {
                        _currentPage > 0
                            ? _pageController.animateToPage(_currentPage - 1,
                                curve: Curves.easeInOutCubic,
                                duration: const Duration(milliseconds: 250))
                            : Navigator.pop(context);
                      },
                      buttonText: _currentPage == 0 ? 'Abbrechen' : 'Zurueck',
                    ),
                    KKButton(
                      onPressed: () {
                        if (_currentPage == pages.length - 1) {
                          print('finish');
                        } else {
                          _pageController.animateToPage(_currentPage + 1,
                              curve: Curves.easeInOutCubic,
                              duration: const Duration(milliseconds: 250));
                        }
                      },
                      buttonText: _currentPage == pages.length - 1
                          ? 'Erstellen'
                          : 'Weiter',
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
