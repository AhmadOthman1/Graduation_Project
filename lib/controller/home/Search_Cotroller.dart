import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:growify/controller/home/logOutButton_controller.dart';
import 'package:growify/global.dart';
import 'package:growify/view/screen/homescreen/myPage/ColleaguesPageProfile.dart';
import 'package:growify/view/screen/homescreen/myPage/Pageprofile.dart';
import 'package:growify/view/screen/homescreen/profilepages/colleaguesprofile.dart';
import 'package:growify/view/screen/homescreen/profilepages/profilemainpage.dart';
import 'package:http/http.dart' as http;

LogOutButtonControllerImp _logoutController =
    Get.put(LogOutButtonControllerImp());


class PageInfo {
  final String id;
  final String name;
  final String? description;
  final String? country;
  final String? address;
  final String? contactInfo;
  final String? specialty;
  final String? pageType;
  final String? photo;
  final String? coverImage;
  final String? postCount;
  final String? followCount;
  final String? adminType;

  PageInfo(this.id, this.name, this.description, this.country, this.address, this.contactInfo, this.specialty, this.pageType, this.photo, this.coverImage, this.postCount , this.followCount,[this.adminType]);
}
// for filer  .. . . .. . . .. .  ..  . . .

// for fileds 
  


class SearchControllerImp extends GetxController {

  // for enable
  RxBool isSaveVisibleCountryUser = false.obs;
  RxBool isSaveVisibleGenderUser = false.obs;
  RxBool isSaveVisibleFieldsUser = false.obs;
  RxBool isSaveVisibleConnectionUser = false.obs;
  //
   RxBool isSaveVisibleCountryPage = false.obs;
   RxBool isSaveVisibleFollowersPage = false.obs;
   //
    RxBool isSaveVisibleCountryJob = false.obs;
     RxBool isSaveVisibleFieldsJob = false.obs;

   RxList<String> selectedItems = <String>[].obs;
    
 RxList<String> items = RxList<String>([

]);
// for gender
  final RxBool isTextFieldEnabledGender = false.obs;
  final RxString gender = ''.obs;
  final List<String> genderList = [
    "Male",
    "Female",
    ];
// for country
  final RxBool isTextFieldEnabled11 = false.obs;
  final RxString country = ''.obs;
  final List<String> countryList = [
    "Palestine",
    "United States",
    "Canada",
    "Afghanistan",
    "Albania",
    "Algeria",
    "American Samoa",
    "Andorra",
    "Angola",
    "Anguilla",
    "Antarctica",
    "Antigua and/or Barbuda",
    "Argentina",
    "Armenia",
    "Aruba",
    "Australia",
    "Austria",
    "Azerbaijan",
    "Bahamas",
    "Bahrain",
    "Bangladesh",
    "Barbados",
    "Belarus",
    "Belgium",
    "Belize",
    "Benin",
    "Bermuda",
    "Bhutan",
    "Bolivia",
    "Bosnia and Herzegovina",
    "Botswana",
    "Bouvet Island",
    "Brazil",
    "British Indian Ocean Territory",
    "Brunei Darussalam",
    "Bulgaria",
    "Burkina Faso",
    "Burundi",
    "Cambodia",
    "Cameroon",
    "Cape Verde",
    "Cayman Islands",
    "Central African Republic",
    "Chad",
    "Chile",
    "China",
    "Christmas Island",
    "Cocos (Keeling) Islands",
    "Colombia",
    "Comoros",
    "Congo",
    "Cook Islands",
    "Costa Rica",
    "Croatia (Hrvatska)",
    "Cuba",
    "Cyprus",
    "Czech Republic",
    "Denmark",
    "Djibouti",
    "Dominica",
    "Dominican Republic",
    "East Timor",
    "Ecudaor",
    "Egypt",
    "El Salvador",
    "Equatorial Guinea",
    "Eritrea",
    "Estonia",
    "Ethiopia",
    "Falkland Islands (Malvinas)",
    "Faroe Islands",
    "Fiji",
    "Finland",
    "France",
    "France, Metropolitan",
    "French Guiana",
    "French Polynesia",
    "French Southern Territories",
    "Gabon",
    "Gambia",
    "Georgia",
    "Germany",
    "Ghana",
    "Gibraltar",
    "Greece",
    "Greenland",
    "Grenada",
    "Guadeloupe",
    "Guam",
    "Guatemala",
    "Guinea",
    "Guinea-Bissau",
    "Guyana",
    "Haiti",
    "Heard and Mc Donald Islands",
    "Honduras",
    "Hong Kong",
    "Hungary",
    "Iceland",
    "India",
    "Indonesia",
    "Iran (Islamic Republic of)",
    "Iraq",
    "Ireland",
    "Israel",
    "Italy",
    "Ivory Coast",
    "Jamaica",
    "Japan",
    "Jordan",
    "Kazakhstan",
    "Kenya",
    "Kiribati",
    "Korea, Democratic People's Republic of",
    "Korea, Republic of",
    "Kosovo",
    "Kuwait",
    "Kyrgyzstan",
    "Lao People's Democratic Republic",
    "Latvia",
    "Lebanon",
    "Lesotho",
    "Liberia",
    "Libyan Arab Jamahiriya",
    "Liechtenstein",
    "Lithuania",
    "Luxembourg",
    "Macau",
    "Macedonia",
    "Madagascar",
    "Malawi",
    "Malaysia",
    "Maldives",
    "Mali",
    "Malta",
    "Marshall Islands",
    "Martinique",
    "Mauritania",
    "Mauritius",
    "Mayotte",
    "Mexico",
    "Micronesia, Federated States of",
    "Moldova, Republic of",
    "Monaco",
    "Mongolia",
    "Montserrat",
    "Morocco",
    "Mozambique",
    "Myanmar",
    "Namibia",
    "Nauru",
    "Nepal",
    "Netherlands",
    "Netherlands Antilles",
    "New Caledonia",
    "New Zealand",
    "Nicaragua",
    "Niger",
    "Nigeria",
    "Niue",
    "Norfork Island",
    "Northern Mariana Islands",
    "Norway",
    "Oman",
    "Pakistan",
    "Palau",
    "Panama",
    "Papua New Guinea",
    "Paraguay",
    "Peru",
    "Philippines",
    "Pitcairn",
    "Poland",
    "Portugal",
    "Puerto Rico",
    "Qatar",
    "Reunion",
    "Romania",
    "Russian Federation",
    "Rwanda",
    "Saint Kitts and Nevis",
    "Saint Lucia",
    "Saint Vincent and the Grenadines",
    "Samoa",
    "San Marino",
    "Sao Tome and Principe",
    "Saudi Arabia",
    "Senegal",
    "Seychelles",
    "Sierra Leone",
    "Singapore",
    "Slovakia",
    "Slovenia",
    "Solomon Islands",
    "Somalia",
    "South Africa",
    "South Georgia South Sandwich Islands",
    "South Sudan",
    "Spain",
    "Sri Lanka",
    "St. Helena",
    "St. Pierre and Miquelon",
    "Sudan",
    "Suriname",
    "Svalbarn and Jan Mayen Islands",
    "Swaziland",
    "Sweden",
    "Switzerland",
    "Syrian Arab Republic",
    "Taiwan",
    "Tajikistan",
    "Tanzania, United Republic of",
    "Thailand",
    "Togo",
    "Tokelau",
    "Tonga",
    "Trinidad and Tobago",
    "Tunisia",
    "Turkey",
    "Turkmenistan",
    "Turks and Caicos Islands",
    "Tuvalu",
    "Uganda",
    "Ukraine",
    "United Arab Emirates",
    "United Kingdom",
    "United States minor outlying islands",
    "Uruguay",
    "Uzbekistan",
    "Vanuatu",
    "Vatican City State",
    "Venezuela",
    "Vietnam",
    "Virigan Islands (British)",
    "Virgin Islands (U.S.)",
    "Wallis and Futuna Islands",
    "Western Sahara",
    "Yemen",
    "Yugoslavia",
    "Zaire",
    "Zambia",
    "Zimbabwe"
  ];
//
  // Define a dynamic list to store user data
  RxList<Map<String, String>> userList = <Map<String, String>>[].obs;
  String? searchValue;
  int Upage = 1;
  int Ppage = 1;
  int pageSize = 15;
  // Define a dynamic list to store page data
  RxList<Map<String, String>> pageList = <Map<String, String>>[].obs;
   // Define a dynamic list to store job data
  RxList<Map<String, String>> jobeList = <Map<String, String>>[].obs;
  // for user and page chek null
  final RxString profileImageBytes = ''.obs;
  final RxString profileImageBytesName = ''.obs;
  final RxString profileImageExt = ''.obs;

  RxBool checkTheSearch = false.obs;
  late int userPostCount;
  late int userConnectionsCount;
///////////////////////////////////////////////////
  // to get jobs when i search 





///////////////////////
  searchInDataBase(searchValue, page, pageSize, searchType) async {
     var url =
        "$urlStarter/user/getSearchData?email=${GetStorage().read("loginemail")}&type=$searchType&search=$searchValue&page=$page&pageSize=$pageSize";
   if (searchType == "U") {
  if (isSaveVisibleCountryUser.value) {
    url += "&country=$country";
  }
   if (isSaveVisibleFieldsUser.value) {
     url += "&fields=${(selectedItems.value).join(',')}";
  }

  if (isSaveVisibleGenderUser.value) {
     url += "&userGender=$gender";
  }

  if (isSaveVisibleConnectionUser.value) {
     url += "&highestConnection=true";
  }
  print("kkkkkkkkkkk");
  print(url);
}

    else if (searchType == "P") {
      if (isSaveVisibleCountryPage.value) {
    url += "&country=$country";
  }
  if (isSaveVisibleConnectionUser.value) {
     url += "&highestFollowers=true";
  }


    }
    else if (searchType == "J") {
         if (isSaveVisibleCountryJob.value) {
    url += "&country=$country";
  }

   if (isSaveVisibleFieldsJob.value) {
     url += "&fields=${(selectedItems.value).join(',')}";
  }
  

    }
   
    var responce = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    return responce;
  }

  goTosearchPage(searchValue, page, searchType) async {
    var res = await searchInDataBase(searchValue, page, pageSize, searchType);
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      goTosearchPage(searchValue, page, searchType);
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 409) {
      return resbody['message'];
    } else if (res.statusCode == 200) {
      if (searchType == "U") {
        final List<dynamic>? users = resbody["users"];
        userList.addAll(
          (users)
                  ?.map<Map<String, String>>(
                    (user) => (user as Map<String, dynamic>)
                        .map<String, String>(
                            (key, value) => MapEntry(key, value.toString())),
                  )
                  .toList() ??
              [],
        );
        return resbody["users"];
      } else if (searchType == "P") {
        print(";;;;;;;;;;;;;;;;;");
        final List<dynamic>? pages = resbody["pages"];
        pageList.addAll(
          (pages)
                  ?.map<Map<String, String>>(
                    (page) => (page as Map<String, dynamic>)
                        .map<String, String>(
                            (key, value) => MapEntry(key, value.toString())),
                  )
                  .toList() ??
              [],
        );
        print(resbody["pages"]);
        return resbody["users"];
      }
      // to get jobs when i serahc  
      else if (searchType == "J") {
        print("jooobbbb");
        print(resbody);
        print("okkk joobsss");
        final List<dynamic>? jobs = resbody["jobs"];
        jobeList.addAll(
          (jobs)
                  ?.map<Map<String, String>>(
                    (job) => (job as Map<String, dynamic>)
                        .map<String, String>(
                            (key, value) => MapEntry(key, value.toString())),
                  )
                  .toList() ??
              [],
        );
        print(resbody["jobs"]);
        return resbody["users"];
      }
    }
  }

  // when i press on the result users
  getDashboard() async {
    var url = "$urlStarter/user/getUserProfileDashboard";
    var responce = await http.post(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    print(responce);
    return responce;
  }

  loadDashboard() async {
    var res = await getDashboard();
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      loadDashboard();
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 409) {
      return resbody['message'];
    } else if (res.statusCode == 200) {
      userPostCount = resbody['userPostCount'];
      userConnectionsCount = resbody['userConnectionsCount'];
      print(resbody);
    }
  }

  @override
  Future getprfilepage() async {
    var url =
        "$urlStarter/user/settingsGetMainInfo?email=${GetStorage().read("loginemail")}";
    var responce = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    print(responce);
    return responce;
  }

  @override
  goToprofilepage() async {
    await loadDashboard();
    var res = await getprfilepage();
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      goToprofilepage();
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 409) {
      return resbody['message'];
    } else if (res.statusCode == 200) {
      GetStorage().write("photo", resbody["user"]["photo"]);
      Get.to(ProfileMainPage(
          userData: [resbody["user"]],
          userPostCount: userPostCount,
          userConnectionsCount: userConnectionsCount));
    }
  }

  @override
  Future getUserProfilePage(String userUsername) async {
    var url =
        "$urlStarter/user/getUserProfileInfo?ProfileUsername=$userUsername";
    var responce = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    return responce;
  }

  @override
  goToUserPage(String userUsername) async {
    if (userUsername == GetStorage().read('username')) {
      await goToprofilepage();
      return;
    }
    var res = await getUserProfilePage(userUsername);
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      goToUserPage(userUsername);
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 409) {
      return resbody['message'];
    } else if (res.statusCode == 200) {
      if (resbody['user'] is Map<String, dynamic>) {
        print("ppppp");
        print([resbody["user"]]);
        //  Get.to(ColleaguesProfile(userData: [resbody["user"]]));

        Get.to(() => ColleaguesProfile(userData: [resbody["user"]]));

        return true;
      }
    }
  }
@override
  Future getProfilePage(String pageId) async {
    var url =
        "$urlStarter/user/getPageProfileInfo?pageId=$pageId";
    var responce = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
      'Authorization': 'bearer ' + GetStorage().read('accessToken'),
    });
    return responce;
  }

  @override
  goToPage(String pageId) async {
    /*if (pageId == GetStorage().read('username')) {
      await goToprofilepage();
      return;
    }*/
    var res = await getProfilePage(pageId);
    if (res.statusCode == 403) {
      await getRefreshToken(GetStorage().read('refreshToken'));
      goToPage(pageId);
      return;
    } else if (res.statusCode == 401) {
      _logoutController.goTosigninpage();
    }
    var resbody = jsonDecode(res.body);
    if (res.statusCode == 409) {
      return resbody['message'];
    } else if (res.statusCode == 200) {
      var page = resbody['Page'];
      if(page['isAdmin']== true){
        Get.to(PageProfile(isAdmin: page['isAdmin'] , userData: PageInfo(page['id'], page['name'], page['description'], page['country'], page['address'], page['contactInfo'], page['specialty'], page['pageType'], page['photo'], page['coverImage'],page['postCount'],page['followCount'],page['adminType'])));
      }else{
        Get.to(ColleaguesPageProfile(following: page['following'],userData: PageInfo(page['id'], page['name'], page['description'], page['country'], page['address'], page['contactInfo'], page['specialty'], page['pageType'], page['photo'], page['coverImage'],page['postCount'],page['followCount'])));
      }
      print(page);
      print(page["isAdmin"]);
    }
  }
  @override
  void onInit() {
    // Fetch initial data or perform any setup
    // For now, let's add some dummy data

    super.onInit();
  }
}
