import 'package:flutter/material.dart';
import 'package:manga_reader/constants/assets.dart';
import 'package:manga_reader/custom/widgets/AppIconWidget.dart';
import 'package:manga_reader/routes.dart';
import 'package:manga_reader/state/lelscan_manga_list_provider.dart';
import 'package:manga_reader/state/lelscan_provider.dart';
import 'package:manga_reader/state/lelscan_top_manga_provider.dart';
import 'package:manga_reader/state/lelscan_updates_provider.dart';
import 'package:manga_reader/state/library_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  Animation<double> iconAnimation;
  AnimationController iconAnimationController;

  @override
  void initState() {
    super.initState();
    iconAnimationController = AnimationController(
        duration: const Duration(seconds: 5), vsync: this);
    iconAnimation =
        Tween<double>(begin: 2, end: 4).animate(iconAnimationController);
    iconAnimationController.repeat(reverse: true);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<LibraryProvider>().loadLibrary();
      context.read<LelscanProvider>().getPopularMangaList(Assets.lelscanCatalogName, 1);
      context.read<LelscanTopMangaProvider>().getTopMangaList(Assets.lelscanCatalogName, 1);
      context.read<LelscanUpdatesProvider>().getUpdatedMangaList(Assets.lelscanCatalogName, 1);
      context.read<LelscanMangaListProvider>().getMangaList(Assets.lelscanCatalogName,context.read<LelscanMangaListProvider>().currentPage);
      Future.delayed(Duration(seconds: 5),(){
        iconAnimationController.stop();
        Navigator.pushReplacementNamed(context, Routes.lelscan);
      });
    });

    //navigate(iconAnimationController);
  }
  @override
  void dispose() {
    // TODO: implement dispose
      iconAnimationController.dispose(); // you need this
      super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.black,
        child: Center(
            child: AnimatedBuilder(
              animation: iconAnimationController,
              builder: (BuildContext context, Widget child) {
                return AppIconWidget(
                    scale: iconAnimationController.value, image: Assets.appLogo);
              },
            )),
      )
    );
  }

}
