import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

/*
* While they both transfer data at the same speeds,
* TCP has a three way handshake during the connection
* that makes it slightly slower but more stable.
* It build a connection
* */
void SocketTCPServer() async{
  var serverSocket = await ServerSocket.bind('127.0.0.1', 3000);
  print('Listening');

  await for(var socket in serverSocket){
    socket.listen((List values) {
        print('${socket.remoteAddress}:${socket.remotePort} = ${utf8.decode(values)}');
    });
  }
}

void SocketTCPClient() async{
  var socket = await Socket.connect('127.0.0.1',3000);
  print('Connected');
  socket.write('Halo dunia');
  print('Sent, closing');
  await socket.close();
  print('Closed');
  exit(0);
}

void HTTPGET() async{
  var url = 'https://rhivent.github.io/';
  var response = await http.get(url);
  print('Response status ${response.statusCode}');
  print('Response body ${response.body}');
}

void HTTPPOST() async{
  var url = 'http://httpbin.org/post';
  var response = await http.post(url,body: 'name=Riventus&hobi:baca');
  print('Response status ${response.statusCode}');
  print('Response body ${response.body}');
}

void UDPExample(){
  /*
  * UDP doesn't require third party, there is no actual connection between
  * the sockets it just sends the data out and hopes for the best
  * UDP has no connection because it is meant for fast
  * but unverified data transfer
  * */
  var data = 'Halo dunia';
  List<int> dataToSend = utf8.encode(data);
  int port = 3000;
  
  //Server 
  RawDatagramSocket.bind(InternetAddress.loopbackIPv4, port).then((RawDatagramSocket udpsocket){
    udpsocket.listen((RawSocketEvent event) {
      if(event == RawSocketEvent.read){
        Datagram dg = udpsocket.receive();
        print(utf8.decode(dg.data));
      }
    });
    
  //  client
    udpsocket.send(dataToSend, InternetAddress.loopbackIPv4, port);
    print('Sent !');
  });
}