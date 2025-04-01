import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  String barcodeResult = "Waiting for scan...";
  String enteredBarcode = "";

  Future<void> scanBarcode() async {
    try {
      String scannedBarcode = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', false, ScanMode.BARCODE);

      if (!mounted) return;
      setState(() {
        barcodeResult = scannedBarcode != '-1' ? scannedBarcode : "Scan Cancelled";
      });
    } on PlatformException {
      setState(() {
        barcodeResult = 'Failed to Read Barcode';
      });
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
              color: Colors.black, // Placeholder for scanner
              alignment: Alignment.center,
              child: const Icon(Icons.qr_code_scanner, size: 100, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              "PLACE THE BARCODE TO SCAN THE PRODUCT",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              "Scanned: $barcodeResult",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    enteredBarcode = value;
                  });
                },
                
                decoration: InputDecoration(
                  hintText: 'Enter Barcode Manually',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                  labelText: 'Barcode',
                  
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: scanBarcode,
              child: const Text('Scan Barcode'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle barcode submission
                String finalBarcode = enteredBarcode.isNotEmpty ? enteredBarcode : barcodeResult;
                if (finalBarcode != "Waiting for scan..." && finalBarcode.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Barcode Submitted: $finalBarcode")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please scan or enter a barcode")),
                  );
                }
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
