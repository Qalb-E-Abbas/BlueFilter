import 'dart:io';

import 'package:blue_filter/application/app_state.dart';
import 'package:blue_filter/application/name_state.dart';
import 'package:blue_filter/application/password_state.dart';
import 'package:blue_filter/configuration/back_end_configs.dart';
import 'package:blue_filter/configuration/front_end_configs.dart';
import 'package:blue_filter/infrastructure/models/auth/successful_login_model.dart';
import 'package:blue_filter/infrastructure/models/profile/profile_body.dart';
import 'package:blue_filter/infrastructure/services/auth_services.dart';
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
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

class NormalUserEditView extends StatefulWidget {
  @override
  _NormalUserEditViewState createState() => _NormalUserEditViewState();
}

class _NormalUserEditViewState extends State<NormalUserEditView> {
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
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void initState() {
    onLocationFetch();

    super.initState();
    PasswordState.getPasswordSharedPreference()
        .then((value) => _pwdController = TextEditingController(text: value));
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  AuthServices _authServices = AuthServices();
  late SuccessfulLoginModel userModel;

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
                        name: items['data']['user']['name'],
                        type: "",
                        locale: items['data']['user']['locale'],
                        profileCompleted: items['data']['user']
                            ['profile_completed'],
                        category: items['data']['user']['category'],
                        profileImage: items['data']['user']['profile_image'],
                        profileThumbnail: items['data']['user']
                            ['profileThumbnail'],
                        phone: items['data']['user']['phone'],
                        longitude: items['data']['user']['longitude'],
                        latitude: items['data']['user']['latitude'],
                        bio: items['data']['user']['bio'],
                        service_provider_clicks: items['data']['user']
                            ['service_provider_clicks'],
                        notification: items['data']['user']['notification'],
                        facebook: items['data']['user']['facebook'],
                        instagram: items['data']['user']['instagram'],
                        twitter: items['data']['user']['twitter'],
                        spotify: items['data']['user']['spotify'],
                        address: items['data']['user']['address'],
                        distance: "",
                      )));
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
            context.locale = Locale(userModel.data!.user.locale);
            initialized = true;
          }
          return snapshot.data == null
              ? CircularProgressIndicator()
              : _getCreateUI(context, userModel);
        });
  }

  Widget _getCreateUI(BuildContext context, SuccessfulLoginModel _userModel) {
    var state = Provider.of<AppState>(context);
    return LoadingOverlay(
      isLoading: isLoading,
      progressIndicator: CircularProgressIndicator(),
      child: Scaffold(
        body: SafeArea(child: _getUI(context)),
        drawer: AppDrawer(),
        bottomNavigationBar: ContainerButton(() {
          if (!_formKey.currentState!.validate()) {
            return;
          }
          if (_userModel.data!.user.profileImage == null) if (_image == null) {
            showErrorDialog(context, message: "Kindly attach image");
            return;
          }

          _updateProfile(state);
        }),
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

  _updateProfile(AppState _state) async {
    isLoading = true;
    setState(() {});
    print("Hi");
    _profileServices
        .updateContactDetailsData(context,
            model: ProfileBody(
                name: _nameController.text,
                locale: isEngSelected ? "en" : "ar",
                password: _pwdController.text,
                phone: _numberController.text,
                longitude: lng,
                latitude: lat,
                profile_image: _image,
                category_ids: "1",
                bio: "hi",
                notification: "0",
                facebook: "",
                instagram: "",
                twitter: "",
                spotify: "",
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
              type: "client")
          .then((_value) async {
        UserNameState.saveImage(_value!.data!.user.profileImage);
        await storage.setItem(BackendConfigs.loginUserData, _value);
      });

      showNavigationDialog(context,
          message: "Message_Success_Profile_Updated".tr(),
          buttonText: "Message_Error_Button".tr(), navigation: () {
        UserNameState.saveUserLoggedInSharedPreference(_nameController.text);
        isLoading = false;
        setState(() {});
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
  File? _image;

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
    Position a = await Geolocator.getCurrentPosition();
    lat = a.latitude;
    lng = a.longitude;
    final coordinates = new Coordinates(a.latitude, a.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    _areaController = TextEditingController(text: first.locality);
    _cityController = TextEditingController(text: first.subAdminArea);
    _countryController = TextEditingController(text: first.countryName);
    streetName = first.addressLine!;
    cityName = first.subAdminArea!;
    countryName = first.countryName!;
    setState(() {});
    setState(() {});
  }

  Widget _getUI(
    BuildContext context,
  ) {
    return Form(
      key: _formKey,
      child: Container(
        height: Booster.screenHeight(context),
        width: Booster.screenWidth(context),
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/splashBG.png'))),
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
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/dp.png',
                      height: 150,
                      width: 150,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              )
            else
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(_image!), fit: BoxFit.cover)),
                ),
              ),
            Booster.verticalSpace(10),
            Booster.dynamicFontSize(
                label: userModel.data!.user.name ?? "",
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: FrontEndConfigs.buttonColor),
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
                              },
                              label: "gps".tr(),
                              heading: userModel.data!.user.profileCompleted ==
                                          '0' ||
                                      isLocationUpdated
                                  ? '${getLat(lat.toString())}  / ${getLng(lng.toString())}'
                                  : "${getLat(userModel.data!.user.latitude.toString())}  / ${getLng(userModel.data!.user.longitude.toString())}",
                              icon: Icons.location_on),

                          IconButton(
                            icon: Booster.paddedWidget(
                                bottom: 11,
                                child: Icon(Icons.edit_location_rounded)),
                            onPressed: () {
                              isLocationUpdated = true;
                              setState(() {});
                              _determinePosition();
                            },
                          ),
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
                        top: 12,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              width: 20,
                              height: 20,
                              child: Icon(
                                Icons.email,
                                color: FrontEndConfigs.bgColor,
                              ),
                            ),
                            Booster.horizontalSpace(15),
                            Booster.dynamicFontSize(
                                label: userModel.data!.user.email,
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ],
                        ),
                      ),



                      ///
                      Booster.verticalSpace(15),

                      LabelIconRow(
                        text: "",
                        icon: Icons.call,
                        controller: _numberController,
                        validator: (val) =>
                            val!.isEmpty ? "Empty_Field".tr() : null,
                      ),

                      ///
                      Booster.verticalSpace(7),


                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 5),
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
                                  fontWeight: FontWeight.w500, fontSize: 20),
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
                      // LabelIconRow(
                      //     text: "************",
                      //     icon: Icons.lock,
                      //     controller: _pwdController,
                      //     validator: (val) {
                      //       if (val!.isEmpty) {
                      //         return "Field cannot be empty";
                      //       } else if (val.length < 8) {
                      //         return "Password length should be more than 6 characters.";
                      //       } else {
                      //         return null;
                      //       }
                      //     }),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.language,
                              color: FrontEndConfigs.bgColor,
                            ),
                            Booster.horizontalSpace(10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                      ),
                      Booster.verticalSpace(20),
                    ],
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
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
}
