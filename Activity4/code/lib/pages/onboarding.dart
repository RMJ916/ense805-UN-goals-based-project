import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mhcare/pages/stepOne.dart';
import 'package:mhcare/theme/Style.dart';
import 'package:mhcare/theme/colors.dart';
import 'package:mhcare/widget/Buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState1 createState() => _OnboardingState1();
}

class _OnboardingState1 extends State<Onboarding> {
  PageController pageController;
  int page = 0;

  List data = [
    [
      "Welcome to Mhcare",
      "Mhcare is Mental Health care app wich provides daily awareness content."
    ],
    ["Daily Post", "You will get daily post and notification about events."],
    [
      "Live Discussion",
      "You can ask question about mental health and users and experts will  answer it."
    ]
  ];

  @override
  void initState() {
    // checkfirstrun();
    pageController = PageController(initialPage: 0);
    super.initState();
    pageController.addListener(() {
      if (pageController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        print('swiped to right' + page.toString());
        setState(() {
          page = pageController.page.toInt();
        });
      } else {
        print('swiped to left' + page.toString());
        setState(() {
          page = pageController.page.toInt();
        });
      }
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        backgroundColor: transparent,
        elevation: 0,
        brightness: Brightness.light,
        
      ),
      body: Container(
        height: h,
        padding: EdgeInsets.only(bottom: mainMargin, top: mainMargin),
        child: Column(
          children: [
            Expanded(
                child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overscroll) {
                overscroll.disallowGlow();
              },
              child: PageView(
                controller: pageController,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Center(
                            child: Center(
                             
                              child: Image.asset(
                                "assets/welcome.png",
                                fit: BoxFit.fitWidth,
                                width: w * 0.8,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Center(
                            child: Image.asset(
                              "assets/post.png",
                              fit: BoxFit.fitWidth,
                              width: w * 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: mainMargin),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Center(
                            child: Image.asset(
                              "assets/discussion.png",
                              fit: BoxFit.fitWidth,
                              width: w * 0.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )),
            Container(
              padding: EdgeInsets.symmetric(horizontal: mainMargin),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: pageController,
                    count: 3,
                    effect: ExpandingDotsEffect(
                        activeDotColor: primary,
                        dotColor: Colors.black26,
                        dotHeight: 7,
                        dotWidth: 7,
                        spacing: 10,
                        expansionFactor: 2.53),
                  ),
                  SizedBox(height: mainMargin - 3),
                  Text(
                    data[page][0],
                    textAlign: TextAlign.center,
                    style: onbmaintitle,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    data[page][1],
                    textAlign: TextAlign.center,
                    style: onbsubttile,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Hero(
                      tag: "button",
                      child: PrimaryButton(
                        onPressed: () async {
                          if (page < 2) {
                            setState(() {
                              pageController.animateToPage(
                                  pageController.page.toInt() + 1,
                                  duration: Duration(milliseconds: 800),
                                  curve: Curves.easeInOut);
                            });
                          } else {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setBool('onb', true).then((value) {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Stepone()),
                                  (route) => false);
                            });

                            
                          }
                        },
                        width: w,
                        height: buttonHeight,
                        foregroundColor: white,
                        backgroundColor: primary,
                        isloading: false,
                        title: "Continue",
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
