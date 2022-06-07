import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swastha/screens/authentication/bmi_reg.dart';
import 'package:swastha/screens/side_drawer/bmi_calculator.dart';
import 'package:swastha/services/change_screen.dart';
import 'package:swastha/utils/styles.dart';
import 'package:swastha/widgets/round_button.dart';

class UserDetail extends StatefulWidget {
  const UserDetail({Key? key}) : super(key: key);

  @override
  _UserDetailState createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  final TextEditingController name = TextEditingController();
  File? image;
  AndroidUiSettings androidUiSettingsLocked() => AndroidUiSettings(
        toolbarTitle: 'Crop Image',
        toolbarColor: Colors.red,
        toolbarWidgetColor: Colors.white,
        hideBottomControls: true,
      );
  Future pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) {
      return;
    }

    final imageTemporary = File(image.path);
    final img = await ImageCropper().cropImage(
      cropStyle: CropStyle.circle,
      sourcePath: imageTemporary.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      compressFormat: ImageCompressFormat.jpg,
    );
    setState(() {
      this.image = File(img!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Align(alignment: Alignment.topLeft, child: BackButton()),
                const SizedBox(
                  height: 18,
                ),
                Image.asset(
                  'assets/images/logo.png',
                  width: 100,
                  height: 100,
                ),
                const SizedBox(
                  height: 24,
                ),
                const Text(
                  'Complete Registeration',
                  style: kHeadingTextStyle,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Complete Your Profile",
                  style: kSubHeadingTextStyle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 28,
                ),
                InkWell(
                  onTap: () => {pickImage()},
                  child: image == null
                      ? const CircleAvatar(
                          radius: 100,
                          backgroundColor: kWhite,
                          child: Icon(
                            Icons.photo_camera,
                            color: kPrimaryColor,
                            size: 100,
                          ),
                        )
                      : CircleAvatar(
                          radius: 100,
                          backgroundImage: Image.file(image!).image),
                ),
                const SizedBox(
                  height: 28,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 15.0),
                  child: TextFormField(
                    controller: name,
                    keyboardType: TextInputType.name,
                    onChanged: (value) {},
                    decoration: kTextFieldDecoration.copyWith(
                        prefixIcon: const Icon(
                          Icons.person,
                          color: kPrimaryColor,
                        ),
                        hintText: 'Enter Your Name',
                        labelText: 'Enter Your Name'),
                  ),
                ),
                RoundedButton(
                    title: 'Continue',
                    colour: kPrimaryColor,
                    onPressed: () {
                      if (image != null) {
                        final _auth = FirebaseAuth.instance.currentUser;
                        FirebaseStorage.instance
                            .ref('Profile')
                            .child(_auth!.uid)
                            .putFile(image!)
                            .whenComplete(() {
                          changeScreen(context,
                              BMIReg(name: name.text, profileURL: image!.path));
                        });
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
