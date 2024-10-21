import 'package:flutter/material.dart';
import 'package:project_1_btl/screen/item/ItemCategory.dart';
import 'package:project_1_btl/screen/item/ItemFood.dart';
import 'package:project_1_btl/screen/item/ItemHomeCategory.dart';
import 'package:project_1_btl/screen/Search/SearchScreens.dart';
import 'package:project_1_btl/utils/constants.dart';
import 'package:project_1_btl/widgets/MyBanner.dart';
import 'package:project_1_btl/widgets/MyText.dart';
import 'package:project_1_btl/widgets/TextFieldSearchHome.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy kích thước màn hình từ QuerySize
    final size = MediaQuery.of(context).size;

    // PageController để điều khiển banner
    final PageController _pageController = PageController();

    return Scaffold(
      backgroundColor: ColorApp.whiteColor,
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
                    "Food App",
                    style: TextStyle(
                      fontFamily: "LobsterRegular",
                      fontSize: size.height * 0.025,
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
                        MaterialPageRoute(
                            builder: (context) => SearchScreen()),
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
            Container(
                padding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
                height: size.height * 0.14,
                width: size.width,
                color: ColorApp.whiteColor,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return ItemHomeCategory(size: size);
                  },
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  itemCount: 10,
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: MyText(
                  text: "Bán Chạy",
                  size: 20,
                  color: Colors.black,
                  weight: FontWeight.w600),
            ),
            SizedBox(height: 10),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
                height: size.height * 0.16,
                width: size.width,
                color: ColorApp.whiteColor,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    return ItemCategory(
                      title: "Food 1",
                    );
                  },
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  itemCount: 10,
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: MyText(
                  text: "Gợi ý",
                  size: 20,
                  color: Colors.black,
                  weight: FontWeight.w600),
            ),
            SizedBox(height: 10),
            // ListView cuối cùng sẽ giữ nguyên, scroll cả màn hình
            // Container(
            //   padding: EdgeInsets.symmetric(horizontal: 7, vertical: 7),
            //   height: size.height, // Giới hạn chiều cao
            //   width: size.width,
            //   color: ColorApp.whiteColor,
            //   child:
              ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ItemFood(size: size, title: "Food $index");
                },
                scrollDirection: Axis.vertical,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                itemCount: 5,
              ),
            // ),
          ],
        ),
      ),
    );
  }
}