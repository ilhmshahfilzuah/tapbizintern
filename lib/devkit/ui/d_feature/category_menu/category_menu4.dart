import 'package:TapBiz/devkit/config/constant.dart';
import 'package:TapBiz/devkit/model/feature/category_model.dart';
import 'package:TapBiz/devkit/ui/reusable/cache_image_network.dart';
import 'package:TapBiz/devkit/ui/reusable/global_widget.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CategoryMenu4Page extends StatefulWidget {
  @override
  _CategoryMenu4PageState createState() => _CategoryMenu4PageState();
}

class _CategoryMenu4PageState extends State<CategoryMenu4Page> {
  // initialize global widget
  final _globalWidget = GlobalWidget();

  Color _color = Color(0xFF515151);

  List<CategoryModel> _categoryData = [];

  @override
  void initState() {
    _categoryData.add(CategoryModel(
        id: 1, name: 'Fashion', image: GLOBAL_URL + '/category/fashion.png'));
    _categoryData.add(CategoryModel(
        id: 2,
        name: 'Smartphone & Tablets',
        image: GLOBAL_URL + '/category/smartphone.png'));
    _categoryData.add(CategoryModel(
        id: 3,
        name: 'Electronic',
        image: GLOBAL_URL + '/category/electronic.png'));
    _categoryData.add(CategoryModel(
        id: 4, name: 'Otomotif', image: GLOBAL_URL + '/category/otomotif.png'));
    _categoryData.add(CategoryModel(
        id: 5, name: 'Sport', image: GLOBAL_URL + '/category/sport.png'));
    _categoryData.add(CategoryModel(
        id: 6, name: 'Food', image: GLOBAL_URL + '/category/food.png'));
    _categoryData.add(CategoryModel(
        id: 7,
        name: 'Voucher\nGame',
        image: GLOBAL_URL + '/category/voucher_game.png'));
    _categoryData.add(CategoryModel(
        id: 8,
        name: 'Health & Care',
        image: GLOBAL_URL + '/category/health.png'));
    _categoryData.add(CategoryModel(
        id: 9, name: 'Food', image: GLOBAL_URL + '/category/food.png'));
    _categoryData.add(CategoryModel(
        id: 10,
        name: 'Electronic',
        image: GLOBAL_URL + '/category/electronic.png'));
    _categoryData.add(CategoryModel(
        id: 11, name: 'Fashion', image: GLOBAL_URL + '/category/fashion.png'));
    _categoryData.add(CategoryModel(
        id: 12, name: 'Sport', image: GLOBAL_URL + '/category/sport.png'));
    _categoryData.add(CategoryModel(
        id: 13,
        name: 'Voucher\nGame',
        image: GLOBAL_URL + '/category/voucher_game.png'));
    _categoryData.add(CategoryModel(
        id: 14,
        name: 'Smartphone & Tablets',
        image: GLOBAL_URL + '/category/smartphone.png'));
    _categoryData.add(CategoryModel(
        id: 15,
        name: 'Health & Care',
        image: GLOBAL_URL + '/category/health.png'));
    _categoryData.add(CategoryModel(
        id: 16,
        name: 'Otomotif',
        image: GLOBAL_URL + '/category/otomotif.png'));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _globalWidget.globalAppBar(),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(16),
            child: _globalWidget.createDetailWidget(
                title: 'Category Menu 4',
                desc:
                    'This is the example of category menu with image bordering'),
          ),
          Container(
            height: 180,
            child: GridView.count(
              padding: EdgeInsets.symmetric(horizontal: 16),
              primary: false,
              childAspectRatio: 1.04,
              shrinkWrap: true,
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
              crossAxisCount: 2,
              scrollDirection: Axis.horizontal,
              children: List.generate(_categoryData.length, (index) {
                return GestureDetector(
                    onTap: () {
                      Fluttertoast.showToast(
                          msg: 'Click ' + _categoryData[index].name,
                          toastLength: Toast.LENGTH_SHORT);
                    },
                    child: Column(children: [
                      ClipOval(
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: Colors.grey[300]!),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0)),
                              ),
                              padding: EdgeInsets.all(10),
                              child: buildCacheNetworkImage(
                                  width: 20,
                                  height: 20,
                                  url: _categoryData[index].image,
                                  plColor: Colors.transparent))),
                      Flexible(
                        child: Container(
                          margin: EdgeInsets.only(top: 8),
                          child: Text(
                            _categoryData[index].name,
                            style: TextStyle(
                              color: _color,
                              fontWeight: FontWeight.normal,
                              fontSize: 11,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ]));
              }),
            ),
          ),
        ],
      ),
    );
  }
}