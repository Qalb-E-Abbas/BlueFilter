class BackendConfigs {
  static const String apiBaseUrl = "https://www.bluefilter.ps";

  static String apiUrlBuilder() {
    return apiBaseUrl + "/api" + "/v1/";
  }

  static const localDB = "blueFilterDB";
  static const loginUserData = "userData";
  static const userPassword = "pwd";
  static const contactDetails = "contactDetails";
}
