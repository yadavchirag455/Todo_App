import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  MyHomePage();

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _textcontroller = TextEditingController();

  List<dynamic> todoList = [];
  bool isloading = false;

  final String url = 'https://664d94e0ede9a2b55653fe0a.mockapi.io/api/todoList';

  void fetchData() async {
    isloading = true;
    // final String url =
    //     'https://664d94e0ede9a2b55653fe0a.mockapi.io/api/todoList';

    final res = await http.get(Uri.parse(url));

    todoList = jsonDecode(res.body.toString());

    setState(() {});

    isloading = false;

    if (res.statusCode == 200) {
      print(todoList);
    } else {
      print('Failed to load data: ${res.statusCode}');
    }
  }

  void postData(String todo) async {
    isloading = true;

    // Define the data to be sent in the POST request
    final data = json.encode({'todo': todo});

    // Send the POST request
    final res = await http.post(
      Uri.parse(url), // Replace with your actual URL
      headers: {'Content-Type': 'application/json'},
      body: data, // Use the serialized JSON data as the body
    );

    log('Post API Called');

    isloading = false;

    // Check the response status code and print the appropriate message
    if (res.statusCode == 201) {
      // print('done---------------------------------------------------------');
    } else {
      // print('failed22222222222222222222222222222222222');
    }
  }

  void DeleteTodoData(id) async {
    isloading = true;
    final res = await http.delete(
      Uri.parse(
          'https://664d94e0ede9a2b55653fe0a.mockapi.io/api/todoList/$id'), // Replace with your actual URL
    );
    isloading = false;
    // Check the response status code and print the appropriate message
    if (res.statusCode == 200) {
      // print(
      //     'detele done done---------------------------------------------------------');

      log('Delete API Called');
      fetchData();
    } else {
      print('Delete failed');
    }
  }

  void updateTodoData(id, updtaedvalue) async {
    log(id);
    log(updtaedvalue);
    isloading = true;

    final data = json.encode({'todo': updtaedvalue});

    // log('3333333333333333333333' + updtaedvalue);

    final res = await http.put(
      Uri.parse('https://664d94e0ede9a2b55653fe0a.mockapi.io/api/todoList/$id'),
      body: data,
      headers: {
        'Content-Type': 'application/json',
      },
    );
    isloading = false;
    // Check the response status code and print the appropriate message
    if (res.statusCode == 200) {
      log('Updtae Api Called');

      fetchData();
    } else {
      print('failed');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          K_CustomDialogBox(
            Textcontroller: _textcontroller,
            Title: 'Enter Todo 🔥',
            CancelButtonName: 'No',
            SaveButtonName: 'Save',
            iconnn: Icons.add,
            ontapdone: () {
              Navigator.pop(context);
              todoList.add(
                  {'id': todoList.length + 1, 'todo': _textcontroller.text});
              print(_textcontroller.text);
              postData(_textcontroller.text);
              // print(_textcontroller.text + '======================');
              _textcontroller.clear();
              setState(() {});
            },
          )
        ],
      ),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('CRUD by Todo'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'List of Todo',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: todoList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    margin: EdgeInsets.symmetric(horizontal: 22, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.deepPurpleAccent.shade100,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          todoList[index]['Dis'] == null
                              ? '${todoList[index]['todo']}'
                              : '${todoList[index]['Dis']}',
                          style: TextStyle(fontSize: 20),
                        ),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  _textcontroller.text =
                                      todoList[index]['todo'];
                                  setState(() {});
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: Text('Edit Task'),
                                      content: TextFormField(
                                        decoration: InputDecoration(
                                            // labelText: todoList[index]['todo'],
                                            border: OutlineInputBorder(),
                                            hintText: 'Enter Todo Here'),
                                        controller: _textcontroller,
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('No'),
                                        ),
                                        SizedBox(
                                            width:
                                                95), // Adjust the width value as needed
                                        TextButton(
                                          onPressed: () {
                                            print(_textcontroller.text
                                                .toString());
                                            // updateTodoData(
                                            //     Textcontroller.text, index);
                                            updateTodoData(
                                                todoList[index]['id'],
                                                _textcontroller.text
                                                    .toString());

                                            _textcontroller.clear();

                                            // log('updtaed Api is called -----------------------------------------------------------------');

                                            Navigator.pop(context);
                                            fetchData();
                                          },
                                          child: Text('Done'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: Icon(Icons.edit)),
                            IconButton(
                                onPressed: () {
                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: Text('Delete'),
                                      content: Text(todoList[index]['todo']),

                                      // TextFormField(
                                      //   decoration: InputDecoration(
                                      //       labelText: todoList[index]['todo'],
                                      //       border: OutlineInputBorder(),
                                      //       hintText: 'Enter Todo Here'),
                                      //   controller: Textcontroller,
                                      // ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text('No'),
                                        ),
                                        SizedBox(
                                            width:
                                                95), // Adjust the width value as needed
                                        TextButton(
                                          onPressed: () {
                                            print(_textcontroller.text);
                                            // updateTodoData(
                                            //     Textcontroller.text, index);
                                            DeleteTodoData(
                                                todoList[index]['id']);
                                            //     Textcontroller.text.toString());
                                            //
                                            // Textcontroller.clear();
                                            // log('Delete Api is called -----------------------------------------------------------------');

                                            Navigator.pop(context);
                                          },
                                          child: Text('Done'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: Icon(Icons.delete)),
                            // K_CustomDialogBox(
                            //   initialText: todoList[index]['todo'],
                            //   Title: 'Are You Sure to Delete',
                            //   CancelButtonName: 'Cancel',
                            //   SaveButtonName: 'Delete',
                            //   iconnn: Icons.delete,
                            //   ontapdone: () {
                            //     DeleteTodoData(todoList[index]['id']);
                            //     Navigator.pop(context);
                            //     fetchData();
                            //   },
                            // )
                          ],
                        )
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class K_CustomDialogBox extends StatelessWidget {
  K_CustomDialogBox(
      {this.Textcontroller,
      this.Title,
      this.CancelButtonName,
      this.SaveButtonName,
      this.iconnn,
      this.ontapdone,
      this.initialText});

  final String? initialText;
  final TextEditingController? Textcontroller;
  final String? Title;
  final String? CancelButtonName;
  final String? SaveButtonName;
  final IconData? iconnn;
  final VoidCallback? ontapdone;
  MyHomePage myHomePage = MyHomePage();

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text(Title!),
                content: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Todo Here'),
                  controller: Textcontroller,
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(CancelButtonName!),
                  ),
                  SizedBox(width: 95), // Adjust the width value as needed
                  TextButton(
                    onPressed: ontapdone,
                    child: Text(SaveButtonName!),
                  ),
                ],
              ),
            ),
        child: Container(
          margin: EdgeInsets.all(2),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.deepPurpleAccent.shade100),
          child: Row(
            children: [Icon(iconnn)],
          ),
        ));
  }
}
