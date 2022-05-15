import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:rnb/src/resources/Screen/article.dart';
import 'package:webfeed/domain/rss_feed.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

class topicDetails extends StatefulWidget {
  final String link;

  const topicDetails({Key? key, required this.link}) : super(key: key);

  @override
  _topicDetailsState createState() => _topicDetailsState();
}

class _topicDetailsState extends State<topicDetails> {
  var _feed;
  var _title;
  FlutterTts flutterTts = FlutterTts();
  static const String loadingFeedMsg = 'Đang tải...';
  static const String feedLoadErrorMsg = 'Error Loading Feed.';
  static const String feedOpenErrorMsg = 'Error Opening Feed.';
  static const String placeholderImg = 'images/no_image.png';
  late GlobalKey<RefreshIndicatorState> _refreshKey;
  int _destinationIndex = 0;
  final _scrollController = ScrollController();
  updateTitle(title) {
    setState(() {
      _title = title;
    });
  }

  updateFeed(feed) {
    setState(() {
      _feed = feed;
    });
  }

  Future<void> openFeed(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: false,
      );
      return;
    }
    updateTitle(feedOpenErrorMsg);
  }

  load() async {
    updateTitle(loadingFeedMsg);
    loadFeed(widget.link).then((result) {
      if (null == result || result.toString().isEmpty) {
        updateTitle(feedLoadErrorMsg);
        return;
      }
      updateFeed(result);
      updateTitle(_feed.title);
    });
  }

  loadFeed(String link) async {
    try {
      final client = http.Client();
      final response = await client.get(Uri.parse(link));
      return RssFeed.parse(utf8.decode(response.bodyBytes));
    } catch (e) {
      //
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _refreshKey = GlobalKey<RefreshIndicatorState>();
    updateTitle(widget.link);
    load();
  }

  title(title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  subtitle(subTitle) {
    return Text(
      subTitle,
      style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w100),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  thumbnail(imageUrl) {
    return Padding(
      padding: EdgeInsets.only(left: 15.0),
      child: CachedNetworkImage(
        placeholder: (context, url) => Image.asset(placeholderImg),
        imageUrl: imageUrl,
        height: 50,
        width: 70,
        alignment: Alignment.center,
        fit: BoxFit.fill,
      ),
    );
  }

  rightIcon() {
    return Icon(
      Icons.keyboard_arrow_right,
      color: Colors.grey,
      size: 30.0,
    );
  }

  list() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _feed.items.length,
      itemBuilder: (BuildContext context, int index) {
        final item = _feed.items[index];
        return Card(
          color: index == _destinationIndex
              ? Colors.green
              : Colors.white,
          child: ListTile(
            title: title(item.title),
            subtitle: subtitle(item.description
                .replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ')
                .toString()),

            // leading: thumbnail(item.enclosure.url),
            trailing: rightIcon(),
            contentPadding: EdgeInsets.all(5.0),
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ArticleScreen(link: item.link)))
            },
          ),
        );
      },
    );
  }

  isFeedEmpty() {
    return null == _feed || null == _feed.items;
  }

  body() {
    return isFeedEmpty()
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(
            key: _refreshKey,
            child: list(),
            onRefresh: () => load(),
          );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: GestureDetector(
          onDoubleTap: () {
            setState(() {
              if (_feed.items.length - 1 > _destinationIndex) {
                _destinationIndex++;
              } else {
                _destinationIndex = 0;
              }
              // readTutorial(_feed.items[_destinationIndex]);
            });
          },
          onPanUpdate: (details) {
            if (details.delta.dx > 0) {
              Navigator.pop(context);
            } else if (details.delta.dx < 0) {
              flutterTts.stop();
              // Navigator.push(
              //     context, MaterialPageRoute(builder: (context) => MainHome()));
            }
          },
          child: body(),
        ),
      ),
    );
  }
  Future readTutorial(String text) async {
    await Future.delayed(const Duration(seconds: 0));
    await flutterTts.setLanguage("vi-VN");
    await flutterTts.setPitch(0.7);
    await flutterTts.speak(text);
  }
}
