import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:web_scraper/web_scraper.dart';

class Music extends ChangeNotifier{

  late String artist , songName ,downloadLink ,fileName ;
  late List<Map<String, dynamic>> cover;
  Future<void> scrapping(var link , bool single) async {
    final webScraper = WebScraper(single ? 'https://rjapp.app' : 'https://www.radiojavan.com');
    link = single ? link.replaceRange(0, 17, '') :  link ;
    if (await webScraper.loadWebPage(link)) {
      fileName = webScraper.getElement('head > link' , ['href'])[0]['attributes']['href'].replaceRange(0, 36, '');
      artist = webScraper.getElementTitle(
          'div.songInfo > span.artist')[0];
      songName = webScraper.getElementTitle(
          'div.songInfo > span.song')[0];
      cover =  webScraper.getElement(
          'div.artwork > img' , ['src']);
      var response =await http.post(Uri.parse('https://www.radiojavan.com/mp3s/mp3_host') , body: {'id': fileName});
      var host = json.decode(response.body)['host'];
      downloadLink = host + '/media/mp3/' + fileName +'.mp3';
      print(downloadLink);
      notifyListeners();
    }else {
      print('failed');
    }
  }
  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}