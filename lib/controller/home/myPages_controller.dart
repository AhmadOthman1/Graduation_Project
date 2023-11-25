import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:growify/global.dart';
import 'package:http/http.dart' as http;

class PageInfo {
  final String id;
  final String name;
  final String description;
  final String country;
  final String address;
  final String contactInfo;
  final String specialty;
  final String pageType;
  final String? photo;
  final String? coverImage;

  PageInfo(this.id, this.name, this.description, this.country, this.address, this.contactInfo, this.specialty, this.pageType, this.photo, this.coverImage);
}

String? Email = GetStorage().read("loginemail");

class MyPagesController {
  Future<List<PageInfo>?> getMyPagesData() async {
    var url = urlStarter + "/user/getMyPages?email=$Email";
    var response = await http.get(Uri.parse(url), headers: {
      'Content-type': 'application/json; charset=UTF-8',
    });
    print(response);
    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var responseBody = jsonDecode(response.body);
      List<PageInfo> pages = [];

      for (var page in responseBody['pages']) {
        print(page);
        pages.add(PageInfo(page['id'], page['name'], page['description'], page['country'], page['address'], page['contactInfo'], page['specialty'], page['pageType'], page['photo'], page['coverImage']));
        print('Page ID: ${page['id']}');
        print('Page Name: ${page['name']}');
        print('Page Image: ${page['photo']}');
      }
      print(pages);
      return pages;
    } else if (response.statusCode == 409 || response.statusCode == 500) {
      return null;
    }
  }
}
