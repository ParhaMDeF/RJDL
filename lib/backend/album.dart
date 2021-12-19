import 'dart:convert';

import 'package:web_scraper/web_scraper.dart';
import 'package:http/http.dart' as http;
class Album {
  late String albumName, artist;
  late String albumCover;
  late List<String> itemsLink = [];
  late List<String> itemsSongName = [];
  late List<String> downloadLink = [];
  late List<String> fileNames = [];
  // late List<String> cover = [];
  late List<Map<String, dynamic>> items;

  Future<dynamic> scrapping(var link) async {
    if(itemsLink.isNotEmpty)
      {
        itemsLink.clear();
        itemsSongName.clear();
        // cover.clear();
        items.clear();
      }
    final webScraper = WebScraper('https://rjapp.app');
    link = link.replaceRange(0, 17, '');
    if (await webScraper.loadWebPage(link)) {
      albumName = webScraper.getElementTitle('div.songInfo > span.album')[0];
      artist = webScraper.getElementTitle('div.songInfo > span.artist')[0];
      albumCover =
          webScraper.getElement('div.artwork > img', ['src']).toList()[0]
              ['attributes']['src'];
      items = webScraper.getElement('ul.listView > li > a', ['href']);
      itemsSongName = webScraper
          .getElementTitle('ul.listView > li > a >div.songInfo> span.song');
      // cover.add(webScraper
      //         .getElement('ul.listView > li.active > a > img', ['data-src'])[0]
      //     ['attributes']['data-src']);
      for (int i = 1; i < items.length; i++) {
        itemsLink.add(items[i]['attributes']['href']);
      //   cover.add(
      //       webScraper.getElement('ul.listView > li > a > img', ['data-src'])[i]
      //           ['attributes']['data-src']);
       }
      var response =await http.post(Uri.parse('https://www.radiojavan.com/mp3s/mp3_host') , body: {'id': fileName});
      var host = json.decode(response.body)['host'];
      downloadLink.add( host + '/media/mp3/' + fileName +'.mp3');

    } else {
      print('failed');
    }
  }
}
