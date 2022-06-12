import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:chatapp/theme.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import '../app.dart';
import 'package:chatapp/screens/screens.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import '../models/models.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;


class SignUpScreen extends StatefulWidget {
  static Route get route => MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      );
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
} 

class _SignUpScreenState extends State<SignUpScreen> {
  final auth = firebase.FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  //final _profilePictureController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final userToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoienRjNGJkMzloZTRoIn0.aJ3fL8TNCvhx3kGitjOruubpGAhajlQMRNfNVMGUoVU";
  final _emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  bool _loading = false;
  String imageFilePath = '';
  String imageURL = '';

  Future _chooseImage() async{
      final results = await FilePicker.platform.pickFiles(
                  allowMultiple: false,
                  type: FileType.custom,
                  allowedExtensions: ['png','jpg']
                );
                if (results == null){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("No files selected")
                    )
                  );
                  return null;
                }
                final filepath = results.files.single.path;
                setState(() {
                  imageFilePath = filepath!;
              });
                //final filename = results.files.single.name;
                print(imageFilePath);
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });
      try {
        // Authenticate with Firebase
        firebase.UserCredential creds = await firebase.FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        firebase.User? user = creds.user;
        if (user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User is empty')),
          );
          return;
        }//fahim10302##

        
        File file = File(imageFilePath);
        try{
            firebase_storage.TaskSnapshot taskSnapshot = await storage.ref('profilepics/${_nameController.text}').putFile(file);
            final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
            setState(() {
                  imageURL = downloadUrl;
              });

          }on firebase_core.FirebaseException catch(e){
            print(e);
          }

          //print("URL obtained.............");

        // Set Firebase display name and profile picture
        // List<Future<void>> futures = [
        //   user.updateDisplayName("assadsad"),
        // ];
        
        // await user.reload();
        // await Future.wait(futures);
          //final Future downloadUrl = Storage().uploadFile(imageFilePath,_nameController.text);
          

        Map<String, dynamic> userInfoMap = <String, dynamic>{
          "email": creds.user!.email,
          "username": creds.user!.email?.replaceAll("@gmail.com", ""),
          "name": _nameController.text,
          "profileUrl": imageURL,
          "userId":creds.user!.uid,
      };

        DatabaseMethods()
          .addUserInfoToDB(creds.user!.uid, userInfoMap)
          .then((value) {
            print("Value added....");
      });

        // Connect user to Stream and set user data
        final client = StreamChatCore.of(context).client;
        await client.connectUser(
          User(
            id: creds.user!.uid,
            name: _nameController.text,
            image: imageURL,
          ),
          userToken,
        );
        

        // Navigate to home screen
        await Navigator.of(context).pushReplacement(HomeScreen.route);
      } on firebase.FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Auth error')),
        );
      } catch (e, st) {
        logger.e('Sign up error', e, st);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An error occured')),
        );
      }
      setState(() {
        _loading = false;
        _emailController.clear();
        _nameController.clear();
        _passwordController.clear();
      });
    }
  }

  String? _nameInputValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Cannot be empty';
    }
    return null;
  }

  String? _emailInputValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Cannot be empty';
    }
    if (!_emailRegex.hasMatch(value)) {
      return 'Not a valid email';
    }
    return null;
  }

  String? _passwordInputValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Cannot be empty';
    }
    if (value.length <= 6) {
      return 'Password needs to be longer than 6 characters';
    }
    return null;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    //_profilePictureController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CHATTER'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: (_loading)
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 24, bottom: 24),
                        child: Text(
                          'Register',
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.w800),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:Stack(
                          children: [
                            (imageFilePath) == ''
                                          ? CircleAvatar(
                                            radius: 50,
                                            child: ClipOval(
                                              child: Image.asset(
                                                        'assets/profilepics/blank-profile-picture.png',
                                                        fit: BoxFit.cover,
                                                        width: double.infinity,
                                                      ),
                                            ),
                                          ):
                                          CircleAvatar(
                                            radius: 50,
                                            child: ClipOval(
                                              child: Image.file(
                                                        File(imageFilePath),
                                                        fit: BoxFit.cover,
                                                        width: double.infinity,
                                                      ),
                                            ),
                                          ),
                              Positioned(
                                right: 0,
                                top: 65,
                                child: InkWell(
                                    borderRadius: BorderRadius.circular(15),
                                    splashColor: AppColors.secondary,
                                    onTap:_chooseImage,
                                    child: const Padding(
                                      padding: EdgeInsets.all(6),
                                      child: Icon(
                                        CupertinoIcons.camera_fill,
                                        size: 22,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                              ),    
                          ]
                        )  
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _nameController,
                          validator: _nameInputValidator,
                          decoration: const InputDecoration(hintText: 'name'),
                          keyboardType: TextInputType.name,
                          autofillHints: const [
                            AutofillHints.name,
                            AutofillHints.username
                          ],
                        ),
                      ),
                      
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _emailController,
                          validator: _emailInputValidator,
                          decoration: const InputDecoration(hintText: 'email'),
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _passwordController,
                          validator: _passwordInputValidator,
                          decoration: const InputDecoration(
                            hintText: 'password',
                          ),
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          keyboardType: TextInputType.visiblePassword,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: _signUp,
                          child: const Text('Sign up'),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Divider(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Already have an account?',
                              style: Theme.of(context).textTheme.subtitle2),
                          const SizedBox(width: 8),
                          TextButton(
                            onPressed: () {
                              //Navigator.of(context).pop();
                              Navigator.of(context).push(SignInScreen.route);
                            },
                            child: const Text('Sign in'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}