import 'package:image_picker/image_picker.dart';

class ContactModel {
  String? name;
  String? number;
  String? email;
  XFile? xFile;
  ContactModel({this.name, this.number, this.email,this.xFile});
}
