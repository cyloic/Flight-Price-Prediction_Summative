import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;

class PredictionPage extends StatefulWidget {
  @override
  _PredictionPageState createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  final List<TextEditingController> _controllers = List.generate(
    5, (_) => TextEditingController()
  );
  String _result = '';
  bool _isLoading = false;

  Future<void> _predict() async {
    setState(() {
      _isLoading = true;
      _result = '';
    });

    try {
      final url = Uri.parse('http://127.0.0.1:8000/predict'); // Android emulator
      // For iOS simulator use: 'http://127.0.0.1:8000/predict'
      // For physical device: Use your computer's local IP

      final requestBody = {
        "feature1": _parseInput(_controllers[0].text),
        "feature2": _parseInput(_controllers[1].text),
        "feature3": _parseInput(_controllers[2].text),
        "feature4": _parseInput(_controllers[3].text),
        "feature5": _parseInput(_controllers[4].text),
      };

      developer.log('Sending request to: $url');
      developer.log('Request body: $requestBody');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      ).timeout(const Duration(seconds: 5));

      developer.log('Response status: ${response.statusCode}');
      developer.log('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          _result = 'Prediction: \$${responseData['prediction'].toStringAsFixed(2)}';
        });
      } else {
        setState(() {
          _result = 'API Error (${response.statusCode}): ${response.body}';
        });
      }
    } catch (e) {
      developer.log('Error occurred: $e');
      setState(() {
        _result = 'Error: ${e.toString().replaceAll('Exception: ', '')}';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  double _parseInput(String text) {
    if (text.isEmpty) return 0.0;
    return double.tryParse(text) ?? 0.0;
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Flight Price Prediction')),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Airline
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: TextField(
              controller: _controllers[0],
              decoration: InputDecoration(
                labelText: 'Airline',
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12.0, horizontal: 16.0),
              ),
            ),
          ),
          
          // Source
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: TextField(
              controller: _controllers[1],
              decoration: InputDecoration(
                labelText: 'Source City',
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12.0, horizontal: 16.0),
              ),
            ),
          ),
          
          // Destination
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: TextField(
              controller: _controllers[2],
              decoration: InputDecoration(
                labelText: 'Destination City',
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12.0, horizontal: 16.0),
              ),
            ),
          ),
          
          // Duration
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: TextField(
              controller: _controllers[3],
              decoration: InputDecoration(
                labelText: 'Duration (hours)',
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12.0, horizontal: 16.0),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
          ),
          
          // Number of Stops
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: TextField(
              controller: _controllers[4],
              decoration: InputDecoration(
                labelText: 'Number of Stops',
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12.0, horizontal: 16.0),
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _predict,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'PREDICT PRICE',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 24),
          if (_result.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: _result.contains('Error')
                    ? Colors.red[50]
                    : Colors.green[50],
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: _result.contains('Error')
                      ? Colors.red
                      : Colors.green,
                  width: 1.0,
                ),
              ),
              child: Text(
                _result,
                style: TextStyle(
                  fontSize: 16,
                  color: _result.contains('Error')
                      ? Colors.red[800]
                      : Colors.green[800],
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    ),
  );
}

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}