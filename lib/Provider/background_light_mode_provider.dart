
import 'package:flutter/material.dart';

class background_light_mode_provider extends ChangeNotifier{
   bool _isDarkMode=false;

   bool  get isDarkMode=> _isDarkMode;

   void toggle_theme({required bool value}){
     _isDarkMode=value;
     notifyListeners();

   }




}