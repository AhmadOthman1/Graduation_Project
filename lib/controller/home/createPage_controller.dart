class CreatePageController {
  // Implement the function to send the request to the server
   createPage({
    required String pageId,
    required String pageName,
    required String description,
    required String country,
    required String address,
    required String contactInfo,
    required String speciality,
    required String pageType,
  }) async {
    // Your logic to send the request to the server
    // You can use the http package or any other way you prefer
    // Example using http package:
    // await http.post('your_server_endpoint', body: {
    //   'pageId': pageId,
    //   'pageName': pageName,
    //   // Include other parameters
    // });

    // For simplicity, let's print the values for now
    print('Creating page with:');
    print('Page ID: $pageId');
    print('Page Name: $pageName');
    print('Description: $description');
    print('Country: $country');
    print('Address: $address');
    print('Contact Info: $contactInfo');
    print('Speciality: $speciality');
    print('Page Type: $pageType');
    return ; 
  }
  
}