import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class ProductWebsiteView extends StatelessWidget {
  final String websiteURL;
  final isLoading = false.obs;

  ProductWebsiteView({Key key, @required this.websiteURL}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(websiteURL),
          actions: [
            Obx(
              () => isLoading.value
                  ? Center(
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.black),
                        ),
                      ),
                    )
                  : Container(),
            ),
            IconButton(
              icon: Icon(Icons.open_in_browser),
              onPressed: () {
                launch(websiteURL);
              },
            ),
            Builder(
              builder: (BuildContext context) => IconButton(
                icon: Icon(Icons.copy),
                onPressed: () {
                  Clipboard.setData(new ClipboardData(text: websiteURL));
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("Copied!"),
                    duration: Duration(milliseconds: 1000),
                  ));
                },
              ),
            ),
          ],
        ),
        body: WebView(
          initialUrl: websiteURL,
          javascriptMode: JavascriptMode.unrestricted,
          onPageStarted: (url) => isLoading.value = true,
          onPageFinished: (url) => isLoading.value = false,
        ),
      ),
    );
  }
}
