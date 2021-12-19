
import 'package:flutter/cupertino.dart';
import 'package:web_scraper/web_scraper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class Podcast extends ChangeNotifier{
  late String  podcastName , artist ,podcastCover ,downloadLink , fileName;
  late List<Map<String ,dynamic>> items;
  Future<void> scrapping(var link) async {
    final webScraper = WebScraper('https://rjapp.app');
    link =  link.replaceRange(0, 17, '');
    if (await webScraper.loadWebPage(link)) {
      fileName = webScraper.getElement('head > link' , ['href'])[0]['attributes']['href'].replaceRange(0, 44, '');
      podcastName = webScraper.getElementTitle(
          'div.songInfo > span.artist')[0];
      artist = webScraper.getElementTitle(
          'div.songInfo > span.song')[0];
      podcastCover =  webScraper.getElement(
          'div.artwork > img' , ['src']).toList()[0]['attributes']['src'];
      items = webScraper.getElement('ul.listView > li > a', ['href']);
      var response =await http.post(Uri.parse('https://www.radiojavan.com/podcasts/podcast_host') , body: {'id': fileName});
      var host = json.decode(response.body)['host'];
      downloadLink = host + '/media/podcast/mp3-192/' + fileName +'.mp3';
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