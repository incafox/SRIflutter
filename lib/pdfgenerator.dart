import 'dart:io';
import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:async';


Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  print(directory.path);
  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/counter.txt');
}

Future<File> writeContent() async {
  final file = await _localFile;
  // Write the file
  return file.writeAsString('Hello Folk');
}

Future<void> main() async {

  //Uint8List fontData = File('open-sans.ttf').readAsBytesSync();
  //var data = fontData.buffer.asByteData();

  //var myFont = Font.ttf(data);
  //var myStyle = TextStyle(font: myFont);

  final Document pdf = Document();
  pdf.addPage(Page(
      pageFormat: PdfPageFormat.a4,
      build: (Context context) {
        return Center(
          child: Text("Hello World",),
        ); // Center
      })); // Page

  // On Flutter, use the [path_provider](https://pub.dev/packages/path_provider) library:
  var content = pdf.save();

  var output = await getApplicationDocumentsDirectory();
  var file = File("${output.path}/example.pdf");
  print (file.path);
  await file.writeAsBytes(content);

  writeContent();


}