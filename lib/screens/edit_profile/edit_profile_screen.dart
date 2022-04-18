import 'dart:io';
import 'package:alert/alert.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:levelup_egoods/utilities/constants.dart';
import 'package:levelup_egoods/utilities/size_config.dart';
import 'package:levelup_egoods/widgets/buttons.dart';
import 'package:provider/provider.dart';

import '../../utilities/auth.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  File? imageFile;
  String name = '';
  @override
  Widget build(BuildContext context) {
    final authUser = Provider.of<Auth>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Profile'),
          centerTitle: true,
        ),
        bottomNavigationBar: Container(
            margin: EdgeInsets.symmetric(
                horizontal: rWidth(20), vertical: rWidth(10)),
            child: DefaultButton('Save Profile', () {
              updateProfile();
            })),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: rWidth(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: rWidth(20),
              ),
              Container(
                alignment: Alignment.center,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    image == null
                        ? CachedNetworkImage(
                            httpHeaders: const {
                              'Connection': 'Keep-Alive',
                              'Keep-Alive': 'timeout=10,max=1000'
                            },
                            imageUrl: authUser.profileImage,
                            placeholder: (context, url) => CircleAvatar(
                              radius: rWidth(50),
                              foregroundImage: const AssetImage(
                                  'assets/images/placeholder/Portrait_Placeholder.png'),
                            ),
                            errorWidget: (context, url, error) {
                              if (error != null) {
                                print(error);
                              }
                              return CircleAvatar(
                                radius: rWidth(50),
                                foregroundImage: const AssetImage(
                                    'assets/images/placeholder/Portrait_Placeholder.png'),
                              );
                            },
                            imageBuilder: (context, imageProvider) =>
                                CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: rWidth(50),
                              foregroundImage: imageProvider,
                            ),
                          )
                        : CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: rWidth(50),
                            foregroundImage: FileImage(imageFile!),
                          ),
                    Positioned(
                      right: -rWidth(20),
                      bottom: -rWidth(10),
                      child: ElevatedButton(
                        onPressed: () async {
                          image = await _picker.pickImage(
                              source: ImageSource.gallery, imageQuality: 80);
                          imageFile = File(image!.path);
                          setState(() {});
                        },
                        child: Container(
                          child: Icon(
                            Icons.camera_alt_rounded,
                            size: rWidth(18),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(5),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: rWidth(20),
              ),
              Text(
                'Address',
                style: TextStyle(fontFamily: 'Archivo'),
              ),
              SizedBox(
                height: rWidth(7),
              ),
              TextFormField(
                onChanged: (String value) {
                  name = value;
                },
                initialValue: authUser.userName,
                validator: RequiredValidator(errorText: 'Enter a name'),
                decoration: InputDecoration(
                    hintText: 'Full Name Here',
                    border: OutlineInputBorder(),
                    fillColor: Theme.of(context).scaffoldBackgroundColor,
                    filled: true,
                    contentPadding: EdgeInsets.symmetric(
                        vertical: rWidth(5), horizontal: rWidth(10))),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateProfile() async {
    final auth = Provider.of<Auth>(context, listen: false);
    if (imageFile == null && name == '') {
      Alert(message: 'No Updates Found').show();
    } else {
      var uri = Uri.parse('$apiUrl/edit-user-profile');
      var request = http.MultipartRequest('POST', uri);
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer ${auth.userToken}',
      });
      if (name != '') {
        request.fields['name'] = name;
        print('name field added');
      }
      if (imageFile != null) {
        request.files
            .add(await http.MultipartFile.fromPath('image', imageFile!.path));
        print('image file added');
      }

      var response = await request.send();
      if (response.statusCode == 200) {
        Alert(message: "Upload Successful").show();
        auth.getUserDetails();
        Navigator.pop(context);
      } else {
        Alert(message: "Some Error Occurred").show();
      }
    }
  }
}
