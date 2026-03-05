import 'package:flutter/material.dart';
import 'package:local_db_learning/Databases/Local%20Db/db_helper.dart';
import 'package:local_db_learning/Provider/Database_provider.dart';
import 'package:provider/provider.dart';

class Textpage extends StatefulWidget {

    final int? Sno;
    final String? title;
    final String? description;

  const Textpage({Key? key,this.Sno , this.title , this.description }) : super(key: key);



  @override
  State<Textpage> createState() => _TextpageState();

}

class _TextpageState extends State<Textpage> {



  @override
  void initState() {
    super.initState();

    title_controller.text=widget.title ?? "";
    desc_controller.text=widget.description ?? "";

  }
  @override
  void dispose() {
    title_controller.dispose();
    desc_controller.dispose();
    super.dispose();
  }

  var title_controller=TextEditingController();
  var desc_controller=TextEditingController();
  @override
  Widget build(BuildContext context) {

    bool isUpdate=widget.Sno !=null;

    return Scaffold(
      appBar: AppBar(
          title: Text(isUpdate? "Update Note" : "Add Note"),
          backgroundColor: Colors.blue
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

        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: title_controller,
                  style: TextStyle(fontSize: 20 , fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    label: Text("Title "),
                    enabledBorder:OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(width: 2 , color: Colors.white),
          
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(width: 2 , color: Colors.black87),
          
                    )
          
          
                  ),
                  maxLines: 2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: desc_controller,
                  style: TextStyle(fontSize: 16 , fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                      label: Text("Description"),
                      alignLabelWithHint: true,
                      enabledBorder:OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(width: 2 , color: Colors.white),
          
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(width: 2 , color: Colors.black87),
          
                      )
          
          
                  ),
                  maxLines: 20,
                ),
              ),

             if(isUpdate)
               ElevatedButton(onPressed: (){

                 var title_text=title_controller.text.trim();
                 var desc_text=desc_controller.text.trim();

                 if(title_text.isNotEmpty && desc_text.isNotEmpty){

                   var provider=context.read<Database_provider>();
                   provider.update(title: title_controller.text, Desc: desc_controller.text, SerialNo: widget.Sno!);

                   Navigator.pop(context);

                 }
                 else{
                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(content: Text("Please fill the Fields"))
                   );
                 }


                 

               },
                   style: ElevatedButton.styleFrom(
                     backgroundColor: Colors.orange
                   ),

                   child: Text("Update"))
            else
              ElevatedButton(onPressed: (){

                var title_text=title_controller.text.trim();
                var desc_text=desc_controller.text.trim();

                if(title_text.isNotEmpty && desc_text.isNotEmpty){

                  var provider=context.read<Database_provider>();
                  provider.add_Note(title: title_controller.text, Desc: desc_controller.text);

                  Navigator.pop(context);

                }
                else{
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please fill the Fields"))
                  );
                }






              },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    foregroundColor: Colors.white
                  ),
                  child: Text("Save"))

          
            ]
          ),
        ),

      ),


    );

  }
}


