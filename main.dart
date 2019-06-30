import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './search.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('ddd'),
        ),
        body: SearchWidget(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  bool rememberUname;
  bool rememberPwd;

  void _getSharedPreferences() {
SharedPreferences.getInstance().then((prefs) {
      if(prefs.getString('username') != null) {
        setState(() {
         rememberUname = true;
           _usernameController.text = prefs.getString('username');
        });
        
      } else {
         setState(() {
         rememberUname = false;
        });
      }

      if(prefs.getString('userpwd') != null) {
         setState(() {
         rememberPwd = true;
         _passwordController.text = prefs.getString('userpwd');
        });
      
      } else {
         setState(() {
         rememberPwd = false;
        });
      }
     });
  }

  @override
  void initState() {
    super.initState();
    _getSharedPreferences();
  }

  @override
  void dispose(){
    super.dispose();
    _usernameController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
       child: Form(
         key: _formKey,
         child: Column(children: <Widget>[
           TextFormField(
             controller: _usernameController,
          ),
          TextFormField(
            obscureText: true,
             controller: _passwordController,
          ),
          Row(
            children: <Widget>[
              Row(children: <Widget>[
                Checkbox(tristate: true, value: rememberUname, onChanged: (value) {
                  setState(() {
                    rememberUname = value;
                  });
                },),
                GestureDetector(
                  onTap: () {
                     setState(() {
                    rememberUname = !rememberUname;
                  });
                  },
                  child:  Text('记住用户名'),
                )
              ],),
              
              Row(children: <Widget>[
                Checkbox(tristate: true, value: rememberPwd, onChanged: (value) {
                  
                  setState(() {
                    rememberPwd = value;
                  });
                },),
                GestureDetector(
                  onTap: () {
                     setState(() {
                    rememberPwd = !rememberPwd;
                  });
                  },
                  child:  Text('记住密码'),
                )
               
              ],)
            ],
          ),
          RaisedButton(
            onPressed: (){

              SharedPreferences.getInstance().then((prefs) {
                if(rememberUname == true) {
                   prefs.setString('username', _usernameController.text);
                } else {
                   prefs.remove('username');
                }
                if(rememberPwd == true) {
  prefs.setString('userpwd', _passwordController.text);
                } else {
                  prefs.remove('userpwd');
                }
                 
              });
            },
            child: Text('登录'),)
         ],),
       ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
