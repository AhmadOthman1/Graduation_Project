import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:growify/global.dart';
import 'package:http/http.dart' as http;

class PageInfo {
  final int id;
  final String name;
  final String image;

  PageInfo(this.id, this.name, this.image);
}
String? Email=GetStorage().read("loginemail") ;
class MyPagesController {
  Future<List<PageInfo>?> getMyPagesData() async {
    var url = urlStarter + "/user/getMyPages?email=$Email";
    var response = await http.get(Uri.parse(url),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    print(response);
    var responseBody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      // Parse the response and return a list of PageInfo
      
      List<PageInfo> pages = [];

      for (var page in responseBody['pages']) {
        pages.add(PageInfo(page['id'], page['name'], page['image']));
      }

      return pages;
    } else if(response.statusCode == 409 || response.statusCode == 500){
      return null;
    }
  }
}