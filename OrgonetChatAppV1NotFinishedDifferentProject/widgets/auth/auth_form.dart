import 'package:flutter/material.dart';
class AuthForm extends StatefulWidget {
  //const AuthForm({Key? key}) : super(key: key);


  AuthForm(
      this.submitFn,
      this.isLoading
      );

  final bool isLoading;

  final void Function(
      String email,
      String password,
      String userName,
      bool isLoading,
      BuildContext ctx
      ) submitFn;
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogIn = true;
  var _userEmail = "";
  var _userName = "";
  var _userPassword = "";


  void _trySubmit(){
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    print("halooo");
    if(isValid){
      _formKey.currentState!.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _isLogIn,
        context,
      );
      //print(_userEmail);
      //print(_userName);
      //print(_userPassword);
    }
  }

  @override
  Widget build(BuildContext context) {
    return
      Center(
        child: Card(
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      key: ValueKey('email'),
                      validator: (value){
                        if(value!.isEmpty || !value.contains("@")){
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        //labelStyle: B
                      ),
                      onSaved: (value){
                        _userEmail = value!;
                      },
                    ),
                    if(!_isLogIn)
                    TextFormField(

                      key: ValueKey('username'),
                      validator: (value){
                        if(value!.isEmpty
                            || value.contains("ccc")
                            || value.contains("rte")
                            || value.contains("akp")
                        ){
                          return "Amcık AKPLi seni amk koyunu ampülü götünde pat...";
                        }
                      },
                      decoration: InputDecoration(
                        labelText: 'Username'
                      ),
                      onSaved: (value){
                        _userName = value!;
                      },
                    ),
                    TextFormField(
                      key: ValueKey('password'),
                      validator: (value){
                        if(value!.isEmpty || value.length < 7){
                          return "try again u shithead";
                        }

                      },
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                      obscureText: true,
                      onSaved: (value){
                        _userPassword = value!;
                      },
                    ),
                    SizedBox(height: 12,),
                    if(widget.isLoading)
                      CircularProgressIndicator(),
                    if(!widget.isLoading)
                    ElevatedButton(
                        onPressed: _trySubmit,
                        child: Text(_isLogIn ? 'Login' : 'Sign Up'),
                        style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
              )
            )
          )
                    ),
                    if(!widget.isLoading)
                    TextButton(
                        onPressed: (){
                          setState(() {
                            _isLogIn = !_isLogIn;
                          });

                        },
                        child: Text(_isLogIn ? 'Create new Account': 'I already have an account',style: TextStyle(
                          color: Colors.lightBlue
                        ),)
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
  }
}
