import 'package:basic_crud/pages/student.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:basic_crud/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController studentIDController = new TextEditingController();
  TextEditingController courseController = new TextEditingController();

Stream? StudentsStream;

getontheload()async{
  StudentsStream= await DatabaseMethods().getStudentsDetails();
  setState(() {
  });

}

@override
void initState(){
  getontheload();
  super.initState();
}

Widget allStudentsDetails() {
  return StreamBuilder(
    stream: StudentsStream,
    builder: (context, AsyncSnapshot snapshot){
    return snapshot.hasData
    ?ListView.builder(
      itemCount: snapshot.data.docs.length,
      itemBuilder:(context, index){
        DocumentSnapshot ds=snapshot.data.docs[index];
        return Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadiusDirectional.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
              Row(
                
                children: [
                  Text("Name :"+ ds["Name"], 
                      style: TextStyle(
                        color:Colors.blue, 
                        fontSize: 20.0, 
                        fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: (){
                      nameController.text=ds["Name"];
                      studentIDController.text=ds["StudentID"];
                      courseController.text=ds["Course"];
                      EditStudentsDetails(ds["Id"]);
                    },                
                    child: Icon(Icons.edit, color: Colors.blue)),
                    SizedBox(width: 5.0,),
                    GestureDetector(
                      onTap: ()async{
                        await DatabaseMethods().deleteStudentsDetails(ds["Id"]);
                      },
                      child: Icon(Icons.delete, color: Colors.red,)), 
                ],
              ),
              Text(
                "StudentID :"+ ds["StudentID"], 
                style: TextStyle(
                  color:Colors.yellow, 
                  fontSize: 20.0, 
                  fontWeight: FontWeight.bold),
                ),
              Text(
                "Course :"+ ds["Course"], 
                style: TextStyle(
                  color:Colors.green, 
                  fontSize: 20.0, 
                  fontWeight: FontWeight.bold),
                ),
                      ],
                    )    ),
            ),
        );
      })
    : Container();      
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Student()));
          },
          child: Icon(Icons.add)),
      appBar: AppBar(
        // This parenthesis should be next to AppBar without a line break
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Home",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold), // TextStyle
            ),
            Text(
              "Page",
              style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold), // TextStyle
            ) // Text// Text
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
         child: Column(
          children: [
            Expanded(child: allStudentsDetails()),
         ],
        ), // Column
      ), // Container
    ); // Scaffold
  }

  Future EditStudentsDetails(String id) => showDialog(context: context, builder:(context)=>AlertDialog(
    content: Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
        Row(children: [
          GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.cancel)),
            SizedBox(width: 60.0,),
            Text(
              "Edit",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold), // TextStyle
            ),
            Text(
              "Details",
              style: TextStyle(
                  color: Colors.yellow,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold), // TextStyle
            ) // Text// Text
        ],),
        SizedBox(height: 20.0,),
          Text(
              "Name",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.only(left: 10.0),
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10)),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              "StudentID",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.only(left: 10.0),
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10)),
              child: TextField(
                controller: studentIDController,
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              "Course",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.only(left: 10.0),
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10)),
              child: TextField(
                controller: courseController,
                decoration: InputDecoration(border: InputBorder.none),
              ),
            ),
            SizedBox(height: 30.0,),
            Center (child: ElevatedButton(onPressed: ()async{
              Map<String, dynamic> updateInfo={
                "Name": nameController.text,
                "StudentID": studentIDController.text,
                "Id": id,
                "Course": courseController.text
              };
              await DatabaseMethods().updateStudentsDetails(id, updateInfo).then((value){
                Navigator.pop(context);
              });
            }, child: Text("Update")))
      ],),
    ),
  ));
}
