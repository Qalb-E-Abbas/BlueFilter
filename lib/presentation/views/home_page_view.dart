import 'package:blue_filter/application/name_state.dart';
import 'package:blue_filter/configuration/back_end_configs.dart';
import 'package:blue_filter/configuration/front_end_configs.dart';
import 'package:blue_filter/infrastructure/models/auth/successful_login_model.dart';
import 'package:blue_filter/infrastructure/models/postModel.dart';
import 'package:blue_filter/infrastructure/services/post_services.dart';
import 'package:blue_filter/infrastructure/services/profile_services.dart';
import 'package:blue_filter/presentation/elements/appDrawer.dart';
import 'package:blue_filter/presentation/elements/custom_appBar.dart';
import 'package:blue_filter/presentation/helper/get_address.dart';
import 'package:blue_filter/presentation/views/single_blog.dart';
import 'package:booster/booster.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomePageView extends StatefulWidget {
  final SuccessfulLoginModel model;
  HomePageView(this.model);
  @override
  _HomePageViewState createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  PostServices _postServices = PostServices();

  final LocalStorage storage = new LocalStorage(BackendConfigs.localDB);
  ProfileServices _profileServices = ProfileServices();
  bool initialized = false;
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  SuccessfulLoginModel? userModel;
  String name = "";
  String _imageUrl = "";
  var userData;
  // Future<void> _initFcm() async {
  //   _firebaseMessaging.getToken().then((token) {
  //     _profileServices.addToken(context,
  //         deviceToken: token!, authToken: widget.model.data!.token);
  //   });
  // }

  @override
  initState() {
    // _initFcm();
    UserNameState.getUserLoggedInSharedPreference()
        .then((value) => name = value!);
    _imageUrl = "";
    setState(() {});
    UserNameState.getImage().then((value) {
      _imageUrl = value!;
      setState(() {});
    });
    getPermission();
    super.initState();
  }

  getPermission() async {
    await Geolocator.requestPermission();
  }

  int counter = 0;

  @override
  Widget build(BuildContext context) {
    print("MODEL FROM");
    print(widget.model.data!.user.name);
    print("MODEL FROM");
    getReadableAddress();
    return FutureBuilder(
        future: storage.ready,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!initialized) {
            var items = storage.getItem(BackendConfigs.loginUserData);
            if (items != null) {
              userModel = SuccessfulLoginModel(
                  data: Data(
                      token: items['data']['token'],
                      user: User(
                          id: items['data']['user']['id'],
                          email: items['data']['user']['email'],
                          service_provider_clicks: items['data']['user']
                              ['service_provider_clicks'],
                          name: items['data']['user']['name'],
                          type: "",
                          locale: items['data']['user']['locale'],
                          profileCompleted: items['data']['user']
                              ['profile_completed'],
                          category: items['data']['user']['category'],
                          profileImage: items['data']['user']['profile_image'],
                          profileThumbnail: items['data']['user']
                              ['profile_thumbnail'],
                          phone: items['data']['user']['phone'],
                          longitude: items['data']['user']['longitude'],
                          latitude: items['data']['user']['latitude'],
                          bio: items['data']['user']['bio'],
                          notification: items['data']['user']['notification'],
                          facebook: items['data']['user']['facebook'],
                          instagram: items['data']['user']['instagram'],
                          twitter: items['data']['user']['twitter'],
                          spotify: items['data']['user']['spotify'],
                          address: items['data']['user']['address'],
                          distance: "")));
            }
            initialized = true;
          }
          return snapshot.data == null
              ? CircularProgressIndicator()
              : _getCreateUI(context, userModel);
        });
  }

  Widget _getCreateUI(BuildContext context, SuccessfulLoginModel? _model) {
    return Scaffold(
        drawer: AppDrawer(),
        body: SlidingUpPanel(
          parallaxEnabled: true,
          minHeight: 335,
          maxHeight: 600,
          borderRadius: BorderRadius.circular(20),
          panel: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Booster.verticalSpace(27),
              Booster.paddedWidget(
                left: 18,
                right: 18,
                child: Booster.dynamicFontSize(
                    label: "welcome".tr(),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Booster.paddedWidget(
                  top: 6,
                  left: 28,
                  right: 18,
                  child: Booster.dynamicFontSize(
                      label: "interesting".tr(),
                      fontSize: 17,
                      color: FrontEndConfigs.darkTextColor,
                      fontWeight: FontWeight.w400)),
              Booster.verticalSpace(5),
              FutureProvider.value(
                value: _postServices.getPosts(context,
                    authToken: storage
                        .getItem(BackendConfigs.loginUserData)['data']['token'],
                    pageNo: 1),
                initialData: PostModel(),
                builder: (ct, child) {
                  return Expanded(
                    child: ct.watch<PostModel>().data == null
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: ct.watch<PostModel>().data?.length,
                            itemBuilder: (_, i) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SingleBlogView(
                                              ct.watch<PostModel>().data![i])));
                                },
                                child: Container(
                                  color: Colors.blue,
                                  child: Column(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: ct
                                                .watch<PostModel>()
                                                .data![i]
                                                .featuredImage ??
                                            "",
                                        placeholder: (context, url) => Container(
                                            height: 40,
                                            width: double.infinity,
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator())),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                      Booster.paddedWidget(
                                        left: 20,
                                        right: 20,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Booster.verticalSpace(10),
                                            Booster.dynamicFontSize(
                                                label: ct
                                                        .watch<PostModel>()
                                                        .data![i]
                                                        .title ??
                                                    "",
                                                fontSize: 20,
                                                isAlignCenter: false,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                            Booster.verticalSpace(10),
                                            Booster.dynamicFontSize(
                                                isAlignCenter: false,
                                                label: ct
                                                        .watch<PostModel>()
                                                        .data![i]
                                                        .body ??
                                                    "",
                                                lineHeight: 1.7,
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.white),
                                            Booster.verticalSpace(18),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                  );
                },
              )
            ],
          ),
          body: Container(
            height: Booster.screenHeight(context),
            width: Booster.screenWidth(context),
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/splashBG.png'))),
            child: Column(
              children: [
                Booster.verticalSpace(60),
                CustomAppBar(
                  title: "homepage".tr(),
                ),
                Booster.verticalSpace(50),
                ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.network(
                    _model!.data!.user.profileImage,
                    height: 150,
                    width: 150,
                    fit: BoxFit.fill,
                  ),
                ),
                Booster.verticalSpace(20),
                Booster.dynamicFontSize(
                    label: name == "" ? widget.model.data!.user.name : name,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: FrontEndConfigs.buttonColor),
                Booster.verticalSpace(20),
              ],
            ),
          ),
        ));
  }

  Widget _getUI(BuildContext context) {
    return Container(
      height: Booster.screenHeight(context),
      width: Booster.screenWidth(context),
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/splashBG.png'))),
      child: Column(
        children: [
          Booster.verticalSpace(60),
          CustomAppBar(
            title: "الصفحة الرئيسية",
          ),
          Booster.verticalSpace(50),
          Booster.localProfileAvatar(
              radius: 140, assetImage: 'assets/images/dp.png'),
          Booster.verticalSpace(20),
          Booster.dynamicFontSize(
              label: "خضر حنضل",
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: FrontEndConfigs.buttonColor),
          Booster.verticalSpace(8),
          Booster.dynamicFontSize(
              label: "تعديل البيانات",
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white),
          Booster.verticalSpace(20),
        ],
      ),
    );
  }
}
