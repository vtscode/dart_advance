import 'dart:io';
import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:path/path.dart' as p;

String generateData(){
  String data = '';
  for(int i = 0; i < 1000; i++){
    data = data + 'halo dunia\r\n';
  }
  return data;
}
// compression : take data dan make data a lot smaller
// compression : Taking data and reducing the amount of space it takes up.
/*
* Data takes less room in transmission and storage when use compression
* If there are a lot data from internet, why send more bytes on internet
* if we can compress to more tiny size bytes, coz speed internet more slower
* than processor on our computer,
* File system need to be simple
* */
void CompressExample(){
  // original Data,
  String data = generateData();
  //  encoding ist not encryption
  List original = utf8.encode(data);

  //compress data
  List compressed = gzip.encode(original);

  //decompressed
  List decompressed = gzip.decode(compressed);

  print('Original : ${original.length} bytes');
  print('Compressed : ${compressed.length} bytes');
  print('Decompressed : ${decompressed.length} bytes');

  String decoded = utf8.decode(decompressed);
  assert(data == decoded); // if not break program then its true
}
void GzipvsZlib(){
  // zlib has better compression ratio, but gzip more faster
  int zlib = testCompress(ZLIB); // compression algorithm
  int gzip = testCompress(GZIP); // compression algorithm

  print('zlib = ${zlib}');
  print('gzip = ${gzip}');
}
int testCompress(var codec){
  String data = generateData();
  List original = utf8.encode(generateData());
  List compressed = codec.encode(original);
  List decompressed = codec.decode(compressed);

  print('Testing ${codec.toString()}');
  print('Original : ${original.length} bytes');
  print('Compressed : ${compressed.length} bytes');
  print('Decompressed : ${decompressed.length} bytes');

  print('');

  String decoded = utf8.decode(decompressed);
  assert(data == decoded);

  return compressed.length;
}


// archive
void ArchiveExample(){
  List<String> files = new List<String>();
  //build list path file to be add on zip file
  Directory.current.listSync().forEach((FileSystemEntity fse) {
    if(fse.statSync().type == FileSystemEntityType.file) files.add(fse.path);
  });
  //directory
  String zipFileDir = Directory.current.path + '/test_archive';
  //path of zip file
  String zipFile = zipFileDir + '/test.zip';

  //zipping on
  zip(files,zipFile);
  //unzipping in same directory
  unzip(zipFile, zipFileDir);
}
void zip(List<String> files, String file){
  Archive archive = new Archive();
  files.forEach((String path) {
    File file = new File(path);
    //make a record
    ArchiveFile archiveFile = new ArchiveFile(p.basename(path), file.lengthSync(), file.readAsBytesSync());
    archive.addFile(archiveFile);
  });

  ZipEncoder encoder = new ZipEncoder();
  File f = new File(file);
  f.writeAsBytesSync(encoder.encode(archive));

  print('Compressed');
}
void unzip(String zip, String path){
  File file = new File(zip);

  Archive archive = new ZipDecoder().decodeBytes(file.readAsBytesSync());

  archive.forEach((ArchiveFile archiveFile) {
    File file = new File(path + '/' + archiveFile.name);
    file.createSync(recursive: true);
    file.writeAsBytesSync(archiveFile.content);
  });

  print('Decompressed');
}
