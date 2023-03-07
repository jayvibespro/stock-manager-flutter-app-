import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stocksmanager/models/user_model.dart';

class EditProfilePage extends StatefulWidget {
  UserModel? userModel;

  @override
  _EditProfilePageState createState() => _EditProfilePageState();

  EditProfilePage({super.key, this.userModel});
}

class _EditProfilePageState extends State<EditProfilePage> {
  var userFromFirebase = FirebaseFirestore.instance.collection('users');

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  UploadTask? task;
  File? image;
  String avatarUrl = '';

  Future pickImage(ImageSource source) async {
    try {
      var image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }

    if (image == null) return;

    final imageName = image!.path;

    final destination = 'images/$imageName';

    var snapshot = await FirebaseStorage.instance
        .ref()
        .child(destination)
        .putFile(image!)
        .whenComplete(() => null);
    var downloadUrl = await snapshot.ref.getDownloadURL();
    setState(() {
      avatarUrl = downloadUrl;
    });
  }

  Future uploadImage() async {
    if (image == null) return;

    final imageName = image!.path;

    final destination = 'images/$imageName';

    var snapshot = await FirebaseStorage.instance
        .ref()
        .child(destination)
        .putFile(image!)
        .whenComplete(() => null);
    var downloadUrl = await snapshot.ref.getDownloadURL();
    setState(() {
      avatarUrl = downloadUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          GestureDetector(
            child: const Icon(Icons.info),
            onTap: () {
//              Get.offAll(() => LoginPage());
            },
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CircleAvatar(
                    radius: 100,
                    child: ClipOval(
                      child: image != null
                          ? Image.file(
                              image!,
                              fit: BoxFit.cover,
                              width: 200.0,
                              height: 200.0,
                            )
                          : Image.network(
                              widget.userModel!.avatarUrl,
                              fit: BoxFit.cover,
                              width: 200.0,
                              height: 200.0,
                            ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.edit),
                        const SizedBox(width: 20),
                        Text(
                          'Edit photo',
                          style: TextStyle(
                              color: Colors.teal.shade900,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  setState(() {
                    setState(() {
                      emailController.text = widget.userModel!.email;
                      nameController.text = widget.userModel!.name;
                      phoneController.text = widget.userModel!.phoneNumber;
                      genderController.text = widget.userModel!.gender;
                      locationController.text = widget.userModel!.location;
                    });

                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) {
                          return Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25.0),
                                topRight: Radius.circular(25.0),
                              ),
                            ),
                            child: Wrap(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Text(
                                    'Choose photo',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: const Divider(
                                    color: Colors.black54,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 5.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        pickImage(ImageSource.camera);
                                      },
                                      child: Row(
                                        children: const [
                                          Icon(
                                            Icons.photo_camera,
                                            color: Colors.black54,
                                          ),
                                          SizedBox(
                                            width: 40,
                                          ),
                                          Text(
                                            'Open Camera',
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      pickImage(ImageSource.gallery);
                                    },
                                    child: Row(
                                      children: const [
                                        Icon(
                                          Icons.collections,
                                          color: Colors.black54,
                                        ),
                                        SizedBox(
                                          width: 40,
                                        ),
                                        Text(
                                          'Select from your gallery',
                                          style:
                                              TextStyle(color: Colors.black54),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 100,
                                ),
                              ],
                            ),
                          );
                        });
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                child: Container(
                  child: TextField(
                    keyboardType: TextInputType.name,
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "${widget.userModel?.name}",
                      prefixIcon: const Icon(Icons.person),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(143, 148, 251, 1),
                        blurRadius: 10.0,
                        offset: Offset(2, 6),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                child: Container(
                  child: TextField(
                    keyboardType: TextInputType.phone,
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: "${widget.userModel?.phoneNumber}",
                      prefixIcon: const Icon(Icons.call),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(143, 148, 251, 1),
                        blurRadius: 10.0,
                        offset: Offset(2, 6),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                child: Container(
                  child: TextField(
                    keyboardType: TextInputType.name,
                    controller: genderController,
                    decoration: InputDecoration(
                      labelText: "${widget.userModel?.gender}",
                      prefixIcon: const Icon(Icons.transgender),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(143, 148, 251, 1),
                        blurRadius: 10.0,
                        offset: Offset(2, 6),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                child: Container(
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "${widget.userModel?.email}",
                      prefixIcon: const Icon(Icons.mail_outline),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(143, 148, 251, 1),
                        blurRadius: 10.0,
                        offset: Offset(2, 6),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                child: Container(
                  child: TextField(
                    keyboardType: TextInputType.text,
                    controller: locationController,
                    decoration: InputDecoration(
                      labelText: "${widget.userModel?.location}",
                      prefixIcon: const Icon(Icons.location_on),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(143, 148, 251, 1),
                        blurRadius: 10.0,
                        offset: Offset(2, 6),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 32, 0, 16),
                child: GestureDetector(
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.amberAccent,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(143, 148, 251, 1),
                          blurRadius: 10.0,
                          offset: Offset(2, 6),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Save changes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                  onTap: () async {
                    uploadImage;

                    await userFromFirebase.doc(widget.userModel?.id).update({
                      'email': emailController.text,
                      'user_name': nameController.text,
                      'phone_number': phoneController.text,
                      'gender': genderController.text,
                      'location': locationController.text,
                      'avatar_url': avatarUrl,
                    });

                    Get.snackbar(
                        "Message", "User information successfully updated.",
                        snackPosition: SnackPosition.BOTTOM,
                        borderRadius: 20,
                        duration: const Duration(seconds: 4),
                        margin: const EdgeInsets.all(15),
                        isDismissible: true,
                        dismissDirection: DismissDirection.horizontal,
                        forwardAnimationCurve: Curves.easeInOutBack);

                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
