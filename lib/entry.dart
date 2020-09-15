import 'package:blooddonar/landing.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Entry extends StatefulWidget{
  FirebaseUser _user;
  Map<String, dynamic> _userDetails;
  Entry(this._user,this._userDetails);
  @override
  State<StatefulWidget> createState() {
    return EntryState(_user,this._userDetails);
      }
      
    }
    
  class EntryState extends State<Entry>{

    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); 

    bool _validateName = false;
    bool _validateCity = false;
    bool _validatePhone = false;
    bool _validateBlood = false;
    String s="";

      FirebaseUser _user;
      Map<String, dynamic> _userDetails;
      EntryState(this._user,this._userDetails);

   var _name =  TextEditingController()  ;
   var _city =  TextEditingController()  ;
   var _phone =  TextEditingController()  ;
   String _blood ;
   String _value ;

   @override
  void initState() {
    super.initState();

        if(!(_userDetails == null)){
      _name.text = _userDetails['name'];
      _city.text = _userDetails['city'];
      _phone.text = _userDetails['phone'];
     _value = _userDetails['blood group'];
     _blood = _userDetails['blood group'];
    }else{
    _name.text = _user.displayName;
    }
  }


  @override
  Widget build(BuildContext context) {

    var column =
        Container(
          padding: EdgeInsets.only(left: 10,right: 10),
          child:ListView(
      children: <Widget>[

         TextFormField(
           cursorWidth: 2.0,
           showCursor: true,
           controller: _name,
           style: TextStyle(fontSize: 20),
           decoration: InputDecoration(hintText: "Name",
           errorText: _validateName ? "Enter your name": null,
           ),          
           ),

           Padding(padding: EdgeInsets.only(top: 15),),

          DropdownButton<String>(
            hint: Text("Select Blood Group"),
            value: _value,
            items: [
              DropdownMenuItem<String>(
                value: 'A+',
                child: Text("A+"),
                ),
                DropdownMenuItem<String>(
                value: 'A-',
                child: Text("A-"),
                ),
                DropdownMenuItem<String>(
                value: 'B+',
                child: Text("B+"),
                ),
                DropdownMenuItem<String>(
                value: 'B-',
                child: Text("B-"),
                ),
                DropdownMenuItem<String>(
                value: 'AB+',
                child: Text("AB+"),
                ),
                DropdownMenuItem<String>(
                value: 'AB-',
                child: Text("AB-"),
                ),
                DropdownMenuItem<String>(
                value: 'O+',
                child: Text("O+"),
                ),
                DropdownMenuItem<String>(
                value: 'O-',
                child: Text("O-"),
                ),
            ],
            onChanged: (newValue){
              setState(() {
               _value = newValue ;
               _blood = newValue;
              });
            },
            elevation: 2,
            style: TextStyle(color: Colors.red, fontSize: 20),
            isDense: true,
            iconSize: 40.0,
            isExpanded: true,
          ),
          
          Text(s,style: TextStyle(color: Colors.red[800],fontSize: 13),),

           Padding(padding: EdgeInsets.only(top: 15),),

           TextFormField(
           controller: _city,
            style: TextStyle(fontSize: 20),
           decoration: InputDecoration(hintText: "City",
           errorText: _validateCity ? "Enter city": null,),
           ),

            Padding(padding: EdgeInsets.only(top: 15),),

           TextFormField(
           controller: _phone,
            style: TextStyle(fontSize: 20),
           decoration: InputDecoration(hintText: "Phone no",
           errorText: _validatePhone ? "Enter valid phone no.": null
            ),
      ),

           Padding(padding: EdgeInsets.only(top: 20),),

           RaisedButton(onPressed: (){
             var _num = _phone.text;

             setState(() {
              _name.text.isEmpty ? _validateName = true : _validateName = false; 
              _city.text.isEmpty ? _validateCity = true : _validateCity = false;
              _phone.text.isEmpty ? _validatePhone = true : _validatePhone = false;
              if(_blood == null){
                setState(() {
                  print("This works");
                  _validateBlood = true;
                 s = "Select blood group"; 
                });
              }
              else{
                setState(() {
                 _validateBlood = false; 
                });
              }
              if(_num.length!=10){
                    _validatePhone = true;
              }
              else{
               
                try{
                  var temp = double.parse(_num);
                } on FormatException{  
                  _validatePhone = true;
                }
              }
             });
             
             if(!(_validateName || _validateCity || _validatePhone  || _validateBlood)){

            
                         var name = _name.text;
                         var city = _city.text;
                          var phone = _phone.text;

                  Map<String,String> _details ={
                    'name': name,
                    'city': city,
                    'phone': phone,
                    'uid': _user.uid,
                    'blood group': _blood
                  };

                  DocumentReference dr = Firestore.instance.collection('blooddonors').document(_user.uid);
                  if(_userDetails==null){
                    dr.setData(_details);
                  }else{
                   dr.updateData(_details);
                  }
     
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>MyLandingPage(_user)));
             }
           
        },
          child: Text("Save",style: TextStyle(fontSize: 20),),)
  ],
  )
  );

    var scaffold = Scaffold(
      key: _scaffoldKey,
    body:column,
    appBar: AppBar(
      title: Text("Add Details"),
      actions: <Widget>[

        PopupMenuButton<int>(
          itemBuilder: (context)=>[
            PopupMenuItem(
              value: 1,
              child: 
              FlatButton(
                child:Text("Delete",style: TextStyle(fontSize: 15,color: Colors.black),),
                onPressed: (){
                  DocumentReference dr = Firestore.instance.collection('blooddonors').document(_user.uid);
                  if(!(_userDetails==null)){
                    setState(() {
                       dr.delete();
                    });
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>MyLandingPage(_user)));
                  }
                  else{
                       _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("No Data Available"),));
                  }
                     
                },
                )
            ),
           PopupMenuDivider(height: 15.0,),
            PopupMenuItem(
            value: 2,
            child: FlatButton(
              child: Text("Clear",style: TextStyle(fontSize: 15,color: Colors.black),),
              onPressed: (){

                setState(() {
                   _name.text = "";
                _city.text = "";
                _phone.text = "";
                _value = null;
                _blood = null;
                  
                });
               

              },
            ),
            ),
            
          ],
        ),
        ],
    
    ),
    );
    
    return scaffold;
  }
}