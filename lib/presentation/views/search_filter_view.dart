import 'package:blue_filter/application/selected_category.dart';
import 'package:blue_filter/configuration/front_end_configs.dart';
import 'package:blue_filter/infrastructure/models/category_model.dart';
import 'package:blue_filter/infrastructure/services/categories_services.dart';
import 'package:blue_filter/presentation/elements/search_filter_box.dart';
import 'package:booster/booster.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchFilterPage extends StatefulWidget {
  final String authToken;
  bool firstTime;
  SearchFilterPage({required this.authToken, required this.firstTime});

  @override
  _SearchFilterPageState createState() => _SearchFilterPageState();
}

class _SearchFilterPageState extends State<SearchFilterPage> {
  TextEditingController _searchController = TextEditingController();

  CategoriesServices _categoriesServices = CategoriesServices();
  String? _selectedData;
  List<Datum>? _categoryList = [];
  List<String> selectedCategory = [];

  fetchCategories(String authToken) {
    _categoriesServices
        .getCategories(context, authToken: authToken)
        .then((value) {
      value!.data!.map((e) => _categoryList!.add(e)).toList();
      setState(() {});
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    fetchCategories(widget.authToken);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var category = Provider.of<SelectedCategory>(context);
    if (widget.firstTime) {
      widget.firstTime = false;
      setState(() {});

      category.clearList();
    }
    return Scaffold(
      body: _getUI(context),
    );
  }

  Widget _getUI(BuildContext context) {
    var category = Provider.of<SelectedCategory>(context);
    print(_categoryList!.length);
    return Container(
      height: Booster.screenHeight(context),
      width: Booster.screenWidth(context),
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/splashBG.png'))),
      child: Column(
        children: [
          Booster.verticalSpace(130),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20))),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Booster.verticalSpace(25),
                  Booster.paddedWidget(
                    left: 18,
                    right: 18,
                    child: Booster.dynamicFontSize(
                        label: "Search_Specific_Category".tr(),
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  Booster.verticalSpace(20),
                  _categoryList!.isEmpty
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 200,
                                  childAspectRatio: 2.8,
                                  crossAxisSpacing: 3,
                                  mainAxisSpacing: 8),
                          itemCount: _categoryList!.length,
                          itemBuilder: (BuildContext ctx, index) {
                            return InkWell(
                              onTap: () {
                                if (selectedCategory.contains(
                                    _categoryList![index].id.toString())) {
                                  category.removeItem(
                                      _categoryList![index].id.toString());
                                  selectedCategory.remove(
                                      _categoryList![index].id.toString());
                                  setState(() {});
                                } else {
                                  category.addItem(
                                      _categoryList![index].id.toString());
                                  selectedCategory
                                      .add(_categoryList![index].id.toString());
                                  setState(() {});
                                }
                              },
                              child: SearchFilterBox(
                                  isSelected: selectedCategory.contains(
                                      _categoryList![index].id.toString()),
                                  textColor: FrontEndConfigs.darkTextColor,
                                  text: context.locale == Locale('en')
                                      ? _categoryList![index].name.toString()
                                      : _categoryList![index].nameAr.toString(),
                                  color1: Color(0xffF8F8F8),
                                  color2: Color(0xffDBDBDB)),
                            );
                          }),
                  Booster.verticalSpace(25),
                  Booster.paddedWidget(
                    left: 15,
                    right: 15,
                    child: Row(
                      children: [
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            category.clearList();
                            selectedCategory.clear();
                            setState(() {});
                          },
                          child: Container(
                              height: 48,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: FrontEndConfigs.bgColor),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Center(
                                child: Booster.dynamicFontSize(
                                    label: "reset".tr(),
                                    fontSize: 16,
                                    color: FrontEndConfigs.bgColor),
                              )),
                        )),
                        Booster.horizontalSpace(20),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(0xff6BA3F4),
                                          Color(0xff6BA3F4),
                                          Color(0xff357DEB),
                                        ]),
                                    borderRadius: BorderRadius.circular(4),
                                    color: FrontEndConfigs.bgColor),
                                child: Center(
                                  child: Booster.dynamicFontSize(
                                      label: "update".tr(),
                                      fontSize: 16,
                                      color: Colors.white),
                                )),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
