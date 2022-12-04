import 'package:flutter/material.dart';

void main() {
  runApp(new MaterialApp(
    home: MultiContactFormWidget(),
    debugShowCheckedModeBanner: false,
  ));
}

class MultiContactFormWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MultiContactFormWidgetState();
  }
}

class _MultiContactFormWidgetState extends State<MultiContactFormWidget> {
  List<ContactFormItemWidget> contactForms = List.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Multiple Contacts"),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          // color: Theme.of(context).primaryColor,
          onPressed: () {
            onSave();
          },
          child: Text("Save"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: Icon(Icons.add),
        onPressed: () {
          onAdd();
        },
      ),
      body: contactForms.isNotEmpty
          ? SingleChildScrollView(
            child: Container(
              child: ListView.builder(
                shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
                  itemCount: contactForms.length,
                  itemBuilder: (_, index) {
                    return contactForms[index];
                  }),
            ),
          )
          : Center(child: Text("Tap on + to Add Contact")),
    );
  }

  //Validate all forms and submit
  onSave() {
    bool allValid = true;

    //If any form validation function returns false means all forms are not valid
    contactForms.forEach((element){
      if(element._addressController.text.isEmpty || element._contactController.text.isEmpty ||element._nameController.text.isEmpty || element._emailController.text.isEmpty){
allValid=false;
      }
    });

    if (allValid) {
      for (int i = 0; i < contactForms.length; i++) {
        ContactFormItemWidget item = contactForms[i];
        debugPrint("Name: ${item.contactModel.name}");
        debugPrint("Number: ${item.contactModel.number}");
        debugPrint("Email: ${item.contactModel.email}");
      }
      //Submit Form Here

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("Form submited succeffully"),duration: Duration(seconds: 2),backgroundColor: Colors.green,),);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
    SingleChildScrollView(
      child: Container(
        height: 150,
        child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: contactForms.length,itemBuilder: (_,index){
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Container(
                child: Text("${contactForms[index]._emailController.text} \n ${contactForms[index]._nameController}"),
              ),
            ),
          );
        },),
      ),
    ),

        duration: Duration(seconds: 2),backgroundColor: Colors.green,),);

    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text("All Fields are required"),duration: Duration(seconds: 2),));
      debugPrint("Form is Not Valid");
    }
  }

  //Delete specific form
  onRemove(ContactModel contact) {
    print(contact.id);
    setState(() {
      contactForms.removeAt(contact.id);
    });
    // setState(() {
    //   setState(() {
    //     int index=contactForms.indexWhere((element) => element.contactModel.id==contact.id);
    //     if(contactForms != null){
    //       contactForms.removeAt(index);
    //     }
    //   });
    // });
  }

  //Add New Form
  onAdd() {
    setState(() {
      ContactModel _contactModel =
          ContactModel(name: "", email: "", number: "", address: "",id: contactForms.length);
      contactForms.add(ContactFormItemWidget(
        index: contactForms.length,
        contactModel: _contactModel,
        onRemove: () => onRemove(_contactModel),
      ));
    });
  }
}





class ContactModel {
  int id;
  String name;
  String number;
  String email;
  String? address;

  ContactModel(
      {required this.name,
      required this.number,
      required this.email,
      this.address,required this.id});
}

class ContactFormItemWidget extends StatefulWidget {
  ContactFormItemWidget(
      {Key? key,
      required this.contactModel,
      required this.onRemove,
      this.index})
      : super(key: key);

  final index;
  ContactModel contactModel;
  final Function onRemove;
  final state = _ContactFormItemWidgetState();

  @override
  State<StatefulWidget> createState() {
    return state;
  }

  TextEditingController _nameController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

}

class _ContactFormItemWidgetState extends State<ContactFormItemWidget> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: formKey,
          child: Container(
            padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Contact - ${widget.index}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.orange),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                            onPressed: () {
                              setState(() {
                                //Clear All forms Data
                                widget.contactModel.name = "";
                                widget.contactModel.number = "";
                                widget.contactModel.email = "";
                                widget._nameController.clear();
                                widget._contactController.clear();
                                widget._emailController.clear();
                              });
                            },
                            child: Text(
                              "Clear",
                              style: TextStyle(color: Colors.blue),
                            )),
                        TextButton(
                            onPressed: () => widget.onRemove(),
                            child: Text(
                              "Remove",
                              style: TextStyle(color: Colors.blue),
                            )),
                      ],
                    ),
                  ],
                ),
                TextFormField(
                  controller: widget._nameController,
                  // initialValue: widget.contactModel.name,
                  onChanged: (value) => widget.contactModel.name = value,
                  onSaved: (value) =>
                      widget.contactModel.name = value.toString(),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(),
                    hintText: "Enter Name",
                    labelText: "Name",
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: widget._contactController,
                  onChanged: (value) => widget.contactModel.number = value,
                  onSaved: (value) =>
                      widget.contactModel.name = value.toString(),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(),
                    hintText: "Enter Number",
                    labelText: "Number",
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: widget._emailController,
                  onChanged: (value) => widget.contactModel.email = value,
                  onSaved: (value) =>
                      widget.contactModel.email = value.toString(),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(),
                    hintText: "Enter Email",
                    labelText: "Email",
                  ),
                ),
                SizedBox(height: 8,),
                TextFormField(
                  onChanged: (value)=>widget.contactModel.address=value,
                  onSaved: (value)=>widget.contactModel.address.toString(),
                  controller: widget._addressController,
                  decoration: InputDecoration(
                    hintText: "Addrress",
                    labelText: "Address"
                  )

                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
