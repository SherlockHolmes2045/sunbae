import 'package:dartz/dartz.dart';
import 'package:manga_reader/models/chapter.dart';
import 'package:manga_reader/models/manga.dart';
import 'package:manga_reader/networking/services/cloudfare_service.dart';
import 'package:manga_reader/state/base_provider.dart';
import 'package:manga_reader/utils/n_exception.dart';

class MangakawaiiChapterProvider extends BaseProvider {
  Either<NException,List<Chapter>> mangaChapters = Right([]);
  Manga currentManga = Manga();


  getChapters(String catalogName,Manga manga){
    this.currentManga = manga;
    this.toggleLoadingState();
    cloudfareService.mangaChapters(manga, catalogName).then((value){
      mangaChapters = Right(value);
      this.toggleLoadingState();
    }).catchError((error){
      this.toggleLoadingState();
      print(error);
      mangaChapters = Left(error);
    });
  }
}