import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:test_app/widgets/locales_list.dart';
import 'conversion_classes.dart';

class DemoApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return DemoAppState();
  }
}

class DemoAppState extends State<DemoApp> {
  int counter = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Trans(
          "Hello world",
          style: TextStyle(fontSize: 25),
          softWrap: true,
        ),
      ),
      body: Center(
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Divider(height: 50,),
          Trans("You typed it %d times".plural(counter),style: TextStyle(fontSize: 18),),
          Divider(height: 50,),
          MaterialButton(
            color: Colors.blue,
            child: Text(
              "Increment",
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
            onPressed: ()=>setState(()=>counter++)
          ),
          Divider(height: 50,),
          Trans("there is a person".gender("male"),style: TextStyle(fontSize: 18),),
        ],
      ),
      ),
    );
  }
}

class Demo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        const DemoLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: locales,
      home: DemoApp(),
    );
  }
}
