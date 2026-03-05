
import 'package:flutter/cupertino.dart';
import 'package:local_db_learning/Databases/Local%20Db/db_helper.dart';


class Database_provider extends ChangeNotifier{

  List<Map<String , dynamic>> AllNotes=[];
  List<Map<String , dynamic>>FilterNotes=[];
  db_helper db_Ref= db_helper.get_Instance;


  Future<void> FetchAllNotes()async{
    AllNotes= await db_Ref.get_all_notes();
    FilterNotes=List.from(AllNotes);

    notifyListeners();
  }

  void filterNotes(String query){
    if(query.isEmpty){
      FilterNotes=List.from(AllNotes);

    }
    else{
      FilterNotes=AllNotes.where((note){
        final title=note[db_helper.TABLE_COLUMN_TITLE].toString().toLowerCase();
        final desc = note[db_helper.TABLE_COLUMN_DESC].toString().toLowerCase();
        final searchQuery = query.toLowerCase();
        return title.contains(searchQuery) || desc.contains(searchQuery);

      }).toList();


    }
    notifyListeners();

  }

  Future<void> add_Note({required String title , required String Desc})async {

    await db_Ref.Insert_Note(mTitle: title, mDesc: Desc);
    await FetchAllNotes();
    notifyListeners();


  }

  Future<void> delete({required int SerialNo})async{

    await db_Ref.delete(Sno: SerialNo);
    await FetchAllNotes();
    notifyListeners();

  }

  Future<void> update({required String title , required String Desc , required int SerialNo})async{
    await db_Ref.update(mtitle: title, mDesc: Desc, Sno: SerialNo);
    await FetchAllNotes();
    notifyListeners();

}




}





