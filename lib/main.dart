import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MaterialApp(
  title: 'Flutter Browser',
  theme: ThemeData(
    primarySwatch: Colors.deepOrange,
  ),
  home: MyHomePage(),
));

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  WebViewController _webViewController;
  TextEditingController _teController = new TextEditingController();
  bool showLoading = false;

  void updateLoading(bool ls) {
    this.setState((){
      showLoading = ls;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Flexible(
                flex: 1,
                child: Container(
                  color: Colors.deepOrange,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Flexible(
                            flex: 2,
                            child: Text("http://",style: TextStyle(color: Colors.white,fontSize: 20),)),
                        Flexible(
                          flex: 4,
                          child: TextField(
                            autocorrect: false,
                            style: TextStyle(color: Colors.white,fontSize: 20),
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  style: BorderStyle.solid,
                                  color: Colors.white,
                                  width: 2
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    style: BorderStyle.solid,
                                    color: Colors.white,
                                    width: 2
                                ),
                              )
                            ),
                            controller: _teController,
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Center(
                            child: IconButton(icon: Icon(Icons.arrow_forward,color: Colors.white,), onPressed: (){
                              String finalURL = _teController.text;
                              if(!finalURL.startsWith("https://")){
                                finalURL = "https://"+finalURL;
                              }
                              if(_webViewController != null){
                                  updateLoading(true);
                                  _webViewController.loadUrl(finalURL).then((onValue){

                                }).catchError((e){
                                  updateLoading(false);
                                });
                              }
                            }),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 9,
                child: Stack(
                  children: <Widget>[
                    WebView(
                      initialUrl: 'http://google.com',
                      onPageFinished: (data){
                        updateLoading(false);
                      },
                      javascriptMode: JavascriptMode.unrestricted,
                      onWebViewCreated: (webViewController){
                        _webViewController = webViewController;
                      },
                    ),
                    (showLoading)?Center(child: CircularProgressIndicator(),):Center()
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

