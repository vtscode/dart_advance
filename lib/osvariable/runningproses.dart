import 'dart:convert';
import 'dart:io';

void ProcessFlow(){
  //  list all files in a directory - linux spesific
  Process.run('notepad', []).then((ProcessResult process) {
    print(process.stdout); // standart output, console output
    print('Exit code : ${process.exitCode}'); // 0 is good
    Process.killPid(process.pid);
  });
}

void CommunicateProcess(){
//  linux spesific
Process.start('cmd', []).then((Process process){
  //  transfer the output
  process.stdout.transform(utf8.decoder).listen((data) {
    print(data);
  });

  //  send data to the process
  process.stdin.writeln('Halo dunia');

  //  stop the process
  Process.killPid(process.pid); // kill signal to process

  //  get the exit code
  process.exitCode.then((int code) {
    print('Exit code : ${code}'); // -1
    //exit
    exit(0); // something to tell OS on executable code, need no error so with 0 code
  });
});
}