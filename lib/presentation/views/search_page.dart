import 'package:blue_filter/application/selected_category.dart';
import 'package:blue_filter/configuration/back_end_configs.dart';
import 'package:blue_filter/infrastructure/models/auth/successful_login_model.dart';
import 'package:blue_filter/infrastructure/models/nearby_service_provider.dart';
import 'package:blue_filter/infrastructure/services/search_services.dart';
import 'package:blue_filter/presentation/elements/appDrawer.dart';
import 'package:blue_filter/presentation/elements/search_file.dart';
import 'package:blue_filter/presentation/elements/service_around_me_card.dart';
import 'package:blue_filter/presentation/views/search_filter_view.dart';
import 'package:booster/booster.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();

  SearchProviderServices _searchProviderServices = SearchProviderServices();
  final LocalStorage storage = new LocalStorage(BackendConfigs.localDB);

  bool initialized = false;

  late SuccessfulLoginModel userModel;

  var userData;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: storage.ready,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!initialized) {
            var items = storage.getItem(BackendConfigs.loginUserData);

            if (items != null) {
              print(items);
              userModel = SuccessfulLoginModel(
                  data: Data(
                      token: items['data']['token'],
                      user: User(
                          id: items['data']['user']['id'],
                          email: "",
                          name: items['data']['user']['name'],
                          type: "",
                          locale: items['data']['user']['locale'],
                          service_provider_clicks: items['data']['user']
                              ['service_provider_clicks'],
                          profileCompleted: "",
                          category: items['data']['user']['category'],
                          profileImage: "",
                          profileThumbnail: "",
                          phone: items['data']['user']['phone'],
                          longitude: items['data']['user']['longitude'],
                          latitude: items['data']['user']['latitude'],
                          bio: items['data']['user']['bio'],
                          notification: "",
                          facebook: items['data']['user']['facebook'],
                          instagram: items['data']['user']['instagram'],
                          twitter: items['data']['user']['twitter'],
                          spotify: items['data']['user']['spotify'],
                          address: items['data']['user']['address'],
                          distance: "")));
            }
            print(items);

            initialized = true;
          }
          return snapshot.data == null
              ? CircularProgressIndicator()
              : _getCreateUI(context, userModel);
        });
  }

  @override
  void dispose() {
    var category = Provider.of<SelectedCategory>(context);
    category.clearList();
    // TODO: implement dispose
    super.dispose();
  }

  Widget _getCreateUI(BuildContext context, SuccessfulLoginModel _userModel) {
    return Scaffold(
      body: _getUI(context, _userModel),
      drawer: AppDrawer(),
    );
  }

  Widget _getUI(BuildContext context, SuccessfulLoginModel _model) {
    var categoryList = Provider.of<SelectedCategory>(context);
    print("Category List : ${categoryList.getCategoryList().length}");
    return Container(
      height: Booster.screenHeight(context),
      width: Booster.screenWidth(context),
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/splashBG.png'))),
      child: Column(
        children: [
          Booster.verticalSpace(60),
          SearchField(
            label: "search_text".tr(),
            controller: _searchController,
            onSubmitted: (val) {
              setState(() {});
            },
          ),
          Booster.verticalSpace(20),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20))),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Booster.verticalSpace(16),
                  InkWell(
                    onTap: () {
                      _searchController.clear();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SearchFilterPage(
                                    authToken: _model.data!.token,
                                    firstTime: true,
                                  )));
                    },
                    child: Booster.paddedWidget(
                      left: 20,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          'assets/images/todo.png',
                          height: 27,
                          width: 27,
                        ),
                      ),
                    ),
                  ),
                  Booster.verticalSpace(10),
                  FutureProvider.value(
                    value: _searchController.text.isNotEmpty
                        ? _searchProviderServices.getSpecificProvider(context,
                            authToken: _model.data!.token,
                            pageNo: 1,
                            query: _searchController.text)
                        : categoryList.getCategoryList().isNotEmpty
                            ? _searchProviderServices.getProviderByID(context,
                                authToken: _model.data!.token,
                                pageNo: 1,
                                query: categoryList.getCategoryList())
                            : _searchProviderServices.getSpecificProvider(
                                context,
                                authToken: _model.data!.token,
                                pageNo: 1,
                                query: _searchController.text),
                    initialData: NearbyServiceModel(
                        data: [
                          Datum(
                              id: -1,
                              email: "Loading",
                              name: "Loading",
                              type: "type",
                              locale: "locale",
                              profileCompleted: "profileCompleted",
                              isApproved: "isApproved",
                              category: [
                                {
                                  "id": 1,
                                  "name": "Plumber",
                                  "name_ar": "\u0633\u0628\u0651\u0627\u0643",
                                  "color": "#ff0000"
                                }
                              ],
                              profileImage: "profileImage",
                              profileThumbnail: "profileThumbnail",
                              phone: "phone",
                              longitude: "longitude",
                              latitude: "latitude",
                              bio: "bio",
                              notification: "notification",
                              facebook: "facebook",
                              instagram: "instagram",
                              twitter: "twitter",
                              spotify: "spotify",
                              address: "address",
                              distance: 1.2),
                        ],
                        links: Links(
                            first: "first",
                            last: "last",
                            prev: "prev",
                            next: "next"),
                        meta: Meta(
                            currentPage: 2,
                            from: 3,
                            lastPage: 1,
                            links: [
                              Link(url: "url", label: "label", active: true)
                            ],
                            path: "path",
                            perPage: 20,
                            to: 1,
                            total: 10)),
                    builder: (serviceProviderCtxt, child) {
                      print(serviceProviderCtxt
                          .watch<NearbyServiceModel>()
                          .data!
                          .length);
                      return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: serviceProviderCtxt
                              .watch<NearbyServiceModel>()
                              .data!
                              .length,
                          shrinkWrap: true,
                          itemBuilder: (context, i) {
                            return serviceProviderCtxt
                                        .watch<NearbyServiceModel>()
                                        .data![i]
                                        .name ==
                                    "Loading"
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : ServiceAroundMeCard(
                                    serviceProviderCtxt
                                        .watch<NearbyServiceModel>()
                                        .data![i],
                                    "en");
                          });
                    },
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
