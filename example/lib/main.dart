import 'package:flutter/material.dart';
import 'package:imei/imei.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IMEI Plugin Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'IMEI Plugin Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _imei = 'Unknown';
  List<String> _imeiList = [];
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _requestPermission() async {
    final status = await Permission.phone.request();
    if (!status.isGranted) {
      setState(() {
        _errorMessage = 'READ_PHONE_STATE permission is required to get IMEI';
      });
    }
  }

  Future<void> _getImei() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final imei = await Imei.getImei();
      setState(() {
        _imei = imei ?? 'IMEI not available';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _imei = 'Error';
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _getImeiList() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final imeiList = await Imei.getImeiList();
      setState(() {
        _imeiList = imeiList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _imeiList = [];
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Single IMEI',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      SelectableText(
                        _imei,
                        style: const TextStyle(fontSize: 16),
                      ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _getImei,
                      child: const Text('Get IMEI'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Multiple IMEIs (Dual SIM)',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (_imeiList.isEmpty)
                      const Text('No IMEI numbers available')
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: _imeiList
                            .asMap()
                            .entries
                            .map(
                              (entry) => Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: SelectableText(
                                  'IMEI ${entry.key + 1}: ${entry.value}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _getImeiList,
                      child: const Text('Get IMEI List'),
                    ),
                  ],
                ),
              ),
            ),
            if (_errorMessage.isNotEmpty) ...[
              const SizedBox(height: 16),
              Card(
                color: Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.error, color: Colors.red),
                          SizedBox(width: 8),
                          Text(
                            'Error',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SelectableText(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          'Permission',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This app requires READ_PHONE_STATE permission to access IMEI.',
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _requestPermission,
                      child: const Text('Request Permission'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning, color: Colors.orange),
                        SizedBox(width: 8),
                        Text(
                          'Note',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'IMEI is only available on Android devices. '
                      'iOS does not provide access to IMEI for privacy reasons.',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
