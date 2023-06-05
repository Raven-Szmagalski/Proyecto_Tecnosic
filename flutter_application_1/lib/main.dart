// Etiquetas de vinilo resistente a la intemperie: Estas etiquetas están diseñadas específicamente
//para soportar las condiciones exteriores, como la luz solar, la lluvia, el calor y el frío.
//Son duraderas y resistentes al desgaste, y suelen tener un adhesivo fuerte para adherirse de manera segura al equipo.

// Etiquetas con laminado protector: Estas etiquetas tienen una capa adicional de laminado transparente
// que las protege de la exposición al agua, los rayos UV y otros elementos externos.
//El laminado proporciona una barrera adicional contra la decoloración, la abrasión y los productos químicos.

// Etiquetas de poliéster metalizado: Estas etiquetas están hechas de un material de poliéster duradero
// y metalizado que ofrece una excelente resistencia a la intemperie. Son resistentes al agua, a los
//rayos UV y a la mayoría de los productos químicos, lo que las hace adecuadas para entornos al aire libre.

// Etiquetas de aluminio anodizado: El aluminio anodizado es un material resistente y duradero que se
//utiliza comúnmente en entornos industriales y exteriores. Las etiquetas de aluminio anodizado son resistentes
//a la intemperie, a los rayos UV, a la abrasión y a los productos químicos, lo que las hace ideales para su uso en
//equipos expuestos al aire libre.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart'; //no se porque me marca error aca

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    // Redireccionar a SecondPage después de 5 segundos
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SecondPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlutterLogo(
              size: 150,
            ),
            SizedBox(height: 20),
            Text(
              '©2023 Avalom.com',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                fixedSize: Size(312, 105),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QRPage()),
                );
              },
              child: Text('Escanear Codigo'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                fixedSize: Size(312, 105),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InformListPage()), //error
                );
              },
              child: Text('Agregar informacion'),
            ),
          ],
        ),
      ),
    );
  }
}

class QRPage extends StatefulWidget {
  @override
  _QRPageState createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  final GlobalKey qrKey = GlobalKey();
  QRViewController? controller;
  String qrText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Page'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                'QR Code: $qrText',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData.code;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

class InformListPage extends StatefulWidget {
  final CameraDescription camera;

  InformListPage({required this.camera});

  @override
  _InformListPageState createState() => _InformListPageState();
}

class _InformListPageState extends State<InformListPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  String qrCode = '';
  TextEditingController trabajoController = TextEditingController();
  TextEditingController diaController = TextEditingController();
  TextEditingController lugarController = TextEditingController();
  TextEditingController clienteController = TextEditingController();
  File? imageFile;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      setState(() {
        imageFile = File(image.path);
      });
    } catch (e) {
      print('Error taking picture: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agregar Informacion'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'QR Code: $qrCode',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Trabajo que se realizó:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: trabajoController,
              decoration: InputDecoration(
                hintText: 'Ingrese el trabajo realizado',
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Día:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: diaController,
              decoration: InputDecoration(
                hintText: 'Ingrese el día',
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Lugar donde se realizó:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: lugarController,
              decoration: InputDecoration(
                hintText: 'Ingrese el lugar',
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Cliente:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: clienteController,
              decoration: InputDecoration(
                hintText: 'Ingrese el cliente',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _takePicture,
              child: Text('Tomar Foto'),
            ),
            SizedBox(height: 16),
            if (imageFile != null)
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Image.file(
                  imageFile!,
                  fit: BoxFit.cover,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
