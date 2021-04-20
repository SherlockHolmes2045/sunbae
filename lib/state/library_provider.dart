import 'package:bot_toast/bot_toast.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:manga_reader/custom/widgets/custom_notification_animation.dart';
import 'package:manga_reader/database/dao/manga_dao.dart';
import 'package:manga_reader/models/manga.dart';
import 'package:manga_reader/state/base_provider.dart';
import 'package:manga_reader/utils/n_exception.dart';


class LibraryProvider extends BaseProvider{

  Either<NException,List<Manga>> library = Right([]);
  List<Manga> libraryList = List<Manga>();

  bool fetched = false;
  MangaDao mangaDao = MangaDao();

  loadLibrary(){
    toggleLoadingState();
    fetched = true;
    mangaDao.getAllSortedByName().then((value){
      fetched = true;
      toggleLoadingState();
      library = Right(value);
      libraryList = value;
      notifyListeners();
    }).catchError((error){
      toggleLoadingState();
      NException exception = NException(error);
    });
  }

  addToLibrary(Manga manga, Size size){
    mangaDao.findManga(manga.url).then((value){
      if(value.isEmpty){
        mangaDao.insert(manga).then((value){
          loadLibrary();
          BotToast.showSimpleNotification(
            align: Alignment.bottomRight,
            duration: Duration(seconds: 4),
            wrapToastAnimation: (controller, cancel, child) =>
                CustomOffsetAnimation(
                    reverse: true,
                    controller: controller,
                    child: Container(
                      width: size.width * 0.85,
                      height: size.height / 10,
                      child: child,
                    )),
            title:  manga.title,
            crossPage: true,
            subTitle: "a été ajouté à votre bibliothèque",
          );
        });
      } else {
        mangaDao.delete(manga.url).then((value) {
          loadLibrary();
          BotToast.showSimpleNotification(
            align: Alignment.bottomRight,
            duration: Duration(seconds: 3),
            wrapToastAnimation: (controller, cancel, child) =>
                CustomOffsetAnimation(
                    reverse: true,
                    controller: controller,
                    child: Container(
                      width: size.width * 0.85,
                      height: size.height / 10,
                      child: child,
                    )),
            title:  manga.title,
            crossPage: true,
            subTitle: "a été retiré votre bibliothèque",
          );
        });
      }
    });
  }
}