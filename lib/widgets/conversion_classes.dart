import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_app/widgets/locales_list.dart';
import '../translator.dart';
import 'dart:ui' as ui;
import 'converted_text.dart';

class TextLocalizations {
  TextLocalizations(this.locale);

  final Locale locale;
  final translator = GoogleTranslator();

  static TextLocalizations of(BuildContext context) {
    return Localizations.of<TextLocalizations>(context, TextLocalizations);
  }

  Future<String> convertText(String originalText) async {
    List<String> textList = modifiedString(originalText);
    String text = textList[0];
    int conversionStatus = isTranslated(text);
    if (conversionStatus == 2) {
      if(textList.length == 2){
        return dataMap[text][locale.languageCode].replaceAll("%d", textList[1]);
      }
      return dataMap[text][locale.languageCode];
    } else if (conversionStatus == 1) {
      String translatedText =
          await translator.translate(text, to: locale.languageCode);
      print("translation done for : "+text+" in : "+locale.languageCode);
      Map<String, String> content = {locale.languageCode: translatedText};
      dataMap[text].addAll(content);
      return translatedText;
    } else if (conversionStatus == 0) {
      String translatedText =
          await translator.translate(text, to: locale.languageCode);
      print("translation done for : "+text+" in : "+locale.languageCode);
      Map<String, Map<String, String>> content = {
        text: {locale.languageCode: translatedText}
      };
      dataMap.addAll(content);
      return translatedText;
    } else {
      return null;
    }
  }

  int isTranslated(String text) {
    if (dataMap.containsKey(text)) {
      Map<String, String> translatedLanguages = dataMap[text];
      if (translatedLanguages.containsKey(locale.languageCode)) {
        return 2; //translation for selected locale is present
      } else {
        return 1; //translation for selected locale is not present but key is present
      }
    } else {
      //key is not present
      return 0;
    }
  }

  List<String> modifiedString(String text) {
    List<String> splittedString = text.split("\uFFFF");
    if (splittedString.length == 1) {
      return [text];
    } else {
      if (splittedString[1] == "0") {
        return [splittedString[0].replaceAll("%d", "0")];
      } else if (splittedString[1] == "1") {
        return [splittedString[0].replaceAll("%d", "1")];
      } else if (splittedString[1] == "M") {
        return [splittedString[0] + "_M"];
      } else if (splittedString[1] == "F") {
        return [splittedString[0] + "_F"];
      } else if (splittedString[1] == "o") {
        return [splittedString[0]];
      } else if (int.parse(splittedString[1]) != null) {
        return [splittedString[0],splittedString[1]];
      } else {
        return throw new FormatException("Unexpected modifier");
      }
    }
  }
}

const _seperator = "\uFFFF";

extension MyExtension on String {
  String modifier(String id, String text) {
    if (id == "0") {
      return text + _seperator + id;
    } else if (id == "1") {
      return text + _seperator + id;
    } else if (id == "M") {
      return text + _seperator + id;
    } else if (id == "F") {
      return text + _seperator + id;
    } else if (id == "o") {
      return text + _seperator + id;
    } else if (int.parse(id) != null) {
      return text + _seperator + id;
    } else {
      return throw new FormatException("Invalid Id in modifier");
    }
  }

  String plural(int counter) {
    if (counter == 0) {
      return modifier("0", this);
    } else if (counter == 1) {
      return modifier("1", this);
    } else {
      return modifier("$counter", this);
    }
  }

  String gender(String gender) {
    if (gender == "male") {
      return modifier("M", this);
    } else if (gender == "female") {
      return modifier("F", this);
    } else if (gender == "other") {
      return modifier("o", this);
    } else {
      return throw new FormatException("Invalid gender");
    }
  }
}

class DemoLocalizationsDelegate
    extends LocalizationsDelegate<TextLocalizations> {
  const DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => localesList.contains(locale.languageCode);

  @override
  Future<TextLocalizations> load(Locale locale) async {
    return TextLocalizations(locale);
  }

  @override
  bool shouldReload(DemoLocalizationsDelegate old) => false;
}

// Widget for Text translation
class Trans extends StatelessWidget {
  final String data;
  final TextStyle style;
  final StrutStyle strutStyle;
  final TextAlign textAlign;
  final ui.TextDirection
      textDirection; //similar Class is present in intl package
  final Locale locale;
  final bool softWrap;
  final TextOverflow overflow;
  final double textScaleFactor;
  final int maxLines;
  final String semanticsLabel;
  final TextWidthBasis textWidthBasis;

  const Trans(
    this.data, {
    Key key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
  }) : assert(
          data != null,
          'A non-null String must be provided to a Trans widget.',
        );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: TextLocalizations.of(context).convertText(data),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text("");
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Text("Loading..");
            case ConnectionState.done:
              if (snapshot.hasError) return Text('Error: ${snapshot.error}');
              return Text(
                snapshot.data,
                key: key,
                style: style,
                strutStyle: strutStyle,
                textAlign: textAlign,
                textDirection: textDirection,
                locale: locale,
                softWrap: softWrap,
                overflow: overflow,
                textScaleFactor: textScaleFactor,
                maxLines: maxLines,
                semanticsLabel: semanticsLabel,
                textWidthBasis: textWidthBasis,
              );
          }
          return Text("");
        });
  }
}

//Widget for Date translation
class TransDate extends StatelessWidget {
  final DateTime date;
  TransDate(this.date) {
    assert(date != null);
  }
  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat =
        new DateFormat.yMMMMd(ui.window.locale.languageCode);
    return Text(dateFormat.format(date));
  }
}

//Widget for Time translation
class TransTime extends StatelessWidget {
  final DateTime time;
  TransTime(this.time);
  @override
  Widget build(BuildContext context) {
    DateFormat timeFormat = new DateFormat.Hms(ui.window.locale.languageCode);
    return Text(timeFormat.format(time));
  }
}
