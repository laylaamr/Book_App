
import 'package:books_app/bookDetails.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BookProvider{
  Database? database;
 late String tableName='books';
 Future onCreateDatabase(Database database, int version) async{
await database.execute('CREATE TABLE $tableName(id INTEGER PRIMARY KEY, title TEXT, author TEXT, cover TEXT)');
  }
Future <Database?> initDatabase() async{
  if( database != null){
    return database;
  }
  String path= join(await getDatabasesPath(),'books.db');
  database = await openDatabase(path,version: 1,onCreate:onCreateDatabase );
  return database;
}
  
   Future getDtaFromDatabase()async{
   Database? database = await initDatabase();
 return await database!.query(tableName);
 }
 Future insertIntoDatabase(BookDetails bookDetails) async{
   Database? database = await initDatabase();
   return await database!.insert(tableName, bookDetails.toMap());
 }
  Future<int> deleteFromDatabase(int id) async {
    Database? database = await initDatabase();
    return await database!.delete(tableName,  where: 'id= ?', whereArgs: [id]);
  }

  
}