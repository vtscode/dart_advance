import 'dart:io';

void platformData(){
  print('OS : ${Platform.operatingSystem} ${Platform.version}');

  if(Platform.isWindows){
    print('Run windows code');
  }else{
    print('run normal code');
  }

  print('Path : ${Platform.script.path}');
  print('dart : ${Platform.executable}');

  print('ENV : ');
  Platform.environment.keys.forEach((element) {
    print('${element} => ${Platform.environment[element]}');
  });
}
