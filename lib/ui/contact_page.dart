import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app_agenda_contatos/helpers/contact_helper.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;
  ContactPage({this.contact});
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  final _nameController=TextEditingController();
  final _emailController=TextEditingController();
  final _phoneController=TextEditingController();
  final _nameFocus=FocusNode();

  bool _userEdited=false;
  Contact _editedContact;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.contact==null){
      _editedContact=Contact();
    }else{
      _editedContact=Contact.fromMap(widget.contact.toMap());
      _nameController.text=_editedContact.name;
      _emailController.text=_editedContact.email;
      _phoneController.text=_editedContact.phone;

    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_editedContact.name ?? "Novo Contato")
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          if(_editedContact.name.isNotEmpty && _editedContact.name!=null){
            Navigator.pop(context,_editedContact);
          }else{
            FocusScope.of(context).requestFocus(_nameFocus);
          }
        },
        child: Icon(Icons.save),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              GestureDetector(
                child:
                Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image:DecorationImage(
                        image: _editedContact.img != null ? FileImage(File(_editedContact.img)) : AssetImage("images/person.png")
                    ),
                  ),
                ),
               onTap: () {
                 ImagePicker.pickImage(source: ImageSource.camera).then((file) {
                   if (file == null) return;
                   setState(() {
                     _editedContact.img = file.path;
                   });
                 },);
               },
              ),
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: InputDecoration(labelText: "Nome"),
                onChanged: (text){
                  _userEdited=true;
                  setState(() {
                    _editedContact.name=text;
                  });
                },),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: "Email"),
                onChanged: (text){
                  _userEdited=true;
                  _editedContact.email=text;
                },
                keyboardType: TextInputType.emailAddress,),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Phone"),
                onChanged: (text){
                  _userEdited=true;
                  _editedContact.phone=text;

                },keyboardType: TextInputType.phone,),
            ],
          )
      ),
    ),
    onWillPop: _requestPop,);
  }

  Future<bool> _requestPop(){
    if(_userEdited){
      showDialog(context: context,
      builder:(context){
        return AlertDialog(title: Text("Descartar Alterações?"),
          content: Text("Se sair as alterações não serão salvas."),
          actions: [
            FlatButton(onPressed: (){Navigator.pop(context);}, child: Text("Cancelar")),
            FlatButton(onPressed: (){Navigator.pop(context);Navigator.pop(context);}, child: Text("Sim"))
          ],);
      });
      return Future.value(false);
    }else{
      return Future.value(true);
    }
  }
}

