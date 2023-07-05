import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:rive/rive.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _usernameController = TextEditingController();
  var _passwordController = TextEditingController();

  var animationLink='assets/login.riv';
  late SMITrigger failTrigger, successTrigger;
  late SMIBool isChecking, isHandsUp;
  late SMINumber lookNum;
  Artboard? artboard;
  late StateMachineController stateMachineController;

  @override
  void initState() {
    // TODO: implement initState
    initArtboard();
  }

  initArtboard(){
    rootBundle.load(animationLink).then((value){
      final file = RiveFile.import(value);
      final art = file.mainArtboard;
      stateMachineController= StateMachineController.fromArtboard(art, "Login Machine")!;
      if(stateMachineController!=null){
        art.addController(stateMachineController);

        for(var element in stateMachineController!.inputs){
          if(element.name == "isChecking"){
            isChecking = element as SMIBool;
          }
          else if(element.name=='isHandsUp'){
            isHandsUp = element as SMIBool;
          }
          else if(element.name== "trigSuccess"){
              successTrigger= element as SMITrigger;
          }
          else if(element.name == "trigFail"){
            failTrigger = element as SMITrigger;
          }
          else if(element.name== "numLook"){
            lookNum= element as SMINumber;
          }
        }
      }
      setState(() {
        artboard=art;
      });
    });
  }

  checking(){
    isHandsUp.change(false);
    isChecking.change(true);
    lookNum.change(0);
  }
  moveEyes(value)
  {
    lookNum.change(value.length.toDouble());
  }

  handsUp(){
    isHandsUp.change(true);
    isChecking.change(false);
  }
  login(){
    isHandsUp.change(false);
    isChecking.change(false);
    if(_usernameController.text=='Railoth' && _passwordController.text=='12345678'){
      successTrigger.fire();
    }
    else
      failTrigger.fire();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffd6e2ea),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(artboard !=null)
            SizedBox(
              width: 400,
              height: 350,
              child: Rive(artboard: artboard!,),
            ),
            Container(
              alignment: Alignment.center,
              width: 400,
              padding: const EdgeInsets.only(bottom: 15),
              margin: const EdgeInsets.only(bottom: 15 * 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        const SizedBox(height: 15 * 2),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextField(
                            onTap: checking,
                            onChanged: ((value) => moveEyes(value)),
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Username',
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 10,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextField(
                            onTap: handsUp,
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Password',
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 10,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15 * 2),
                        ElevatedButton(
                          onPressed: login,
                          style: ElevatedButton.styleFrom(
                            primary: Colors.red,
                          ),
                          child: const Text('Login'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

