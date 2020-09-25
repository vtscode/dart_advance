import 'dart:io';
import 'dart:async';
import 'package:sqljocky5/connection/connection.dart';
import 'package:sqljocky5/constants.dart';
import 'package:sqljocky5/sqljocky.dart';

/*
* Why use a database ? its a structured storage that can be searched
* and manipulated even across a network
* */
void SelecRow() async{
  var s = ConnectionSettings(
    host: 'localhost',
    port: 3306,
    user: 'root',
    password: null,
    db: 'dart_school',
  );
  print("Opening connection ...");
  var conn = await MySqlConnection.connect(s);
  print("Opened connection!");

  // await readall(conn);
  // await findOne(conn,'riventus');
  // await insert(conn, 'bob','science');

  /*
    transaction =>
    ensure all the queries are executed without error and allows you to undo your
    changes
  */
  Transaction trans = await conn.begin();
  try{
    int id = await insert(conn, 'riventus', 'dart');
    //add with new data and delete unnecessary data
    int person = await findOne(conn, 'zazzy');
    await delete(conn,person);

    await trans.commit();
    print('done');
  }
  catch(err){
    print(err.toString());
    await trans.rollback();
  }
  finally{
    await conn.close();
    exit(0);
  }

  await conn.close();
}
Future<void> readall(MySqlConnection conn) async {
  Results result = await (await conn
      .execute('select * from teachers'))
      .deStream();
  await result.forEach((row) {
    print('Name : ${row[0]}, Topic : ${row[1]}'); // name or index
  });
}

Future<int> findOne(var conn, String name)async{
  // perpare on method sql its format the query for use
  var query = await conn.prepare('select * from teachers where Name=?');
  var results = await query.execute([name]);
  Row row = await results.first;
  print(row[0]);
  return row[0];
}
Future<int> insert(var conn, String name, String topic)async{
  var query = await conn.prepare('insert into teachers (name,topic) values (?,?)');
  var results = await query.execute([name,topic]);
  print('New user id = ${results.insertId}');
  return results.insertId;
}
Future delete(var conn, int value)async{
  var query = await conn.prepare('delete from teachers where idteachers=?');
  await query.execute([value]);
  print('done delete');
}