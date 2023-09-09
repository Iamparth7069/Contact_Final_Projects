import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Model/notes.dart';
import '../Database/DBhelper.dart';

class notes extends StatefulWidget {
  const notes({super.key});

  @override
  State<notes> createState() => _notesState();
}

class _notesState extends State<notes> {
  User? user = FirebaseAuth.instance.currentUser;
  final _globelKey = GlobalKey<FormState>();
  final _tital = TextEditingController();
  final _desc = TextEditingController();
  DBhelper dBhelper = DBhelper();

  List<note> noteData = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () async {
          note notes =await openModelBottomSheet(context,null) as note;
          setState(() {
            noteData.add(notes);
          });
        },
        child: Icon(Icons.notes_rounded,color: Colors.white,),
      ),
      body:ListView.builder(
        itemCount: noteData.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () async {
              note category = noteData[index];
              note? cat= await openModelBottomSheet(context, category) as note;
              if(cat!= null){
                // update Task
                setState(() {
                  var index = noteData.indexWhere((element) => element.id == cat.id );
                  noteData[index] = cat;
                });
              }

            },
            title: Text('${noteData[index].title}'),
            subtitle: Text('${noteData[index].description}'),
            trailing: IconButton(
              onPressed: () {
                note category = noteData[index];
                deleteData(category,context);

                setState(() {
                  noteData.removeWhere((element) => element.id == category!.id);
                });
              },
              icon: Icon(Icons.delete),
            ),
          );
        },),
    );
  }

  Future openModelBottomSheet(BuildContext context,note? test) {
    if(test == null){
      print("This is Add");
      _tital.text = "";
      _desc.text = "";
      return showModalBottomSheet(
        isDismissible: false,
        enableDrag: false,
        context: context, builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _globelKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _tital,

                          validator: (value) {
                            if (value == null || value!.isEmpty) {
                              return "Enter the tital";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              hintText: "Title",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                        ),
                        SizedBox(
                          height: 13,
                        ),
                        TextFormField(
                          controller: _desc,
                          validator: (value) {
                            if (value == null || value!.isEmpty) {
                              return "Enter the Description";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(

                              hintText: "Description",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                        ),
                        Divider(),
                        MaterialButton(onPressed: () async{
                          String title =_tital.text.trim().toString();
                          String desc = _desc.text.trim().toString();
                          String date = DateTime.now().toString();
                          if(_globelKey.currentState!.validate()){
                            note notes = note(Uid: user!.uid, title: title, description: desc, date: date);
                            addcategory(notes,context);
                          }
                        },
                          minWidth: double.infinity,
                          color: Colors.blue,
                          padding: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: Text("Add Notes"),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },);
    }else{
      // update
      print("This is Update");
      _tital.text = test.title!.toString();
      _desc.text = test.description!.toString();
      return showModalBottomSheet(
        isDismissible: false,
        enableDrag: false,
        context: context, builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _globelKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _tital,

                          validator: (value) {
                            if (value == null || value!.isEmpty) {
                              return "Enter the Password";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                              hintText: "Title",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                        ),
                        SizedBox(
                          height: 13,
                        ),
                        TextFormField(
                          controller: _desc,
                          validator: (value) {
                            if (value == null || value!.isEmpty) {
                              return "Enter the Password";
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(

                              hintText: "Title",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                        ),
                        Divider(),
                        MaterialButton(onPressed: () async{
                          String title =_tital.text.trim().toString();
                          String desc = _desc.text.trim().toString();
                          String date = DateTime.now().toString();
                          if(_globelKey.currentState!.validate()){

                            note notes = note.withId(Uid: test!.Uid, title: title, description: desc, date: test.date,id: test.id);
                            updateTheData(notes,context);
                          }
                        },
                          minWidth: double.infinity,
                          color: Colors.blue,
                          padding: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          child: Text("Update Notes"),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },);
    }

  }

  Future<void> addcategory(note note, BuildContext context) async {
    var id  = await dBhelper.insert(note);
    print("Call");
    if (id != -1) {
      print("add Sucssses Fully ");
      print("Add Function Call");
      note.id = id;
      Navigator.pop(context, note);
    } else {
      print("getting Error while adding category");
    }
  }

  Future<void> loadData() async {
    var tempList =  await dBhelper.read();
    setState(() {
      noteData.addAll(tempList);
    });
  }

  Future<void> deleteData(note category, BuildContext context) async {
    var id =await dBhelper.delete(category.id);
  }

  Future<void> updateTheData(note notes, BuildContext context) async {
    var id = await dBhelper.update(notes);
    if (id != -1) {
      print("Category Updated Sucssses Fully ");
      print("Update Function Call");
      Navigator.pop(context, notes);
    } else {
      print("getting Error while adding category");
    }
  }
}