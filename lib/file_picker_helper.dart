import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_final_sri/provider_productos.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilePickerDemo extends StatefulWidget {
  @override
  _FilePickerDemoState createState() => new _FilePickerDemoState();
}

class _FilePickerDemoState extends State<FilePickerDemo> {
  String _fileName;
  String _path;
  Map<String, String> _paths;
  String _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  bool _hasValidMime = false;
  FileType _pickingType;
  TextEditingController controlador = TextEditingController();

  TextEditingController _controller = new TextEditingController();
  String claveTemp;
  String antiguoPath = "ninguno";
  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
     getSharedPrefs();
  }
    getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      this.controlador.text = prefs.getString("p12clave");
      this.claveTemp = prefs.getString("p12clave"); // TextEditingController(text: prefs.getString("dirMatriz"));
      this.antiguoPath = prefs.getString("p12path");
      if (this.antiguoPath== null){
        this.antiguoPath = "ninguno";
      }
    });
  }

  void _openFileExplorer() async {
    // final productoInfo=Provider.of<ProductosArrayInfo>(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_pickingType != FileType.CUSTOM || _hasValidMime) {
      setState(() => _loadingPath = true);
      try {
        if (_multiPick) {
          _path = null;
          _paths = await FilePicker.getMultiFilePath(
              type: _pickingType, fileExtension: _extension);
        } else {
          _paths = null;
          _path = await FilePicker.getFilePath(
              type: _pickingType, fileExtension: _extension);
          // productoInfo.p12path = _path;
          prefs.setString("p12path", _path);
          
        }
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
      if (!mounted) return;
      setState(() {
        _loadingPath = false;
        _fileName = _path != null
            ? _path.split('/').last
            : _paths != null ? _paths.keys.toString() : '...';
      });
    }
  }

  Future<bool> _onBackPressed() {
    // final productoInfo=Provider.of<ProductosArrayInfo>(context);

    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('guardar datos', textAlign: TextAlign.center,),
        // content: new Text('Deseas salir realmente?', textAlign: TextAlign.center,),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child:
            FlatButton(color: Colors.green,child: Text('NO'),),
          ),
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(true),
            child: 
             FlatButton(
               onPressed: (){
                  //procede a guardar
                  // productoInfo.p12clave = this.claveTemp;
                  // productoInfo.p12path = this._path;
                  print ("el path > " +this._path);
                  print ("la clave > " +this.claveTemp);
               },
               color: Colors.red,
               child: Text('SI'),),
          ),
        ],
      ),
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    // final productoInfo=Provider.of<ProductosArrayInfo>(context);

    return WillPopScope(
          onWillPop: _onBackPressed,
          child: Scaffold(
           
          appBar: new AppBar(
            leading: new IconButton(
              icon: new Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text('Instalar Clave y P12'),
            centerTitle: true,
          ),
          body: new Center(
              child: new Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                child: new SingleChildScrollView(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.black, width: 1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: new Column(children: <Widget>[
                            Text(
                              'Clave de certificado',
                              style: TextStyle(fontSize: 18),
                            ),
                            TextField(
                              controller: controlador,
                              textAlign: TextAlign.center,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Introduzca clave P12'
                              ),
                              onChanged: (value)async {
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setString("p12clave", value);
                                // productoInfo.p12clave = value;
                                // print(productoInfo.p12clave);
                              },
                            ),
                            Container(height: 5,)
                          ]
                        )
                        ),
                      /*
                      new Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: new DropdownButton(
                            hint: new Text('LOAD PATH FROM'),
                            value: _pickingType,
                            items: <DropdownMenuItem>[
                              new DropdownMenuItem(
                                child: new Text('FROM AUDIO'),
                                value: FileType.AUDIO,
                              ),
                              new DropdownMenuItem(
                                child: new Text('FROM IMAGE'),
                                value: FileType.IMAGE,
                              ),
                              new DropdownMenuItem(
                                child: new Text('FROM VIDEO'),
                                value: FileType.VIDEO,
                              ),
                              new DropdownMenuItem(
                                child: new Text('FROM ANY'),
                                value: FileType.ANY,
                              ),
                              new DropdownMenuItem(
                                child: new Text('CUSTOM FORMAT'),
                                value: FileType.CUSTOM,
                              ),
                            ],
                            onChanged: (value) => setState(() {
                              _pickingType = value;
                              if (_pickingType != FileType.CUSTOM) {
                                _controller.text = _extension = '';
                              }
                            })),
                      ),

                      */

                      /*
                      new ConstrainedBox(
                        constraints: BoxConstraints.tightFor(width: 100.0),
                        child: _pickingType == FileType.CUSTOM
                            ? new TextFormField(
                          maxLength: 15,
                          autovalidate: true,
                          controller: _controller,
                          decoration:
                          InputDecoration(labelText: 'File extension'),
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            RegExp reg = new RegExp(r'[^a-zA-Z0-9]');
                            if (reg.hasMatch(value)) {
                              _hasValidMime = false;
                              return 'Invalid format';
                            }
                            _hasValidMime = true;
                            return null;
                          },
                        )
                            : new Container(),
                      ),
                      */
                      /*
                      new ConstrainedBox(
                        constraints: BoxConstraints.tightFor(width: 200.0),
                        child: new SwitchListTile.adaptive(
                          title: new Text('Pick multiple files',
                              textAlign: TextAlign.right),
                          onChanged: (bool value) =>
                              setState(() => _multiPick = value),
                          value: _multiPick,
                        ),
                      ),*/
                      new Padding(
                        padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                        child: new RaisedButton(color: Colors.red,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.red)),
                          onPressed: () => _openFileExplorer(),
                          child: new Text("Seleccione certificado p12"),
                        ),
                      ),
                      new Builder(
                        builder: (BuildContext context) => _loadingPath
                            ? Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: const CircularProgressIndicator())
                            : _path != null || _paths != null
                            ? new Container(
                          padding: const EdgeInsets.only(bottom: 30.0),
                          height: MediaQuery.of(context).size.height * 0.50,
                          child: new Scrollbar(
                              child: new ListView.separated(
                                itemCount: _paths != null && _paths.isNotEmpty
                                    ? _paths.length
                                    : 1,
                                itemBuilder: (BuildContext context, int index) {
                                  final bool isMultiPath =
                                      _paths != null && _paths.isNotEmpty;
                                  final String name = 'File $index: ' +
                                      (isMultiPath
                                          ? _paths.keys.toList()[index]
                                          : _fileName ?? '...');
                                  final path = isMultiPath
                                      ? _paths.values.toList()[index].toString()
                                      : _path;

                                  return new ListTile(
                                    title: new Text(
                                      name,
                                    ),
                                    subtitle: new Text(path),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                new Divider(),
                              )),
                        )
                            : new Container(),
                      ),

                      Text("certificado actual : "),
                      Text(this.antiguoPath),

                      // RaisedButton(
                      //   shape: new RoundedRectangleBorder(
                      //       borderRadius: new BorderRadius.circular(18.0),
                      //       side: BorderSide(color: Colors.red)),
                      //   onPressed: () {


                      //   },
                      //   color: Colors.red,
                      //   textColor: Colors.white,
                      //   child: Text("Guardar Clave y p12".toUpperCase(),
                      //       style: TextStyle(fontSize: 14)),
                      // )

                    ],
                  ),
                ),
              )),
        ),
    );
    
  }
}