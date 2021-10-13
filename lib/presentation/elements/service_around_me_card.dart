import 'package:blue_filter/configuration/front_end_configs.dart';
import 'package:blue_filter/infrastructure/models/nearby_service_provider.dart';
import 'package:blue_filter/presentation/views/service_provider_profile.dart';
import 'package:booster/booster.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';

class ServiceAroundMeCard extends StatelessWidget {
  Datum _model;
  String locale;

  ServiceAroundMeCard(this._model, this.locale);

  @override
  Widget build(BuildContext context) {
    print("HI : ${_model.locale}");
    return Booster.paddedWidget(
        left: 20,
        right: 20,
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ServiceProviderProfile(
                          _model,
                        )));
          },
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      width: Booster.screenWidth(context) * 0.6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Booster.dynamicFontSize(
                              label: _model.name,
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w600),
                          Booster.verticalSpace(8),
                          if (_model.category.isNotEmpty)
                            if (_model.category.length == 1)
                              Booster.dynamicFontSize(
                                  label: locale == "en"
                                      ? _model.category[0]['name']
                                      : _model.category[0]['name_ar'],
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: FrontEndConfigs.darkTextColor),
                          if (_model.category.length > 1)
                            Booster.dynamicFontSize(
                                label: locale == "en"
                                    ? _model.category[0]['name'] +
                                        "/" +
                                        _model.category[1]['name']
                                    : _model.category[0]['name_ar'] +
                                        "/" +
                                        _model.category[1]['name_ar'],
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: FrontEndConfigs.darkTextColor),
                          Booster.verticalSpace(5),
                          Booster.dynamicFontSize(
                              label: _model.address,
                              isAlignCenter: false,
                              fontSize: 15,
                              color: FrontEndConfigs.darkTextColor,
                              fontWeight: FontWeight.w400),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          MapsLauncher.launchCoordinates(
                              double.parse(_model.latitude),
                              double.parse(_model.longitude));
                        },
                        child: Icon(
                          Icons.location_on,
                          size: 34,
                          color: FrontEndConfigs.bgColor,
                        ),
                      ),
                      Booster.horizontalSpace(10),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ServiceProviderProfile(_model)));
                        },
                        child: Icon(
                          CupertinoIcons.info_circle_fill,
                          size: 30,
                          color: FrontEndConfigs.bgColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Booster.verticalSpace(10),
              Divider(
                color: FrontEndConfigs.dividerColor,
                thickness: 2,
              ),
              Booster.verticalSpace(20),
            ],
          ),
        ));
  }
}
