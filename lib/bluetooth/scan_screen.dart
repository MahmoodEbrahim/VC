import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import '../screens/contect_screen.dart';

class ScanScreen extends StatefulWidget {
  final Function(bool)? onConnect; // معامل اختياري لتحديث حالة الاتصال
  const ScanScreen({super.key, this.onConnect});

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

Future<bool> checkPermissions() async {
  bool bluetoothScanPermission = await Permission.bluetoothScan.request().isGranted;
  bool bluetoothConnectPermission = await Permission.bluetoothConnect.request().isGranted;
  bool locationPermission = await Permission.location.request().isGranted;
  return bluetoothScanPermission && bluetoothConnectPermission && locationPermission;
}

void _showPermissionDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xff7B88E0))),
        content: Text(message, style: const TextStyle(color: Colors.black87)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK", style: TextStyle(color: Color(0xff7B88E0))),
          ),
        ],
      );
    },
  );
}

class _ScanScreenState extends State<ScanScreen> {
  List<BluetoothDevice> devicesList = [];
  BluetoothDevice? connectedDevice;
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    startScan();
  }

  void startScan() async {
    setState(() {
      isScanning = true;
      devicesList.clear();
    });

    if (!await FlutterBluePlus.isOn) {
      _showPermissionDialog(
        context,
        "Bluetooth Off ❌",
        "Please turn on Bluetooth to scan for devices.",
      );
      setState(() {
        isScanning = false;
      });
      return;
    }

    bool permissionsGranted = await checkPermissions();
    if (!permissionsGranted) {
      _showPermissionDialog(
        context,
        "Permissions Denied ❌",
        "Some permissions were denied. Please enable them in the settings.",
      );
      setState(() {
        isScanning = false;
      });
      return;
    }

    try {
      print("Starting Bluetooth scan...");
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

      FlutterBluePlus.scanResults.listen((results) {
        for (ScanResult result in results) {
          if (!devicesList.contains(result.device)) {
            setState(() {
              devicesList.add(result.device);
            });
          }
        }
      });

      await Future.delayed(const Duration(seconds: 10));
      setState(() {
        isScanning = false;
      });
      if (devicesList.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No devices found!", style: TextStyle(color: Colors.white))),
        );
      }
    } catch (e) {
      _showPermissionDialog(context, "Scan Error ❌", "An error occurred: $e");
      setState(() {
        isScanning = false;
      });
    }
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect();
      setState(() {
        connectedDevice = device;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connected to ${device.name}', style: const TextStyle(color: Colors.white))),
      );
      // الانتقال لشاشة التحكم مع تمرير الجهاز المتصل
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ContectScreen(connectedDevice: device),
        ),
      );
      // تحديث حالة الاتصال إذا تم تمرير onConnect
      if (widget.onConnect != null) {
        widget.onConnect!(true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error connecting: $e', style: const TextStyle(color: Colors.white))),
      );
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Devices', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xff7B88E0),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/bg1.png"), fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: isScanning ? null : startScan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isScanning ? Colors.grey : const Color(0xff7B88E0),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  isScanning ? 'Scanning...' : 'Scan for Devices',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: devicesList.isEmpty && !isScanning
                  ? const Center(
                child: Text("No devices found", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
              )
                  : ListView.builder(
                itemCount: devicesList.length,
                itemBuilder: (context, index) {
                  BluetoothDevice device = devicesList[index];
                  bool isConnected = connectedDevice == device;
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: Colors.white.withOpacity(0.9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      leading: isConnected ? const Icon(Icons.check_circle, color: Colors.green) : null,
                      title: Text(
                        device.name.isNotEmpty ? device.name : 'Unknown',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: isConnected ? FontWeight.bold : FontWeight.normal,
                          color: isConnected ? Colors.green : const Color(0xff7B88E0),
                        ),
                      ),
                      subtitle: Text(device.id.toString(), style: const TextStyle(color: Colors.black54)),
                      trailing: ElevatedButton(
                        onPressed: isConnected ? null : () => connectToDevice(device),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isConnected ? Colors.green : const Color(0xff7B88E0),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(isConnected ? 'Connected' : 'Connect', style: const TextStyle(color: Colors.white)),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    FlutterBluePlus.stopScan();
    super.dispose();
  }
}