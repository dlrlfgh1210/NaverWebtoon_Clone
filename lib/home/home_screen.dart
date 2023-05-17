import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loop_page_view/loop_page_view.dart';
import 'package:naverwebtoon_clone/constant/gaps.dart';
import 'package:naverwebtoon_clone/constant/sizes.dart';
import 'package:naverwebtoon_clone/models/today_webtoon_model.dart';
import 'package:naverwebtoon_clone/persistent_tab_bar.dart';
import 'package:naverwebtoon_clone/services/api_service.dart';

final tabs = [
  "신작",
  "매일+",
  "월",
  "화",
  "수",
  "목",
  "금",
  "토",
  "일",
  "완결",
];

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final Future<List<TodayWebtoonModel>> today = ApiService.getTodayWebtoons();
  int currentPageIndex = 0;

  LoopPageController loopPageController = LoopPageController();
  List<String> pageImage = [
    "https://cdn.pixabay.com/photo/2017/09/25/13/12/puppy-2785074_960_720.jpg",
    "https://cdn.pixabay.com/photo/2016/12/13/05/15/puppy-1903313_960_720.jpg",
    "https://cdn.pixabay.com/photo/2016/02/18/18/37/puppy-1207816_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/07/30/05/53/dog-4372036_960_720.jpg",
    "https://cdn.pixabay.com/photo/2019/02/06/15/18/puppy-3979350_960_720.jpg",
    "https://dimg.donga.com/wps/NEWS/IMAGE/2022/01/28/111500268.2.jpg",
    "https://newsimg.sedaily.com/2023/04/10/29O8ZA6BWK_1.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: tabs.length,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon:
                        const Icon(Icons.cookie, color: Colors.amber, size: 20),
                  ),
                  const SizedBox(
                    width: 50,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon:
                        const Icon(Icons.search, color: Colors.white, size: 20),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          LoopPageView.builder(
                            scrollDirection: Axis.horizontal,
                            controller: loopPageController,
                            onPageChanged: (value) {
                              setState(() {
                                currentPageIndex = value;
                              });
                            },
                            itemCount: pageImage.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Image.network(
                                pageImage[index],
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 5,
                              horizontal: 10,
                            ),
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(500)),
                            child: Text(
                              '${currentPageIndex + 1} / ${pageImage.length}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                    DotsIndicator(
                      dotsCount: pageImage.length,
                      position: currentPageIndex,
                      decorator: const DotsDecorator(
                          color: Colors.grey, activeColor: Colors.purple),
                    )
                  ],
                ),
              ),
              SliverPersistentHeader(
                delegate: PersistentTabBar(),
                pinned: true,
              )
            ];
          },
          body: TabBarView(
            children: [
               FutureBuilder(
                 future: today,
                builder: (context, snapshotToday) {
                  if (snapshotToday.hasData) {
                    return makeTodayList(snapshotToday);
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),

              const Center(
                child: Text('매일+'),
              ),
              const Center(
                child: Text('월요일'),
              ),
              const Center(
                child: Text('화요일'),
              ),
              const Center(
                child: Text('수요일'),
              ),
              const Center(
                child: Text('목요일'),
              ),
              const Center(
                child: Text('금요일'),
              ),
              const Center(
                child: Text('토요일'),
              ),
              const Center(
                child: Text('일요일'),
              ),
              const Center(
                child: Text('완결'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  GridView makeTodayList(AsyncSnapshot<List<TodayWebtoonModel>> snapshotToday) {
    return GridView.builder(
      itemCount: snapshotToday.data!.length,
      padding: const EdgeInsets.all(
        Sizes.size10,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: Sizes.size6,
        mainAxisSpacing: Sizes.size6,
        childAspectRatio: 9 / 20,
      ),
      itemBuilder: (context, index) {
        var todayWebtoon = snapshotToday.data![index];
        return GestureDetector(
          onTap: () {},
          child: Column(
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Sizes.size4),
                ),
                child: AspectRatio(
                  aspectRatio: 9 / 15,
                  child: Image.network(
                        todayWebtoon.img,
                  ),
                ),
              ),
              Gaps.v10,
              Text(
                todayWebtoon.title,
                style: TextStyle(
                    fontSize: Sizes.size10,
                    fontWeight: FontWeight.bold,
                    height: 1.1),
              ),
              Gaps.v8,
              Row(
                children: [
                  Expanded(
                    child: Text(
                      todayWebtoon.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Gaps.h2,
                  FaIcon(
                    FontAwesomeIcons.solidStar,
                    size: Sizes.size4,
                    color: Colors.grey.shade600,
                  ),
                  Gaps.h2,
                  Text(
                    "9.72"
                  )
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
