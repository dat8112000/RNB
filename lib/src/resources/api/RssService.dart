import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';

class RssService {
  Future<AtomFeed> getFeed(String _targetUrl) => http
      .read(Uri.parse(_targetUrl))
      .then((xmlString) => AtomFeed.parse(xmlString));
}
