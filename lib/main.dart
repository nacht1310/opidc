// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
// import the io version
import 'package:openid_client/openid_client_io.dart';
// use url launcher package
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String logoutUrl = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
                onPressed: () async {
                  var userInfo = authenticate(
                      Uri.parse(
                          'https://authenticationserver20220111094343.azurewebsites.net'),
                      "user-management-app",
                      ['IdentityServerApi', 'profile']);
                  print(userInfo.toString());
                },
                child: const Text("Here the code"))
          ],
        ),
      ),
    );
  }

  Future<TokenResponse> authenticate(
      Uri uri, String clientId, List<String> scopes) async {
    // create the client
    var issuer = await Issuer.discover(uri);
    var client = Client(issuer, clientId);
    // create a function to open a browser with an url
    urlLauncher(String url) async {
      print(
          '$url&&code_challenge=PqokAO1BQBHyJVKPqokAO1BQBHyJVKPqokAO1BQBHyJVKPqokAO1BQBHyJVKPqokAO1BQBHyJVKPqokAO1BQBHyJVKPqokAO1BQBHyJVKPqokAO1BQBHyJVK12345678&code_challenge_method=S256');
      await launch(
          '$url&&code_challenge=PqokAO1BQBHyJVKPqokAO1BQBHyJVKPqokAO1BQBHyJVKPqokAO1BQBHyJVKPqokAO1BQBHyJVKPqokAO1BQBHyJVKPqokAO1BQBHyJVKPqokAO1BQBHyJVK12345678&code_challenge_method=S256',
          forceWebView: true,
          enableJavaScript: true);
    }

    // create an authenticator
    var authenticator = Authenticator(client,
        scopes: scopes,
        redirectUri: Uri.parse(
            'https://authenticationserver20220111094343.azurewebsites.net/account/login'),
        urlLancher: urlLauncher);

    // starts the authentication
    var c = await authenticator.authorize();

    // close the webview when finished
    closeWebView();

    var res = await c.getTokenResponse();
    print(res.accessToken);
    return res;
  }
}
