import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const CarMonitorApp());
}

class CarMonitorApp extends StatelessWidget {
  const CarMonitorApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Мониторинг авто',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late Timer _timer;

  double fuelLevel = 50.0; // %
  double engineTemp = 90.0; // °C
  double tirePressure = 32.0; // psi
  double batteryVoltage = 12.6; // V

  final Random _random = Random();

  void _updateData() {
    setState(() {
      fuelLevel = max(0.0, min(100.0, fuelLevel + _random.nextDouble() * 3 - 2));
      engineTemp = max(40.0, min(120.0, engineTemp + _random.nextDouble() * 2 - 1));
      tirePressure = max(28.0, min(36.0, tirePressure + _random.nextDouble() * 0.5 - 0.2));
      batteryVoltage = max(11.0, min(14.4, batteryVoltage + _random.nextDouble() * 0.1 - 0.05));
    });

    _checkWarnings();
  }

  void _checkWarnings() {
    if (fuelLevel < 10) {
      _showDialog('Низкий уровень топлива!');
    }
    if (engineTemp > 110) {
      _showDialog('Перегрев двигателя!', isError: true);
    }
    if (tirePressure < 29) {
      _showDialog('Низкое давление в шинах!');
    }
    if (batteryVoltage < 11.8) {
      _showDialog('АКБ разряжается!');
    }
  }

  void _startMonitoring() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _updateData();
    });
  }

  void _showDialog(String message, {bool isError = false}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isError ? "Ошибка" : "Предупреждение"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _startMonitoring();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Мониторинг состояния автомобиля")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDataRow("Топливо", "${fuelLevel.toInt()}%"),
            _buildDataRow("Температура двигателя", "${engineTemp.toInt()}°C"),
            _buildDataRow("Давление в шинах", "${tirePressure.toStringAsFixed(1)} psi"),
            _buildDataRow("Напряжение АКБ", "${batteryVoltage.toStringAsFixed(1)} В"),
          ],
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$label:", style: const TextStyle(fontSize: 16)),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
