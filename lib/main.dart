import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'custom_webview.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WebViewApp(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WebViewApp extends StatefulWidget {
  @override
  _WebViewAppState createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  String url = '';
  bool modalVisible = false;
  bool isloading = true;
  final GlobalKey<CustomWebViewState> _webViewKey = GlobalKey<CustomWebViewState>();

  @override
  void initState() {
    super.initState();
    _loadUrl();
  }

  Future<void> _loadUrl() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      url = prefs.getString('savedUrl') ?? 'http://izbelyazilim.com.tr';
    _webViewKey.currentState?.loadUrl(url);
    setState(() {
      isloading = false;
    });
    
  }

  Future<void> _saveUrl(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('savedUrl', url);
  }

  void handleSaveUrl() {
    _saveUrl(url);
    setState(() {
      modalVisible = false;
    });
    _webViewKey.currentState?.loadUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NetAdisyon'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              setState(() {
                modalVisible = true;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          isloading ? CircularProgressIndicator() :CustomWebView(key: _webViewKey, initialUrl: url),
          if (modalVisible)
            ModalBarrier(
              color: Colors.black.withOpacity(0.5),
              dismissible: false,
            ),
          if (modalVisible)
            Center(
              child: Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'URL girin',
                      ),
                      onChanged: (value) {
                        url = value;
                      },
                      controller: TextEditingController(text: url),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: handleSaveUrl,
                          child: Text('Kaydet'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              modalVisible = false;
                            });
                          },
                          child: Text('İptal'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
