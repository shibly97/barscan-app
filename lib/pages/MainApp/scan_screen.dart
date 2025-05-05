import 'dart:convert';
import 'package:barscan/Utils/constants.dart';
import 'package:barscan/Utils/API/API.dart';
import 'package:barscan/pages/MainApp/product/product_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  String barcodeResult = "";
  bool isScanning = false;

  Future<void> scanBarcode() async {
    print("searchingggg 22222");
    try {
      String scannedBarcode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', false, ScanMode.BARCODE);

      if (!mounted) return;
      if (scannedBarcode != '-1') {
        setState(() {
          barcodeResult = scannedBarcode;
        });
      }
    } on PlatformException {
      setState(() {
        barcodeResult = 'Failed to read barcode.';
      });
    }
  }

  Future<void> searchProductByBarcode() async {

        if (barcodeResult.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please scan a barcode first.")),
      );
      return;
    }

  try {
    final response = await http.get(Uri.parse('$getByBarCode/4796003448968'));
    
    if (response.statusCode == 200) {
      final product = jsonDecode(response.body); // ✅ single object, not a list

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProductDetailScreen(productId: product['id'])),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No product found for this barcode.")),
      );
    }
  } catch (e) {
    print("Error searching product: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Something went wrong. Try again.")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan Bar Code"),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Scan the Barcode",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Container(
                width: 250,
                height: 250,
                color: Colors.black,
                alignment: Alignment.center,
                child: const Icon(Icons.qr_code_scanner, size: 100, color: Colors.white),
              ),
              const SizedBox(height: 20),
              const Text(
                "PLACE THE BARCODE TO SCAN THE PRODUCT",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: TextEditingController(text: barcodeResult),
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: 'Barcode will appear here after scan',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                    labelText: 'Barcode',
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: scanBarcode,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text('Scan Barcode'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: searchProductByBarcode,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                child: const Text('Continue', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
