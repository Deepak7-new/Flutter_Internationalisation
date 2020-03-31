# test_app

A Flutter application which uses intl_translation for translating text in app on locale change.
I have created widget "Trans", which translates the test given to it on locale change and also gives support for plural and gender.

## Getting Started
To run this app :
1. Download or clone this app then open your ide (with flutter configured).
2. Run packages get in pubspec.yaml file
3. Run main.dart

##
On locale change:
1. Uses text as key to find translation
2. If translation for given key is not found then tranlate it using google translator and notify it to the developer by logging it to the console.
3. Currently I have given translation for only three languages i.e. English, Hindi and French.
4. However one can give translation for any other language by going to "converted_text.dart" class.
