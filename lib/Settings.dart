import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_db_learning/Provider/background_light_mode_provider.dart';
import 'package:provider/provider.dart';

class settings extends StatefulWidget{
  @override
  State<settings> createState() => _settingsState();
}

class _settingsState extends State<settings> {

  var isDarkMode=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        backgroundColor: Colors.blue,
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
        child: Consumer<background_light_mode_provider>(
            builder:(ctx , provider , __){
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SwitchListTile(value: provider.isDarkMode, onChanged: (value){



                  provider.toggle_theme(value: value);

                },
                title: Text("Dark Mode" , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 18),),
                subtitle: Text("By toggling here App Theme Mode Changes"),),
              );

            } )
      ),
    );
  }
}