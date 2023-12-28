import 'dart:io';
import 'package:contact_diary/provider/contact_provider.dart';
import 'package:contact_diary/view/contact_save.dart';
import 'package:contact_diary/view/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocalAuthentication auth = LocalAuthentication();
  int count = 0;

  @override
  void initState() {
    // TODO: implement initState
    lock();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Diary"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return Settings();
                  },
                ));
              },
              icon: Icon(Icons.settings)),
        ],
      ),
      body: Consumer<ContactProvider>(
        builder: (BuildContext context, contactprovider, child) {
          return ListView.builder(
            itemCount: contactprovider.contactList.length,
            itemBuilder: (context, index) {
              var contactModel = contactprovider.contactList[index];
              return Stack(
                children: [
                  ListTile(
                    title: Text(contactModel.name ?? ""),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      maxRadius: 40,
                      backgroundImage: contactModel.xFile != null
                          ? FileImage(
                              File(contactModel.xFile!.path ?? ""),
                            )
                          : null,
                    ),
                    minVerticalPadding: 20,
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(contactModel.number ?? ""),
                        Text(contactModel.email ?? ""),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            Provider.of<ContactProvider>(context, listen: false)
                                .remove(index);
                          },
                          icon: Icon(Icons.delete),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return ContactSave(index: index);
                              },
                            ));
                          },
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            var uri = Uri.parse(
                                "tel:+91${contactModel.number ?? ""}");

                            launchUrl(uri);
                          },
                          icon: Icon(Icons.call),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContactSave(),
            ),
          );
        },
      ),
    );
  }

  void lock() async {
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    print(canAuthenticate);

    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
    print(availableBiometrics);

    try {
      print('auth.authenticate');
      final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to show account balance',
      );
      print(didAuthenticate);
      if (didAuthenticate == false) {
        count++;
        if (count >= 3) {
          exit(0);
        } else {
          lock();
        }
      }
    } on PlatformException catch (e) {
      print("error ==> $e");
    }
  }
}
