import 'package:flutter/material.dart';
import 'package:project_1_btl/model/Category.dart';
import 'package:project_1_btl/model/Food.dart';
import 'package:project_1_btl/repository/CategoryRepository.dart';
import 'package:project_1_btl/repository/FoodRepository.dart';
import 'package:project_1_btl/screen/Main/CategoryHomeScreen.dart';
import 'package:project_1_btl/screen/item/ItemCategory.dart';
import 'package:project_1_btl/screen/item/ItemFood.dart';
import 'package:project_1_btl/screen/item/ItemHomeCategory.dart';
import 'package:project_1_btl/screen/Search/SearchScreens.dart';
import 'package:project_1_btl/services/CategoryService.dart';
import 'package:project_1_btl/services/FoodService.dart';
import 'package:project_1_btl/utils/constants.dart';
import 'package:project_1_btl/widgets/CenterCircularProgress.dart';
import 'package:project_1_btl/widgets/MyBanner.dart';
import 'package:project_1_btl/widgets/MyText.dart';
import 'package:project_1_btl/widgets/TextFieldSearchHome.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final CategoryRepository _categoryRepository =
        CategoryRepository(CategoryService());

    final FoodRepository _foodRepository =
    FoodRepository(FoodService());

    // Lấy kích thước màn hình từ QuerySize
    final size = MediaQuery.of(context).size;

    // PageController để điều khiển banner
    final PageController _pageController = PageController();

    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Controller phần trên cùng với tiêu đề và TextField tìm kiếm
            Container(
              width: size.width,
              padding: EdgeInsets.only(
                left: size.width * 0.03,
                top: size.height * 0.03,
                bottom: size.height * 0.015,
                right: size.width * 0.03,
              ),
              color: ColorApp.whiteColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text tiêu đề căn lề trái
                  Text(
                    "Food's Kitchen",
                    style: TextStyle(
                      fontFamily: "LobsterRegular",
                      fontSize: size.height * 0.03,
                      // 2.5% chiều cao màn hình
                      fontWeight: FontWeight.bold,
                      color: ColorApp.brightOrangeColor,
                    ),
                  ),
                  // TextField tìm kiếm
                  SizedBox(height: size.height * 0.01),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SearchScreen()),
                      );
                    },
                    child: TextFieldSearchHome(
                      hintText: "Tìm Kiếm Đồ ăn / Thức uống",
                      icon: Icons.search,
                      iconSize: size.height * 0.025,
                      hintColor: Colors.grey,
                      background: Color(0xffc9c9c9),
                      height: 38,
                    ),
                  )
                ],
              ),
            ),

            // Stack chứa PageView và SmoothPageIndicator
            MyBanner(pageController: _pageController, size: size),

            // GridView to display two rows of items
            FutureBuilder<List<Category>>(
              future: _categoryRepository.getCategories(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CenteredCircularProgress();
                } else if (snapshot.hasError) {
                  return CenteredCircularProgress();
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Không có gợi ý nào.'));
                } else {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
                    height: size.height * 0.14,
                    decoration: new BoxDecoration(boxShadow: [
                      new BoxShadow(
                        color: Color(0xE4FFBF61),
                        blurRadius: 25.0,
                        offset: Offset(0.0, 0.75),
                      ),
                    ]),
                    width: size.width,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CategoryHomeScreen(
                                  selectedCategory: snapshot.data![index],
                                   // Truyền danh mục
                                ),
                              ),
                            );
                          },
                          child: ItemHomeCategory(category: snapshot.data![index]),
                        );
                      },
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      itemCount: snapshot.data!.length,
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 15,),
            // "Bán Chạy" Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(10), // Bo góc toàn bộ phần
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // Hiệu ứng đổ bóng
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10), // Khoảng cách bên trong Container
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tiêu đề "Bán Chạy"
                    MyText(
                      text: "Bán Chạy",
                      size: 20,
                      color: ColorApp.brightOrangeColor,
                      weight: FontWeight.w600,
                    ),
                    // Danh sách "Bán Chạy"
                    FutureBuilder<List<Food>>(
                      future: _foodRepository.getTopTenBestSellers(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CenteredCircularProgress();
                        } else if (snapshot.hasError) {
                          return CenteredCircularProgress();
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(
                            child: Text('Không có sản phẩm bán chạy.'),
                          );
                        } else {
                          return SizedBox(
                            height: size.height * 0.2, // Chiều cao của danh sách
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding:
                              const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final food = snapshot.data![index];
                                return ItemCategory(
                                  food: food,
                                );
                              },
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            // "Gợi ý" Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(10), // Bo góc toàn bộ phần
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // Hiệu ứng đổ bóng
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(10), // Khoảng cách bên trong Container
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tiêu đề "Gợi ý"
                    MyText(
                      text: "Gợi ý",
                      size: 20,
                      color: ColorApp.brightOrangeColor,
                      weight: FontWeight.w600,
                    ),

                    // Danh sách "Gợi ý"
                    FutureBuilder<List<Food>>(
                      future: _foodRepository.getDailyRandomFoods(), // Lấy dữ liệu gợi ý
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CenteredCircularProgress();
                        } else if (snapshot.hasError) {
                          return CenteredCircularProgress();
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(
                            child: Text('Không có gợi ý nào.'),
                          );
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(), // Ngăn cuộn riêng
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final food = snapshot.data![index];
                              return ItemFood(
                                size: size,
                                food: food, // Truyền dữ liệu food vào ItemFood
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),


            // ),
          ],
        ),
      ),
    );
  }
}
