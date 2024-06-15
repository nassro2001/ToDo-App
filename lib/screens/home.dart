import 'dart:convert';
import 'dart:ui';

import 'package:assignment1/screens/config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_slidable/flutter_slidable.dart';

class HomeScreen extends StatefulWidget {
  final token;
  const HomeScreen({super.key, required this.token});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String userId;
  TextEditingController _todoTitle = TextEditingController();
  TextEditingController _todoDesc = TextEditingController();
  List? items;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    userId = jwtDecodedToken['id'];

    getTodoList(userId);
  }

  void addTodo() async {
    if (_todoTitle.text.isNotEmpty && _todoDesc.text.isNotEmpty) {
      try {
        var reqBody = {
          "userId": userId,
          "title": _todoTitle.text,
          "description": _todoDesc.text
        };

        var resp = await http.post(Uri.parse(addTasks),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(reqBody));

        var jsonResp = jsonDecode(resp.body);

        if (jsonResp['status'] == 200) {
          _todoTitle.clear();
          _todoDesc.clear();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Task added successfully")));
          Navigator.pop(context);
          getTodoList(userId);
        } else {
          print("something went wrong");
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error while adding data in todo list")));
      }
    }
  }

  void getTodoList(userId) async {
    try {
      var reqBody = {"userId": userId};

      var resp = await http.post(Uri.parse(getTodo),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reqBody));

      var jsonResp = jsonDecode(resp.body);

      items = jsonResp['success'];
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error while getting data in todo list")));
      print(e);
    }
  }

  void deleteItem(id) async {
    try {
      var reqBody = {"id": id};

      var resp = await http.post(Uri.parse(deleteTodo),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reqBody));

      var jsonResp = jsonDecode(resp.body);

      jsonResp['status'] == 200
          ? ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Todo deleted with success")))
          : print("erreur");
      getTodoList(userId);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error while deleting data in todo list")));
      print(e);
    }
  }

  void updateItem(id) async {
    try {
      var reqBody = {"title": _todoTitle.text, "description": _todoDesc.text};

      var resp = await http.put(Uri.parse(updateTodo + id),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reqBody));

      var jsonResp = jsonDecode(resp.body);

      if (jsonResp['status'] == 200) {
        _todoTitle.clear();
        _todoDesc.clear();
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Task updated successfully")));
        Navigator.pop(context);
        getTodoList(userId);
      } else {
        print("something went wrong");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error while deleting data in todo list")));
      print(e);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10.0),
                Text(
                  'You can see here your different tasks',
                  style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 8.0),
                Text(
                  '${items?.length}  tasks',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
          ),
          Expanded(
              child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: items == null
                  ? null
                  : ListView.builder(
                      itemCount: items!.length,
                      itemBuilder: (context, int index) {
                        return Slidable(
                            key: const ValueKey(0),
                            endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                dismissible:
                                    DismissiblePane(onDismissed: () {}),
                                children: [
                                  SlidableAction(
                                    backgroundColor: Color(0xFFFE4A49),
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                    onPressed: (BuildContext context) {
                                      deleteItem('${items![index]['_id']}');
                                    },
                                  ),
                                  SlidableAction(
                                    onPressed: (BuildContext context) {
                                      // deleteItem('${items![index]['_id']}');
                                      displayUpdateDialog(
                                          context,
                                          '${items![index]['title']}',
                                          '${items![index]['description']}',
                                          '${items![index]['_id']}');
                                    },
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    label: 'Update',
                                    icon: Icons.update,
                                  )
                                ]),
                            child: Card(
                              borderOnForeground: false,
                              child: ListTile(
                                leading: Icon(Icons.task),
                                title: Text('${items![index]["title"]}'),
                                subtitle:
                                    Text('${items![index]["description"]}'),
                                trailing: Icon(Icons.arrow_back),
                              ),
                            ));
                      }),
            ),
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => displayTextInputDialog(context),
        child: Icon(Icons.add),
        tooltip: "Add To-Do list",
      ),
    );
  }

  Future<void> displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Add To-Do"),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              Padding(padding: EdgeInsets.all(16.0)),
              TextField(
                controller: _todoTitle,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                  controller: _todoDesc,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Description",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ))),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    addTodo();
                  },
                  child: Text("Add"))
            ]),
          );
        });
  }

  Future<void> displayUpdateDialog(
      BuildContext context, title, description, id) async {
    int _maxlines = 1;
    _todoTitle = TextEditingController(text: title);
    _todoDesc = TextEditingController(text: description);

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Update To-Do"),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              Padding(padding: EdgeInsets.all(16.0)),
              TextField(
                controller: _todoTitle,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                  controller: _todoDesc,
                  keyboardType: TextInputType.text,
                  maxLines: 5,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Description",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ))),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    updateItem(id);
                  },
                  child: Text("Update"))
            ]),
          );
        });
  }
}
