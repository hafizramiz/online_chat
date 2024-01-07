import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:online_chat/pages/login_page.dart';
import 'package:rive/rive.dart';
import '../../services/shared_pref_service.dart';
import '../get_session_owner_page.dart';
import 'components/animated_btn.dart';

class OnbodingScreen extends StatefulWidget {
  const OnbodingScreen({super.key});

  @override
  State<OnbodingScreen> createState() => _OnbodingScreenState();
}

class _OnbodingScreenState extends State<OnbodingScreen> {
  late RiveAnimationController _btnAnimationController;

  bool isShowSignInDialog = false;

  @override
  void initState() {
    _btnAnimationController = OneShotAnimation(
      "active",
      autoplay: false,
    );
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final String token = CacheManager.token.read;
    final String signOut = CacheManager2.signOut.read;

    print("token:$token");
    if(token.isNotEmpty){

       // Burda yonlendirmeyi cozmem gerekcek.
      print("logine gitti");
      // Burda kontrol yapcam.
      // print(" shared pref sign out:$signOut");
      // if(signOut.isEmpty){
      //   return GetSessionOwnerPage();
      // }else{
      //   return LoginPage();
      // }
      return LoginPage();
    }else{
      print("on board'a gitti");
      return Scaffold(
        body: Stack(
          children: [
            Positioned(
              width: MediaQuery.of(context).size.width * 1.7,
              left: 100,
              bottom: 100,
              child: Image.asset(
                "assets/images/background.jpeg",
              ),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: const SizedBox(),
              ),
            ),
            const RiveAnimation.asset(
              "assets/RiveAssets/shapes.riv",
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: const SizedBox(),
              ),
            ),
            AnimatedPositioned(
              top: isShowSignInDialog ? -50 : 0,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              duration: const Duration(milliseconds: 260),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      const SizedBox(
                        width: 260,
                        child: Column(
                          children: [
                            Text(
                              "Lets connect with other people",
                              style: TextStyle(
                                fontSize: 60,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Poppins",
                                height: 1.2,
                              ),
                            ),
                            SizedBox(height: 16),

                          ],
                        ),
                      ),
                      const Spacer(flex: 2),
                      AnimatedBtn(
                        btnAnimationController: _btnAnimationController,
                        press: () {
                          _btnAnimationController.isActive = true;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 150,)
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
}
