import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:manga_reader/constants/assets.dart';
import 'package:manga_reader/custom/widgets/scale_route_transition.dart';
import 'package:manga_reader/screens/Lelscan/manga_details.dart';
import 'package:manga_reader/state/LoadingState.dart';
import 'package:manga_reader/state/lelscan_provider.dart';
import 'package:manga_reader/utils/n_exception.dart';
import 'package:manga_reader/utils/size_config.dart';
import 'package:provider/provider.dart';

class MangaList extends StatefulWidget {
  @override
  _MangaListState createState() => _MangaListState();
}

class _MangaListState extends State<MangaList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context
          .read<LelscanProvider>()
          .getPopularMangaList(Assets.lelscanCatalogName, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return RefreshIndicator(
        child: context.watch<LelscanProvider>().loadingState ==
                LoadingState.loading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.blue),
                ),
              )
            : context
                .select((LelscanProvider provider) => provider)
                .popularMangaList
                .fold((NException error) {
                return Center(
                  child: Text(
                    error.message,
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }, (mangaList) {
                return mangaList.isEmpty
                    ? Center(
                        child: Text(
                          "service is unavailable for now",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : GridView.count(
                      crossAxisCount: 2,
                      padding: EdgeInsets.only(
                        left: SizeConfig.blockSizeHorizontal * 2.5,
                        right: SizeConfig.blockSizeHorizontal * 2.5,
                        top: SizeConfig.blockSizeVertical * 4,
                        bottom: SizeConfig.blockSizeVertical * 4,
                      ),
                      crossAxisSpacing: SizeConfig.blockSizeHorizontal * 2,
                      mainAxisSpacing: SizeConfig.blockSizeVertical,
                      children: List.generate(mangaList.length, (index) {
                        return Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Flexible(
                                child: GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, ScaleRoute(page: LelscanDetail(manga: mangaList[index],)));
                                  },
                                  child: CachedNetworkImage(
                                   imageUrl: mangaList[index]
                                        .thumbnailUrl
                                        .replaceAll(
                                        'http', "https"),
                                    width: double.infinity,
                                    height: 350,
                                    errorWidget: (context,text,data){
                                     return GestureDetector(
                                       onTap: (){
                                         Navigator.push(context, ScaleRoute(page: LelscanDetail(manga: mangaList[index],)));
                                       },
                                       child: Image.asset(
                                         Assets.errorImage,
                                         width: double.infinity,
                                         height: 350,
                                       ),
                                     );
                                    },
                                    //fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: SizeConfig.blockSizeVertical),
                                child: Text(
                                  mangaList[index].title,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    );
              }),
        onRefresh: _refreshData);
  }

  Future _refreshData() async {
    await Future.delayed(Duration(seconds: 1));
    context
        .read<LelscanProvider>()
        .getPopularMangaList(Assets.lelscanCatalogName, 1);
  }
}