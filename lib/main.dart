import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:request/request.dart' as http;
import 'providers.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      child: const MyApp(),
      create: (context) => FormProvider(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Inicio'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController? _controller;
  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildForm(context, _formKey),
    );
  }

  void initState() {
    super.initState();

    FormProvider formProvider =
        Provider.of<FormProvider>(context, listen: false);
    _controller = TextEditingController(text: formProvider.textNameFieldValue);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Widget _buildForm(BuildContext context, GlobalKey formKey) {
    FormProvider formProvider = Provider.of<FormProvider>(context);

    void clearData() {
      formProvider.setFacilityNameFieldValue("");
      formProvider.setTextNameFieldValue("");
      formProvider.setInitialDateTimeValue(null);
      formProvider.setFinalDateTimeValue(null);
    }

    Widget makeListTile(int cnt) {
      return Wrap(direction: Axis.horizontal, children: <Widget>[
        ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                  border: new Border(
                      right: new BorderSide(width: 1.0, color: Colors.white))),
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => addAccess()),
                  );
                },
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                mini: true,
                shape: RoundedRectangleBorder(),
                child: Icon(Icons.add),
              )),
          title: Text(
            "Evento $cnt",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
      ]);
    }

    return (Form(
        key: formKey,
        child: Column(
          children: [
            const SizedBox(height: 10),
            FloatingActionButton.extended(
              onPressed: () {
                clearData();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => addEvent()),
                );
              },
              label: const Text('Añadir evento'),
              foregroundColor: Colors.blue,
              elevation: 5,
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(),
            ),
            const SizedBox(height: 30),
            Expanded(
                child: ListView.builder(
              itemCount: formProvider.items.length,
              itemBuilder: (BuildContext context, int index) {
                int cnt = index + 1;
                return new Container(
                  child: TextButton(
                    onPressed: () {
                      formProvider.setPosition(index);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => viewEvent()),
                      );
                    },
                    child: Card(
                      elevation: 8.0,
                      margin: new EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 6.0),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.blue),
                        child: makeListTile(cnt),
                      ),
                    ),
                  ),
                );
              },
            )),
          ],
        )));
  }
}

// ignore: must_be_immutable
class addEvent extends StatelessWidget {
  TextEditingController? _controller;

  @override
  Widget build(BuildContext context) {
    FormProvider formProvider = Provider.of<FormProvider>(context);

    void _showDialog(String string) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Align(
              child: Text(
                "Alerta",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              alignment: Alignment.center,
            ),
            content: new Text(string),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Cerrar"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Evento'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 30),
            TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.person),
                  labelText: 'Nombre',
                ),
                controller: _controller,
                onChanged: formProvider.setTextNameFieldValue,
                validator: (value) {
                  if (value == null || value == "") {
                    return "Empty field";
                  }
                  return null;
                }),
            TextFormField(
                decoration: const InputDecoration(
                  icon: Icon(Icons.home),
                  labelText: 'Instalacion',
                ),
                controller: _controller,
                onChanged: formProvider.setFacilityNameFieldValue,
                validator: (value) {
                  if (value == null || value == "") {
                    return "Empty field";
                  }
                  return null;
                }),
            DateTimePicker(
              type: DateTimePickerType.dateTimeSeparate,
              initialValue: '',
              icon: Icon(Icons.event),
              firstDate: DateTime.parse("2021-01-01"),
              lastDate: DateTime.parse("2021-12-31"),
              dateLabelText: 'Fecha de inicio',
              onChanged: (val) =>
                  formProvider.setInitialDateTimeValue(DateTime.parse(val)),
              onSaved: (val) =>
                  formProvider.setInitialDateTimeValue(DateTime.parse(val!)),
            ),
            DateTimePicker(
              type: DateTimePickerType.dateTimeSeparate,
              initialValue: '',
              icon: Icon(Icons.event),
              firstDate: DateTime.parse("2021-01-01"),
              lastDate: DateTime.parse("2021-12-31"),
              dateLabelText: 'Fecha de fin',
              onChanged: (val) {
                formProvider.setFinalDateTimeValue(DateTime.parse(val));
              },
              onSaved: (val) {
                formProvider.setFinalDateTimeValue(DateTime.parse(val!));
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              child: const Text('Añadir'),
              onPressed: () {
                if (_MyHomePageState._formKey.currentState!.validate()) {
                  //si cubrir todo_
                  if (formProvider.textNameFieldValue.toString().isNotEmpty &&
                      formProvider.facilityNameFieldValue
                          .toString()
                          .isNotEmpty &&
                      formProvider.initialDateTimeValue != null &&
                      formProvider.finalDateTimeValue != null) {
                    //si fechas incorrectas
                    if (formProvider.initialDateTimeValue!
                                .compareTo(formProvider.finalDateTimeValue!) ==
                            1 ||
                        formProvider.initialDateTimeValue!
                                .compareTo(formProvider.finalDateTimeValue!) ==
                            0) {
                      _showDialog('Fechas incorrectas');
                      //si fechas correctas -> añadir y volver a homepage
                    } else {
                      formProvider.addNewItem([
                        formProvider.textNameFieldValue.toString(),
                        formProvider.facilityNameFieldValue.toString(),
                        formProvider.initialDateTimeValue.toString(),
                        formProvider.finalDateTimeValue.toString(),
                      ]);

                      Navigator.pop(context);
                    }
                  } else {
                    //no se cubren todos los campos
                    _showDialog('Debes cubrir todos los campos');
                  }
                }
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              child: const Text('Cancelar'),
              onPressed: () {
                if (_MyHomePageState._formKey.currentState!.validate()) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class viewEvent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FormProvider formProvider = Provider.of<FormProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Informacion de evento'),
        ),
        body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
                child: Column(
              children: <Widget>[
                Text(
                    'Nombre: ' +
                        formProvider.items[formProvider.position][0].toString(),
                    style: TextStyle(fontSize: 20)),
                const SizedBox(height: 10),
                Text(
                    'Instalación: ' +
                        formProvider.items[formProvider.position][1].toString(),
                    style: TextStyle(fontSize: 20)),
                const SizedBox(height: 10),
                Text(
                    'Fecha de inicio: ' +
                        formProvider.items[formProvider.position][2].toString(),
                    style: TextStyle(fontSize: 20)),
                const SizedBox(height: 10),
                Text(
                    'Fecha de fin: ' +
                        formProvider.items[formProvider.position][3].toString(),
                    style: TextStyle(fontSize: 20))
              ],
            ))));
  }
}

class addAccess extends StatelessWidget {
  TextEditingController? _controller;
  var radioItem;

  @override
  Widget build(BuildContext context) {
    FormProvider formProvider = Provider.of<FormProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir acceso'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'UUID',
              ),
              controller: _controller,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Nombre',
              ),
              controller: _controller,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Apellidos'),
              controller: _controller,
            ),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                labelText: 'Temperatura',
              ),
            ),
            DateTimePicker(
              type: DateTimePickerType.dateTimeSeparate,
              initialValue: '',
              firstDate: DateTime.parse("2021-01-01"),
              lastDate: DateTime.parse("2021-12-31"),
              dateLabelText: 'Fecha',
            ),
            RadioListTile(
              title: const Text("Entrada"),
              value: "A",
              groupValue: formProvider.radioButtonValueEntrada,
              onChanged: formProvider.setRadioButtonValueEntrada,
              toggleable: true,
            ),
            RadioListTile(
              title: const Text("Salida"),
              value: "Salida",
              groupValue: formProvider.radioButtonValueSalida,
              onChanged: formProvider.setRadioButtonValueSalida,
              toggleable: true,
            ),
            DropdownButtonFormField<String>(
              value: formProvider.dropDownValue,
              onChanged: formProvider.setDropDownValue,
              validator: (value) {
                if (value == null) {
                  return "Please select a value";
                }
                return null;
              },
              items: ["Entrada", "Salida"]
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value.toString()),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  //void setState(Null Function() param0) {}
}
