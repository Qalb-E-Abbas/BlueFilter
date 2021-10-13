import 'dart:async';

import 'package:blue_filter/configuration/back_end_configs.dart';
import 'package:blue_filter/infrastructure/models/auth/successful_login_model.dart';
import 'package:blue_filter/infrastructure/models/nearby_service_provider.dart';
import 'package:blue_filter/infrastructure/services/nearby_services.dart';
import 'package:blue_filter/presentation/elements/appDrawer.dart';
import 'package:blue_filter/presentation/elements/custom_appBar.dart';
import 'package:blue_filter/presentation/elements/service_around_me_card.dart';
import 'package:blue_filter/presentation/views/service_provider_profile.dart';
import 'package:booster/booster.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

class ServicesAroundMe extends StatefulWidget {
  @override
  _ServicesAroundMeState createState() => _ServicesAroundMeState();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
}

class _ServicesAroundMeState extends State<ServicesAroundMe> {
  final LocalStorage storage = new LocalStorage(BackendConfigs.localDB);

  bool initialized = false;

  NearByServiceProviderServices _byServiceProviderServices =
      NearByServiceProviderServices();
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
                          profileCompleted: "",
                          category: items['data']['user']['category'],
                          profileImage: "",
                          profileThumbnail: "",
                          service_provider_clicks: items['data']['user']
                              ['service_provider_clicks'],
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

  Widget _getCreateUI(BuildContext context, SuccessfulLoginModel _userModel) {
    print("Locale : ${_userModel.data!.user.locale}");
    return Scaffold(
      body: _getUI(context, _userModel),
      drawer: AppDrawer(),
    );
  }

  Completer<GoogleMapController> _controller = Completer();

  List<Marker> marker = [];

  Widget _getUI(BuildContext context, SuccessfulLoginModel _userModel) {
    print(marker.length);
    return Container(
      height: Booster.screenHeight(context),
      width: Booster.screenWidth(context),
      decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/splashBG.png'))),
      child: Column(
        children: [
          Booster.verticalSpace(70),
          CustomAppBar(
            title: "servicenearme",
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
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20))),
                    height: 290,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20)),
                      child: GoogleMap(
                        mapType: MapType.normal,
                        markers: Set.of(marker),
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                              double.parse(
                                  _userModel.data!.user.latitude ?? "1"),
                              double.parse(
                                  _userModel.data!.user.longitude ?? '1')),
                          zoom: 14.4746,
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                      ),
                    ),
                  ),
                  FutureProvider.value(
                    value: _byServiceProviderServices.getNearbyServiceProvider(
                        context,
                        authToken: _userModel.data!.token,
                        pageNo: 1),
                    initialData: NearbyServiceModel(),
                    builder: (serviceProviderCtxt, child) {
                      if (marker.isEmpty)
                        Future.delayed(Duration(milliseconds: 300), () {
                          serviceProviderCtxt
                              .read<NearbyServiceModel>()
                              .data!
                              .map((e) => marker.add(Marker(
                                  markerId: MarkerId(e.id.toString()),
                                  position: LatLng(double.parse(e.latitude),
                                      double.parse(e.longitude.toString())),
                                  infoWindow: InfoWindow(
                                      title: e.name,
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ServiceProviderProfile(e)));
                                      }),
                                  icon: BitmapDescriptor.defaultMarkerWithHue(
                                    BitmapDescriptor.hueViolet,
                                  ))))
                              .toList();
                          setState(() {});
                        });
                      return serviceProviderCtxt
                                  .watch<NearbyServiceModel>()
                                  .data ==
                              null
                          ? CircularProgressIndicator()
                          : ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: serviceProviderCtxt
                                  .watch<NearbyServiceModel>()
                                  .data!
                                  .length,
                              shrinkWrap: true,
                              itemBuilder: (context, i) {
                                print(serviceProviderCtxt
                                    .watch<NearbyServiceModel>()
                                    .data![i]);
                                return ServiceAroundMeCard(
                                    serviceProviderCtxt
                                        .watch<NearbyServiceModel>()
                                        .data![i],
                                    _userModel.data!.user.locale);
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
