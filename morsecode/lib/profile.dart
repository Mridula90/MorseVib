import 'package:flutter/material.dart';
import 'package:morsecode/main.dart';

class Profile extends StatefulWidget {
  List finaList;
  Profile(this.finaList);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(4292598747),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 30,
            ),
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                maxRadius: 60,
                backgroundImage: NetworkImage(
                    "https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZmlsZXxlbnwwfHwwfHw%3D&w=1000&q=80"),
              ),
            ),
            SizedBox(height: 29),
            ListView.builder(
                shrinkWrap: true,
                itemCount: contacts.length,
                itemBuilder: (ctx, i) {
                  print(finaList);
                  return ListTile(
                    title: Text(contacts[i]["name"]),
                    trailing: Icon(Icons.edit, color: Colors.white),
                    onTap: () {
                      TextEditingController _name =
                          TextEditingController(text: contacts[i]["name"]);
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Edit name'),
                              content: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    _name.text = value;
                                  });
                                },
                                controller: _name,
                                decoration: InputDecoration(hintText: "Name"),
                              ),
                              actions: [
                                RaisedButton(
                                  child: Text("Edit"),
                                  onPressed: () async {
                                    setState(() {
                                      contacts[i]["name"] = _name.text;
                                    });
                                  },
                                )
                              ],
                            );
                          });
                    },
                  );
                }),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => SpeechScreen(contacts)));
              },
              child: Container(
                width: MediaQuery.of(context).size.width - 100,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blue),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Go Back",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
