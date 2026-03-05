import 'package:flutter/material.dart';
import 'package:local_db_learning/Databases/Local%20Db/db_helper.dart';
import 'package:local_db_learning/Provider/Database_provider.dart';
import 'package:local_db_learning/Provider/background_light_mode_provider.dart';
import 'package:local_db_learning/TextPage.dart';
import 'package:provider/provider.dart';
import 'package:local_db_learning/settings.dart';


void main(){

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context)=>Database_provider()),
        ChangeNotifierProvider(create: (context)=>background_light_mode_provider()),

      ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget{

  const MyApp({super.key});
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner : false,
      title: "Notes App",
      themeMode: context.watch<background_light_mode_provider>().isDarkMode ? ThemeMode.dark : ThemeMode.light,
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),



      ),
      home: const MyHomePage(title : "Notes App")


    );
  }
}
class MyHomePage extends StatefulWidget{
  final String title;

  const MyHomePage({super.key , required this.title});

  @override
  State<MyHomePage> createState() {

    return MyHomePageState();

  }


}

class MyHomePageState extends State<MyHomePage>{

  var search_controller=TextEditingController();


  @override
  void initState() {
    super.initState();

    Future.microtask(()=>
    context.read<Database_provider>().FetchAllNotes());

  }





  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text("Notes App"),
       backgroundColor: Colors.blue,
       actions: [
         IconButton(onPressed: (){
           Navigator.push(context, MaterialPageRoute(builder: (context)=>settings()));

         }, icon: Icon(Icons.settings , color: Colors.white,))
       ]
     ),

     body: Container(
       width: double.infinity,
       height: double.infinity,
       decoration: BoxDecoration(
         gradient: LinearGradient(
           begin: Alignment.centerLeft,
           end: Alignment.centerRight,
           colors: [
             Color(0xFFa1c4fd),
             Color(0xFFc2e9fb)


           ]
         )
       ),
       child: Column(
         children: [

           Padding(
             padding: const EdgeInsets.all(8.0),
             child: TextField(
               controller: search_controller,
               style: TextStyle(fontSize: 18 , color: Colors.black87),
               decoration: InputDecoration(
                 hintText: "Search",
                 suffixIcon: IconButton(onPressed: (){
                   search_controller.clear();
                   context.read<Database_provider>().filterNotes("");
                 }, icon: Icon(Icons.search_outlined , color: Colors.black87,)),
                 enabledBorder: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(10),
                   borderSide: const BorderSide(width: 2 , color: Colors.white),
                 ),
                 focusedBorder: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(10),
                   borderSide: const BorderSide(width: 2 , color: Colors.black87),
                 ),
                 filled: true,
                 fillColor: Colors.white.withOpacity(0.7),
               ),
               onChanged: (value){
                 context.read<Database_provider>().filterNotes(value);

               },


             ),
           ),


           Expanded(
             child: Consumer<Database_provider>(
               builder: (context, provider, child) {

                 if(provider.FilterNotes.isEmpty){
                   return const Center(
                     child: Text("No Notes yet"),

                   );
                 }

                 return ListView.builder(
                   itemCount: provider.FilterNotes.length,
                     itemBuilder: (context , index){

                     final note=provider.FilterNotes[index];

                     return ListTile(

                       onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Textpage(
                          Sno: note[db_helper.TABLE_COLUMN_SNO],
                          title: note[db_helper.TABLE_COLUMN_TITLE],
                            description: note[db_helper.TABLE_COLUMN_DESC],

                        )));


                       },
                       leading: CircleAvatar(
                           child: Text("${index+1}"),
                       ),
                       title: Text(note[db_helper.TABLE_COLUMN_TITLE]),
                       subtitle:Text(note[db_helper.TABLE_COLUMN_DESC]) ,
                       trailing: IconButton(onPressed: (){
                         showDialog(context: context,
                             builder:(BuildContext context){

                           return AlertDialog(
                             title: const Text("Delete Note"),
                             content: const Text("Are you sure you want to delete this note"),
                             actions: [
                               TextButton(onPressed: (){
                                 Navigator.pop(context);
                               }, child: Text("Cancel")),

                               TextButton(onPressed: (){
                                 provider.delete(SerialNo: note[db_helper.TABLE_COLUMN_SNO]);
                                 Navigator.pop(context);
                               }, child: Text("Delete")),
                             ],

                           );

                             });


                       }, icon: Icon(Icons.delete , color: Colors.red,)),


                     );

                     });

               },

             ),
           ),
         ],
       ),



     ),
     floatingActionButton: FloatingActionButton(onPressed: ()async{
       await Navigator.push(context, MaterialPageRoute(builder: (context)=>Textpage() ));




     } ,
     child: Icon(Icons.add)),


   );
  }

}