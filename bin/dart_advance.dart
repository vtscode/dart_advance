import 'package:dart_advance/dart_advance.dart' as dart_advance;
import 'package:dart_advance/database_program/index.dart';
import 'package:dart_advance/osvariable/index.dart';
import 'package:dart_advance/osvariable/runningproses.dart';
import 'package:dart_advance/async_program/index.dart';
import 'package:dart_advance/compression/index.dart';
import 'package:dart_advance/encryption/index.dart';
import 'package:dart_advance/socket_programming/index.dart';

void main(List<String> arguments) {
  // OSvarInit();
  // AsyncProgram();
  // CompressionEx();
  // EncryptionEx();
  // SocketProgram();
  DBProgram();
}

void OSvarInit(){
  platformData();
  ProcessFlow();
  CommunicateProcess();
}
void AsyncProgram (){
  asyncExample();
  FuturesExample();
  awaitExample();
}
void CompressionEx(){
  CompressExample();
  // GzipvsZlib();
  // ArchiveExample();
}
void EncryptionEx(){
  DigestExample();
  DerivingKeys();
  SecureRandomNumber();
  StreamChipers();
  BlockCipherExample();
}
void SocketProgram(){
  // SocketTCPServer();
  // duplicate this project folder dan run different IDE
  // SocketTCPClient();
  // HTTPGET();
  // HTTPPOST();
  UDPExample();
}
void DBProgram(){
  SelecRow();
}



