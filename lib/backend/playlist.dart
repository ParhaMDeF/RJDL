import 'package:web_scraper/web_scraper.dart  ';
class Playlist{
  late String  playlistName ;
  late String playlistCover;
  late List<String> itemsLink =[];
  late List<String> itemsArtist =[];
  late List<String> itemsSongName =[];
  late List<String> cover =[];
  late List<Map<String ,dynamic>> items;
  Future<void> scrapping() async {
    final webScraper = WebScraper('https://www.radiojavan.com');
    if (await webScraper.loadWebPage('/playlists/playlist/mp3/6dbfcdfe02d0')) {
      playlistName = webScraper.getElementTitle(
          'div.songInfo > h2.title')[0];
      playlistCover =  webScraper.getElement(
          'div.artworkContainer > img' , ['src']).toList()[0]['attributes']['src'];
      items = webScraper.getElement('ul.listView > li > a', ['href']);
      itemsArtist = webScraper.getElementTitle('ul.listView > li > a >div.songInfo> span.artist');
      itemsSongName = webScraper.getElementTitle('ul.listView > li > a >div.songInfo> span.song');
      for(int i=0 ; i< items.length ; i++) {
        itemsLink.add(items[i]['attributes']['href']);
        itemsArtist.add(items[i]['attributes']['href']);
        cover.add(webScraper.getElement('div.sidePanel > ul.listView > li > a > img' , ['data-src'])[i]['attributes']['data-src']);

      }
      print(itemsSongName);
      // print(cover);

    }else {
      print('failed');
    }
  }
}