import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:blue_filter/application/app_state.dart';
import 'package:blue_filter/application/name_state.dart';
import 'package:blue_filter/application/password_state.dart';
import 'package:blue_filter/configuration/back_end_configs.dart';
import 'package:blue_filter/configuration/front_end_configs.dart';
import 'package:blue_filter/infrastructure/models/auth/successful_login_model.dart';
import 'package:blue_filter/infrastructure/models/category_model.dart';
import 'package:blue_filter/infrastructure/models/profile/profile_body.dart';
import 'package:blue_filter/infrastructure/services/auth_services.dart';
import 'package:blue_filter/infrastructure/services/categories_services.dart';
import 'package:blue_filter/infrastructure/services/profile_services.dart';
import 'package:blue_filter/presentation/elements/appDrawer.dart';
import 'package:blue_filter/presentation/elements/container_button.dart';
import 'package:blue_filter/presentation/elements/custom_appBar.dart';
import 'package:blue_filter/presentation/elements/dialog.dart';
import 'package:blue_filter/presentation/elements/labelIconRow.dart';
import 'package:blue_filter/presentation/elements/label_heading_icon_row.dart';
import 'package:blue_filter/presentation/elements/label_location_row.dart';
import 'package:blue_filter/presentation/elements/navigation_dialog.dart';
import 'package:blue_filter/presentation/helper/get_address.dart';
import 'package:blue_filter/presentation/views/bottom_nav_bar_view.dart';
import 'package:booster/booster.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:localstorage/localstorage.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

class ServiceProviderEditView extends StatefulWidget {
  @override
  _ServiceProviderEditViewState createState() =>
      _ServiceProviderEditViewState();
}

class _ServiceProviderEditViewState extends State<ServiceProviderEditView> {
  ProfileServices _profileServices = ProfileServices();
  final LocalStorage storage = new LocalStorage(BackendConfigs.localDB);
  bool initialized = false;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  TextEditingController _numberController = TextEditingController();
  TextEditingController _fbController = TextEditingController();
  TextEditingController _instaController = TextEditingController();
  TextEditingController _spotifyController = TextEditingController();
  TextEditingController _twitterController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _areaController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  double lat = 0.0;
  double lng = 0.0;
  AuthServices _authServices = AuthServices();
  CategoriesServices _categoriesServices = CategoriesServices();
  late SuccessfulLoginModel userModel;
  List<Datum>? _categoryList = [];
  List<Datum>? _selectedCategory = [];
  final _formKey = GlobalKey<FormState>();
  var userData;
  File? _image;
  bool isLoading = false;

  fetchCategories(SuccessfulLoginModel _userModel) {
    _categoriesServices
        .getCategories(context, authToken: _userModel.data!.token)
        .then((value) {
      value!.data!.map((e) => _categoryList!.add(e)).toList();
      setState(() {});
    });
  }

  initState() {
    // onLocationFetch();
    super.initState();

    onLocationFetch();
    PasswordState.getPasswordSharedPreference()
        .then((value) => _pwdController = TextEditingController(text: value));
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: storage.ready,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!initialized) {
            var items = storage.getItem(BackendConfigs.loginUserData);

            if (items != null) {
              printWrapped(items.toString());
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
            _nameController =
                TextEditingController(text: userModel.data!.user.name);
            isSwitched =
                userModel.data!.user.notification == "0" ? false : true;
            _bioController =
                TextEditingController(text: userModel.data!.user.bio);
            _emailController =
                TextEditingController(text: userModel.data!.user.email);
            _numberController =
                TextEditingController(text: userModel.data!.user.phone);
            _fbController =
                TextEditingController(text: userModel.data!.user.facebook);
            _instaController =
                TextEditingController(text: userModel.data!.user.instagram);
            _spotifyController =
                TextEditingController(text: userModel.data!.user.spotify);
            _twitterController =
                TextEditingController(text: userModel.data!.user.twitter);
            if (userModel.data!.user.address.toString().isNotEmpty)
              _areaController = TextEditingController(
                  text: userModel.data!.user.address.toString().split('/')[0]);
            if (userModel.data!.user.address.toString().isNotEmpty)
              _cityController = TextEditingController(
                  text: userModel.data!.user.address.toString().split('/')[1]);
            if (userModel.data!.user.address.toString().isNotEmpty)
              _countryController = TextEditingController(
                  text: userModel.data!.user.address.toString().split('/')[2]);
            isEngSelected = userModel.data!.user.locale == "en" ? true : false;
            isArSelected = userModel.data!.user.locale == "ar" ? true : false;
            userModel.data!.user.category.map((e) {
              e.map((x) {
                _selectedCategory!.add(Datum(
                    id: int.parse(x['id'].toString()),
                    name: x['name'],
                    nameAr: x['nameAr'],
                    color: x['color']));
              }).toList();
            }).toList();
            fetchCategories(userModel);
            context.locale = Locale(userModel.data!.user.locale);
            initialized = true;
          }
          return snapshot.data == null
              ? CircularProgressIndicator()
              : _getCreateUI(context, userModel);
        });
  }

  // void _showMultiSelect(BuildContext context) async {
  //   await showDialog(
  //     context: context,
  //     builder: (ctx) {
  //       return  MultiSelectDialog(
  //         items: _categoryList,
  //         initialValue: _selectedAnimals,
  //         onConfirm: (values) {...},
  //       );
  //     },
  //   );
  // }
  Widget _getCreateUI(BuildContext context, SuccessfulLoginModel _userModel) {
    print(userModel.data!.user.address.toString());
    _selectedCategory!.map((e) => print(e.name)).toList();
    var state = Provider.of<AppState>(context);
    return Scaffold(
      body: SafeArea(child: _getUI(context, _userModel)),
      drawer: AppDrawer(),
      bottomNavigationBar: ContainerButton(() {
        if (!_formKey.currentState!.validate()) {
          return;
        }
        if (_userModel.data!.user.profileImage == null) if (_image == null) {
          showErrorDialog(context, message: "Message_Error_Profile_Photo".tr());
          return;
        }

        if (_selectedCategory!.isEmpty) {
          Flushbar(
            message: "Kindly select at least one category",
            icon: Icon(
              Icons.info_outline,
              color: Colors.blue[600],
            ),
            duration: Duration(seconds: 3),
          )..show(context);
          return;
        }
        _updateProfile(state);
      }),
    );
  }

  _updateProfile(AppState _state) async {
    isLoading = true;
    setState(() {});
    print("Hi");
    print(_selectedCategory![0].name);
    _profileServices
        .updateContactDetailsData(context,
            model: ProfileBody(
                name: _nameController.text,
                locale: isEngSelected ? "en" : "ar",
                password: _pwdController.text,
                phone: _numberController.text,
                longitude: getLng(lng.toString()),
                latitude: getLat(lat.toString()),
                profile_image: _image,
                category_ids: _selectedCategory!
                    .map((e) => e.id)
                    .toList()
                    .toString()
                    .replaceAll('[', "")
                    .replaceAll("]", ""),
                bio: _bioController.text,
                notification: isSwitched ? "1" : "0",
                facebook: _fbController.text.isEmpty ? "" : _fbController.text,
                instagram:
                    _instaController.text.isEmpty ? "" : _instaController.text,
                twitter: _twitterController.text.isEmpty
                    ? ""
                    : _twitterController.text,
                spotify: _spotifyController.text.isEmpty
                    ? ""
                    : _spotifyController.text,
                profileCompleted: "1",
                address: "${_areaController.text}"
                        "/" +
                    "${_cityController.text} " +
                    "/" +
                    "${_countryController.text}"),
            authToken: userModel.data!.token)
        .then((value) async {
      await _authServices
          .loginUser(context,
              email: userModel.data!.user.email,
              password: _pwdController.text,
              type: "service_provider")
          .then((value) async {
        UserNameState.saveImage(value!.data!.user.profileImage);
        await storage.setItem(BackendConfigs.loginUserData, value);
      });
      isLoading = false;
      setState(() {});
      showNavigationDialog(context,
          message: "Message_Success_Profile_Updated".tr(),
          buttonText: "Message_Success_Button".tr(), navigation: () {
        UserNameState.saveUserLoggedInSharedPreference(_nameController.text);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    BottomNavbarView(index: 0, fromOutside: false)),
            (_) => false);
      }, secondButtonText: "secondButtonText", showSecondButton: false);
    });
  }

  bool showPwd = false;

  bool isEngSelected = true;

  bool isArSelected = false;

  bool isSwitched = true;
  bool isLocationUpdated = false;
  String countryName = "";
  String cityName = "";
  String streetName = "";

  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position a = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    lat = a.latitude;
    lng = a.longitude;
    final coordinates = new Coordinates(a.latitude, a.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);

    debugPrint('coordinates is: $coordinates');

    var first = addresses.first;
// print number of retured addresses
    debugPrint('${addresses.length}');
// print the best address
    debugPrint("${first.featureName} : ${first.addressLine}");
//print other address names
    debugPrint(
        "Country:${first.countryName} AdminArea:${first.adminArea} SubAdminArea:${first.subAdminArea}");
// print more address names
    debugPrint("Locality:${first.locality}: Sublocality:${first.subLocality}");
    _areaController = TextEditingController(text: first.locality);
    _cityController = TextEditingController(text: first.subAdminArea);
    _countryController = TextEditingController(text: first.countryName);
    streetName = first.addressLine!;
    cityName = first.subAdminArea!;
    countryName = first.countryName!;
    setState(() {});
    setState(() {});
  }

  Widget _getUI(BuildContext context, SuccessfulLoginModel _userModel) {
    var state = Provider.of<AppState>(context);
    print(_categoryList!.length);
    print(_categoryList!.map((e) {
      return {'display': e.name, 'value': e.id};
    }).toList());
    return _categoryList!.isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : LoadingOverlay(
            isLoading: isLoading,
            progressIndicator: CircularProgressIndicator(),
            child: Container(
              height: Booster.screenHeight(context),
              width: Booster.screenWidth(context),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/splashBG.png'))),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Booster.verticalSpace(30),
                    CustomAppBar(
                      title: "edit_information",
                    ),
                    Booster.verticalSpace(30),
                    if (_image == null)
                      InkWell(
                        onTap: () {
                          getImage(true);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: userModel.data!.user.profileImage ?? "",
                            height: 150,
                            width: 150,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/images/dp.png',
                              height: 150,
                              width: 150,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    if (_image != null)
                      InkWell(
                        onTap: () {
                          getImage(true);
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.file(
                            _image!,
                            height: 150,
                            width: 150,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    Booster.verticalSpace(10),
                    Booster.dynamicFontSize(
                        label: _userModel.data!.user.name ?? "",
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: FrontEndConfigs.buttonColor),
                    Booster.verticalSpace(5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Booster.dynamicFontSize(
                            label: "profile_view".tr(),
                            fontSize: 18,
                            color: FrontEndConfigs.buttonColor),
                        Booster.horizontalSpace(10),
                        Booster.dynamicFontSize(
                            label: _userModel.data!.user.service_provider_clicks
                                .toString(),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: FrontEndConfigs.buttonColor),
                      ],
                    ),
                    Booster.verticalSpace(15),
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20))),
                      child: Booster.paddedWidget(
                        left: 20,
                        right: 20,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Booster.verticalSpace(20),
                              LabelIconRow(
                                text: "خضر حنضل",
                                icon: Icons.person,
                                controller: _nameController,
                                validator: (val) =>
                                    val!.isEmpty ? "Empty_Field".tr() : null,
                              ),
                              Row(
                                children: [
                                  LabelHeadingIconRow(
                                      onTap: () {
                                        print("Called");
                                        _determinePosition();
                                        isLocationUpdated = true;
                                        setState(() {});
                                      },
                                      label: "gps".tr(),
                                      heading: _userModel.data!.user
                                                      .profileCompleted ==
                                                  '0' ||
                                              isLocationUpdated
                                          ? '${getLat(lat.toString())}  / ${getLng(lng.toString())}'
                                          : "${getLat(_userModel.data!.user.latitude.toString())}  / ${getLng(_userModel.data!.user.longitude.toString())}",
                                      icon: Icons.location_on),
                                  IconButton(
                                    icon: Icon(Icons.edit_location_rounded),
                                    onPressed: () {
                                      isLocationUpdated = true;
                                      setState(() {});
                                      _determinePosition();
                                    },
                                  )
                                ],
                              ),
                              LabelLocationRow(
                                  text: "area".tr(),
                                  icon: Icons.location_on,
                                  controller: _areaController,
                                  validator: (val) {}),
                              LabelLocationRow(
                                  text: "city".tr(),
                                  icon: Icons.location_on,
                                  controller: _cityController,
                                  validator: (val) {}),
                              LabelLocationRow(
                                  text: "country".tr(),
                                  icon: Icons.location_on,
                                  controller: _countryController,
                                  validator: (val) {}),
                              Booster.paddedWidget(
                                top: 10,
                                bottom: 10,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      child: Icon(
                                        Icons.email,
                                        color: FrontEndConfigs.bgColor,
                                      ),
                                    ),
                                    Booster.horizontalSpace(15),
                                    Booster.dynamicFontSize(
                                        label: _userModel.data!.user.email,
                                        fontSize: 20,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500),
                                  ],
                                ),
                              ),
                              Booster.paddedWidget(
                                top: 10,
                                bottom: 10,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 20,
                                      child: Icon(
                                        Icons.call,
                                        color: FrontEndConfigs.bgColor,
                                      ),
                                    ),
                                    Booster.horizontalSpace(15),
                                    Expanded(
                                        child: TextFormField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                            RegExp("[0-9]")),
                                      ],
                                      controller: _numberController,
                                      validator: (val) => val!.isEmpty
                                          ? "Empty_Field".tr()
                                          : null,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20),
                                      decoration: InputDecoration(
                                          border: UnderlineInputBorder(
                                              borderSide: BorderSide.none)),
                                    )),
                                    // Booster.dynamicFontSize(
                                    //     label: text, fontSize: 20, fontWeight: FontWeight.w500),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 20,
                                    height: 20,
                                    child: Icon(
                                      Icons.lock,
                                      color: FrontEndConfigs.bgColor,
                                    ),
                                  ),
                                  Booster.horizontalSpace(15),
                                  Expanded(
                                    child: TextFormField(
                                      obscureText: !showPwd,
                                      controller: _pwdController,
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return "Empty_Field".tr();
                                        } else if (val.length < 8) {
                                          return "Password length should be more than 6 characters.";
                                        } else {
                                          return null;
                                        }
                                      },
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 20),
                                      decoration: InputDecoration(
                                          border: UnderlineInputBorder(
                                              borderSide: BorderSide.none)),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showPwd = !showPwd;
                                      setState(() {});
                                    },
                                    child: Icon(
                                      showPwd
                                          ? Icons.remove_red_eye
                                          : CupertinoIcons.eye_slash_fill,
                                      color: Colors.black,
                                    ),
                                  )
                                  // Booster.dynamicFontSize(
                                  //     label: text, fontSize: 20, fontWeight: FontWeight.w500),
                                ],
                              ),
                              LabelIconRow(
                                  text: "",
                                  icon: FontAwesomeIcons.facebook,
                                  controller: _fbController,
                                  validator: (val) {}),
                              LabelIconRow(
                                  text: "",
                                  icon: FontAwesomeIcons.twitter,
                                  controller: _twitterController,
                                  validator: (val) {}),
                              LabelIconRow(
                                  text: "",
                                  icon: FontAwesomeIcons.spotify,
                                  controller: _spotifyController,
                                  validator: (val) {}),
                              LabelIconRow(
                                  text: "",
                                  icon: FontAwesomeIcons.instagram,
                                  controller: _instaController,
                                  validator: (val) {}),
                              // MultiSelectFormField(
                              //   title: Text(
                              //     "Title Of Form",
                              //     style: TextStyle(fontSize: 16),
                              //   ),
                              //   dataSource: [
                              //     {
                              //       "display": "Running",
                              //       "value": "Running",
                              //     },
                              //     {
                              //       "display": "Climbing",
                              //       "value": "Climbing",
                              //     },
                              //   ],
                              //   textField: "display",
                              //   valueField: 'value',
                              //   okButtonLabel: 'OK',
                              //   cancelButtonLabel: 'CANCEL',
                              //   hintWidget: Text('Please choose one or more'),
                              //   initialValue: [
                              //     {
                              //       "display": "Running",
                              //       "value": "Running",
                              //     },
                              //   ],
                              //   onSaved: (value) {
                              //     if (value == null) return;
                              //     setState(() {
                              //       // _selectedCategory = value;
                              //     });
                              //   },
                              // ),

                              MultiSelectDialogField<Datum?>(
                                items: _categoryList!
                                    .map((e) => MultiSelectItem<Datum?>(
                                        e,
                                        context.locale == Locale('en')
                                            ? e.name!
                                            : e.nameAr ?? "--"))
                                    .toList(),
                                listType: MultiSelectListType.LIST,
                                initialValue: _selectedCategory,
                                onConfirm: (values) {
                                  //
                                  _selectedCategory = values.cast<Datum>();
                                  setState(() {});
                                  print(_selectedCategory![0].name);
                                },
                                chipDisplay: MultiSelectChipDisplay(
                                  onTap: (item) {
                                    _selectedCategory!.remove(item);
                                    setState(() {});
                                    return _selectedCategory;
                                  },
                                ),
                              ),
                              // Row(
                              //   crossAxisAlignment: CrossAxisAlignment.center,
                              //   children: [
                              //     LabelIconRow(
                              //         text: "إختر التصنيفات الخاصة بك",
                              //         icon: Icons.folder_rounded),
                              //     Booster.horizontalSpace(10),
                              //     Booster.paddedWidget(
                              //         top: 10,
                              //         bottom: 20,
                              //         child: Icon(Icons.arrow_drop_down))
                              //   ],
                              // ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.notifications,
                                    color: FrontEndConfigs.bgColor,
                                  ),
                                  Booster.horizontalSpace(6),
                                  Booster.dynamicFontSize(
                                      label: "notification".tr(),
                                      fontSize: 18,
                                      color: FrontEndConfigs.darkTextColor,
                                      fontWeight: FontWeight.w500),
                                  Booster.horizontalSpace(10),
                                  Booster.paddedWidget(
                                      top: 10,
                                      bottom: 20,
                                      child: Transform.scale(
                                        scale: 0.7,
                                        child: CupertinoSwitch(
                                            trackColor: Colors.grey,
                                            activeColor:
                                                FrontEndConfigs.bgColor,
                                            value: isSwitched,
                                            onChanged: (val) {
                                              isSwitched = val;
                                              setState(() {});
                                            }),
                                      ))
                                ],
                              ),
                              Booster.verticalSpace(10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.language,
                                    color: FrontEndConfigs.bgColor,
                                  ),
                                  Booster.horizontalSpace(10),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            context.locale = Locale('en');

                                            print("Called");
                                            isEngSelected = true;
                                            isArSelected = false;
                                            setState(() {});
                                          },
                                          child: Icon(
                                            isEngSelected
                                                ? Icons.radio_button_checked
                                                : Icons.radio_button_off,
                                            color: FrontEndConfigs.bgColor,
                                          )),
                                      Booster.horizontalSpace(6),
                                      Booster.dynamicFontSize(
                                          label: "english".tr(),
                                          fontSize: 18,
                                          color: FrontEndConfigs.darkTextColor,
                                          fontWeight: FontWeight.w500),
                                    ],
                                  ),
                                  Booster.horizontalSpace(40),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      InkWell(
                                          onTap: () {
                                            context.locale = Locale('ar');
                                            isEngSelected = false;
                                            isArSelected = true;
                                            setState(() {});
                                          },
                                          child: Icon(
                                            isArSelected
                                                ? Icons.radio_button_checked
                                                : Icons.radio_button_off,
                                            color: FrontEndConfigs.bgColor,
                                          )),
                                      Booster.horizontalSpace(6),
                                      Booster.dynamicFontSize(
                                          label: "arabic".tr(),
                                          fontSize: 18,
                                          color: FrontEndConfigs.darkTextColor,
                                          fontWeight: FontWeight.w500),
                                    ],
                                  ),
                                ],
                              ),
                              Booster.verticalSpace(15),
                              LabelIconRow(
                                text: "short_bio".tr(),
                                icon: Icons.info,
                                controller: _bioController,
                                validator: (val) =>
                                    val!.isEmpty ? "Empty_Field".tr() : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ))
                  ],
                ),
              ),
            ),
          );
  }

  onLocationFetch() async {
    getLatLng().then((value) {
      lat = value.latitude!;
      lng = value.longitude!;
      setState(() {});
    });
    getReadableAddress().then((value) {
      streetName = value.featureName!;
      cityName = value.locality!;
      countryName = value.countryName!;
      print(value);
      setState(() {});
    }).then((value) {
      getLatLng().then((value) {
        lat = value.latitude!;
        lng = value.longitude!;
        setState(() {});
      });
    });
  }

  getLat(String lat) {
    if (lat.length <= 5) {
      return lat;
    } else {
      return lat.substring(0, 5);
    }
  }

  getLng(String lng) {
    if (lng.length <= 5) {
      return lng;
    } else {
      return lng.substring(0, 5);
    }
  }

  List<String> assetImages = [];

  ///To Add Image
  List<String> _images = [];

  _getRemoveButtons() {
    return ListView.builder(
        itemCount: assetImages.length,
        itemBuilder: (context, i) {
          return RaisedButton(
            onPressed: () {
              _images.remove(assetImages[i]);
              setState(() {});
            },
            child: Text("Delete Images"),
          );
        });
  }

  Future getImage(bool gallery) async {
    ImagePicker picker = ImagePicker();
    PickedFile? pickedFile;
    // Let user select photo from gallery
    if (gallery) {
      pickedFile = await picker.getImage(
        source: ImageSource.gallery,
      );
    }
    // Otherwise open camera to get new photo
    else {
      pickedFile = await picker.getImage(
        source: ImageSource.camera,
      );
    }

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  static List<Animal> _animals = [
    Animal(id: 1, name: "Lion"),
    Animal(id: 2, name: "Flamingo"),
    Animal(id: 3, name: "Hippo"),
    Animal(id: 4, name: "Horse"),
    Animal(id: 5, name: "Tiger"),
    Animal(id: 6, name: "Penguin"),
    Animal(id: 7, name: "Spider"),
    Animal(id: 8, name: "Snake"),
    Animal(id: 9, name: "Bear"),
    Animal(id: 10, name: "Beaver"),
    Animal(id: 11, name: "Cat"),
    Animal(id: 12, name: "Fish"),
    Animal(id: 13, name: "Rabbit"),
    Animal(id: 14, name: "Mouse"),
    Animal(id: 15, name: "Dog"),
    Animal(id: 16, name: "Zebra"),
    Animal(id: 17, name: "Cow"),
    Animal(id: 18, name: "Frog"),
    Animal(id: 19, name: "Blue Jay"),
    Animal(id: 20, name: "Moose"),
    Animal(id: 21, name: "Gecko"),
    Animal(id: 22, name: "Kangaroo"),
    Animal(id: 23, name: "Shark"),
    Animal(id: 24, name: "Crocodile"),
    Animal(id: 25, name: "Owl"),
    Animal(id: 26, name: "Dragonfly"),
    Animal(id: 27, name: "Dolphin"),
  ];
}

class Animal {
  final int id;
  final String name;

  Animal({
    required this.id,
    required this.name,
  });
}
