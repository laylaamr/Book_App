import 'package:books_app/bookProvider.dart';
import 'package:flutter/material.dart';

import 'bookDetails.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

List<BookDetails> books=[];
late BookProvider bookProvider;
void initState(){
  bookProvider =BookProvider();
  super.initState();
}
  @override
  Widget build(BuildContext context) {

   return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            title: Center(
              child: Text(
                "Available Books",
                style: TextStyle(
                    fontSize: 30, fontWeight: FontWeight.w500, color: Colors.white),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            onPressed: () {
              TextEditingController nameController = TextEditingController();
              TextEditingController authorController = TextEditingController();
              TextEditingController coverUrlController = TextEditingController();
              GlobalKey<FormState> formKey= GlobalKey<FormState>();

              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.all(20).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom+20),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: nameController,
                            validator:(value){
                           if(value == null || value.isEmpty){
                            return 'title can\'t be null';
                              }    return null;
                            },
                            decoration: InputDecoration(labelText: "Book name"),

                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: authorController,
                            decoration: InputDecoration(labelText: "Author name"),
                            validator:(value){
                              if(value == null || value.isEmpty){
                                return 'Author can\'t be null';
                              }    return null;
                            },
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: coverUrlController,
                            decoration: InputDecoration(labelText: "Cover Url"),
                            validator:(value){
                              if(value == null || value.isEmpty){
                                return 'cover can\'t be null';
                              }    return null;
                            },
                          ),
                          SizedBox(height: 20),


                              TextButton(onPressed: () async {
                    if (formKey.currentState!.validate()) {
                    BookDetails bookDetails = BookDetails(
                    id: null, // or auto-generate an ID if needed
                    name: nameController.text.trim(),
                    author: authorController.text.trim(),
                    cover: coverUrlController.text.trim(),
                    );
                    await bookProvider.insertIntoDatabase(bookDetails).then((value) {
                    Navigator.of(context).pop();
                    setState(() {

                    });
                    });
                    }
                    },
                                  style: TextButton.styleFrom(backgroundColor: Colors.blue,
                                  minimumSize: Size(double.infinity, 50)),
                                child: Text("Save",style: TextStyle(color: Colors.white,fontSize: 25),)
                              ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },

            child: const Icon(
              Icons.add,
              size: 30,
            ),
          ),
          body:FutureBuilder(
            future: bookProvider.getDtaFromDatabase() ,
            builder: (context,snapshot){
              if (snapshot.hasData ){
                if(snapshot.data.length == 0){
                  return Center(child:
                  Text("There is no data",style: TextStyle(fontSize: 25,color: Colors.red),));
                }
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context,index){
BookDetails bookDetails =BookDetails.fromMap(snapshot.data[index]);
                    return
                      Padding(
                        padding: const EdgeInsets.all( 16),
                        child: Row(
                          children: [
                            Container(
                              height: 130,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.blue,
                              ),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Image.network(bookDetails.cover),
                            ),
                            SizedBox(width:20),
                            Column(children: [
                              Text(bookDetails.name,style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,),
                              SizedBox(height: 5,),
                              Text("Author: ${bookDetails.author}",style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),   maxLines: 2,
                                overflow: TextOverflow.ellipsis,),
                            ],),
                            Spacer(),
                            IconButton( onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Delete Book',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                    content: Text('Are you sure you want to delete this book?',style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal)),
                                    actions: [
                                      TextButton(
                                        child: Text('No',style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black)),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Yes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.red),),
                                        onPressed: () async {
                                          await bookProvider.deleteFromDatabase(snapshot.data[index]['id']);
                                          setState(() {
                                            // Refresh the UI
                                          });
                                          Navigator.of(context).pop();
                                          setState(() {});
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );

                            }, icon: Icon(Icons.delete,size: 30,))
                          ],
                        ),

                      );
                  }
              );}
             else if(snapshot.hasError){
               return Center(child:
               Text("There is Error",style: TextStyle(fontSize: 25,color: Colors.red),));
              }
             else {
                return Center(child:
            CircularProgressIndicator());
              }
            },


          )

    ),
    );
  }
}

