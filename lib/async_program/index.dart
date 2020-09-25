import 'dart:async';
import 'dart:io';
int counter = 0;
/*
* Timer : a callback in memory, one time or periodic
* mouse see on screen its timer,
* mouse moving its a callback on the OS
* make a timer = stopwatch,
* in duration we can call function
* */
// Initial
void asyncExample(){
  Duration duration = new Duration(seconds: 1);
  Timer timer = new Timer.periodic(duration,ExampleTimer);
  
  print('Started ${getTime()}');
}
void ExampleTimer(Timer timer){
  print('Timeout : ${getTime()}');
  counter++;

  if(counter >= 5) timer.cancel();
}
String getTime(){
  DateTime dt = new DateTime.now();
  return dt.toString();
}

// futures : the promise of a value
void FuturesExample(){
  String path = Directory.current.path + '/test.txt';
  print('Appedning to ${path}');

  File file = new File(path);

  Future<RandomAccessFile> f = file.open(mode: FileMode.append);
  f.then((RandomAccessFile raf){
    print('File has been opened');
    raf.writeString('Halo dunia').then((value) {
      print('file has been appended!');
    }).catchError(() => print('An error occured')).whenComplete(() => raf.close());
  });

  print('*** The End');
}

/*
* create function future with async mode to return future
* not actual the object but when it return will be a file
* */
Future<File> appendFile(){
 File file = new File(Directory.current.path + '/test2.txt');
 DateTime now = new DateTime.now();
 
 //return future
 return file.writeAsString(now.toString() + '\r\n', mode: FileMode.append);
}
//allow async code to execute in the function
void awaitExample() async{
  // await : waits for the value from a Future
  print('starting');
  
  File file = await appendFile();
  
  print('Appended to file ${file.path}');
  print('*** END');
}
