import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MABOLCI SMARTHOME',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.lime,),
      home: MyHomePage(),
    );
  }
}

Future<http.Response> fetchAddress() async {
  final response = await http.get(Uri.parse('https://raw.githubusercontent.com/MasterCoookie/mabolci_smarthome_app/master/address.txt'));
  return response;
}

// ignore: use_key_in_widget_constructors
class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setBackgroundColor(const Color(0x00000000))
  ..setNavigationDelegate(
    NavigationDelegate(
      onProgress: (int progress) {
        // Update loading bar.
      },
      onPageStarted: (String url) {},
      onPageFinished: (String url) {},
      onWebResourceError: (WebResourceError error) {},
      onNavigationRequest: (NavigationRequest request) {
        return NavigationDecision.navigate;
      },
    ),
  );
  
  final _formKey = GlobalKey<FormState>();
  var hasAddress = false;
  var address = '';
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    
    
    if(!hasAddress) {
      return Form(
        key: _formKey,
        child:
        Scaffold(
          body: Center(
            child: TextFormField(
              decoration: const InputDecoration(
          icon: Icon(Icons.settings),
          hintText: 'Please input Dashticz address',
          labelText: 'Address',
        ),
              onFieldSubmitted: (value) {
                setState(() {
                  hasAddress = true;
                  address = value;
                });
              },
            ),
          ),
        ),
);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      return Scaffold(
            body: Center(
            child: WebViewWidget(controller: controller..loadRequest(Uri.parse(address)))
            ),
    );
    }
    
  }
}