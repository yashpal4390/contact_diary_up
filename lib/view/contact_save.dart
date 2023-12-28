import 'dart:io';

import 'package:contact_diary/modal/contact_modal.dart';
import 'package:contact_diary/provider/contact_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ContactSave extends StatefulWidget {
  final int? index;
  const ContactSave({super.key, this.index});
  @override
  State<ContactSave> createState() => _ContactSaveState();
}

class _ContactSaveState extends State<ContactSave> {
  ImagePicker picker = ImagePicker();
  XFile? xFile;
  GlobalKey<FormState> fk = GlobalKey<FormState>();
  String title = "Add Contact";

  @override
  void initState() {
    super.initState();

    var cp = Provider.of<ContactProvider>(context,listen: false);

    if(widget.index!=null){
      var cp=Provider.of<ContactProvider>(context,listen: false);
      var contactmodel=cp.contactList[widget.index!];
      cp.nameController.text = contactmodel.name ?? "";
      cp.contactController.text = contactmodel.number ?? "";
      cp.emailController.text = contactmodel.email ?? "";
      cp.xFile = contactmodel.xFile;
      title="Edit Contact";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          height: MediaQuery.sizeOf(context).height * 0.7,
          width: MediaQuery.sizeOf(context).width * 0.9,
          padding: EdgeInsets.all(8),
          child: Form(
            key: fk,
            child: Consumer<ContactProvider>(
              builder: (BuildContext context, contactprovider, child) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.blue,
                            maxRadius: 80,
                            backgroundImage: contactprovider.xFile != null
                                ? FileImage(
                                    File(contactprovider.xFile?.path ?? ""),
                                  )
                                : null,
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: IconButton(
                                onPressed: () {
                                  contactprovider.stepperCamera();
                                },
                                icon: Icon(Icons.camera_alt)),
                          ),
                          Positioned(
                            left: 0,
                            bottom: 0,
                            child: IconButton(
                                onPressed: () {
                                  contactprovider.stepperGallery();
                                },
                                icon: Icon(Icons.photo)),
                          ),
                        ],
                      ),
                      Stepper(
                        currentStep: contactprovider.cIndex,
                        onStepContinue: () {
                          if(contactprovider.cIndex == 1){
                            contactprovider.isEdit1 = true;
                          }
                          if(contactprovider.cIndex == 2){
                            contactprovider.isEdit2 = true;
                          }
                          if(contactprovider.cIndex == 3){
                            contactprovider.isEdit3 = true;
                          }
                          contactprovider.stepperContinue();
                        },
                        onStepCancel: () {
                          contactprovider.stepperCancel();
                        },
                        onStepTapped: (value) {
                          contactprovider.cIndex = value;
                          contactprovider.stepperTapped();
                        },
                        controlsBuilder: (context, details) {
                          return Row(
                            children: [
                              if (details.currentStep != 2)
                                ElevatedButton(
                                    onPressed: details.onStepContinue,
                                    child: Text("Continue")),
                              SizedBox(
                                width: 10,
                              ),
                              if (details.currentStep != 0)
                                OutlinedButton(
                                    onPressed: details.onStepCancel,
                                    child: Text("Back")),
                            ],
                          );
                        },
                        steps: [
                          Step(
                            title: Text("Step 1"),
                            content: TextFormField(
                              controller: contactprovider.nameController,
                              decoration: InputDecoration(hintText: "Name"),
                              onChanged: (value) {},
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return "Enter name";
                                }
                                return null;
                              },
                            ),
                            label: Text("S1"),
                            isActive: contactprovider.cIndex >= 0,
                            state: (contactprovider.nameController.text.isEmpty &&
                                    contactprovider.isEdit1 &&
                                    contactprovider.cIndex != 0)
                                ? StepState.error
                                : StepState.editing,
                          ),
                          Step(
                            title: Text("Step 2"),
                            content: TextFormField(
                              controller: contactprovider.contactController,
                              decoration: InputDecoration(hintText: "Number"),
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return "Enter Number";
                                }
                                return null;
                              },
                            ),
                            label: Text("S2"),
                            state:
                                (contactprovider.contactController.text.isEmpty &&
                                        contactprovider.isEdit2 &&
                                        contactprovider.cIndex != 1)
                                    ? StepState.error
                                    : StepState.editing,
                            isActive: contactprovider.cIndex >= 1,
                          ),
                          Step(
                            title: Text("Step 3"),
                            content: TextFormField(
                              controller: contactprovider.emailController,
                              decoration: InputDecoration(hintText: "Email"),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return "Enter Email";
                                } else if (!isEmail(value ?? "")) {
                                  return "Enter valid Email";
                                }
                                return null;
                              },
                            ),
                            label: Text("S2"),
                            state:
                                (contactprovider.emailController.text.isEmpty &&
                                        contactprovider.isEdit3 &&
                                        contactprovider.cIndex != 2)
                                    ? StepState.error
                                    : StepState.editing,
                            isActive: contactprovider.cIndex >= 2,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var cp = Provider.of<ContactProvider>(context,listen: false);

          ContactModel cm = ContactModel(
            email: cp.emailController.text,
            name: cp.nameController.text,
            number: cp.contactController.text,
            xFile: cp.xFile
          );
          if (widget.index != null) {
            Provider.of<ContactProvider>(context,listen: false)
                .editContact(widget.index ?? 0, cm);
          } else {
            Provider.of<ContactProvider>(context, listen: false).addcontact(cm);
          }
          Provider.of<ContactProvider>(context,listen: false).reset();
          Navigator.pop(context);
        },
        child: Icon(widget.index != null ? Icons.edit : Icons.add),
      ),
    );
  }

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(p);

    return regExp.hasMatch(em);
  }
}
