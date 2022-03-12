import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:typed_data';


class BioData {
  static const String _serviceUUID = "c747d8bf-7ebb-4496-849c-423df0faa334";
  static const String _heartCharacteristicUUID = "9ffca074-9adf-4d92-902a-0147ca8c0977";
  static const String _touchCharacteristicUUID = "8cbb2086-64c9-4eab-84e1-0206e3261629";
  static const String _motorCharacteristicUUID = "128896ad-95d5-45bf-8c84-05909ce01945";

  BluetoothDevice? _device;
  BluetoothService? _service;
  BluetoothCharacteristic? _heartCharacteristic;
  BluetoothCharacteristic? _touchCharacteristic;
  BluetoothCharacteristic? _motorCharacteristic;

  final StreamController<bool> _isConnectedController = StreamController.broadcast();
  bool _isConnected = false;

  BioData() {

    //set _device if it is already connected
    FlutterBluePlus.instance.connectedDevices.then((List<BluetoothDevice> connectedDevices) {
      for (BluetoothDevice device in connectedDevices) {
        device.discoverServices().then((List<BluetoothService> services) {
          if(services.any((element) => element.uuid.toString() == _serviceUUID)) {
            _setDevice(device);
          }
        });
      }
    });

    //start listener to is connected stream
    _isConnectedController.stream.listen(isConnectedListener);
  }

  void isConnectedListener(bool event) {
    //if the device ever is not connected
    _isConnected=event;
  }

  void connectToDevice() {
    if(_device == null) {
      FlutterBluePlus.instance
          .scan(withServices: [Guid(_serviceUUID)])
          .first
          .then((value) {
        _setDevice(value.device);
        _device!.connect();
        FlutterBluePlus.instance.stopScan();
      });
    } else {
      _device?.connect();
    }
  }

  void _setDevice(BluetoothDevice device) {
    _device = device;
    _isConnectedController.sink.addStream(
        _device!.state
            .map((state) => state == BluetoothDeviceState.connected)
    );
  }

  Stream<bool> deviceConnected() {
    return _isConnectedController.stream;
  }

  bool currentlyConnected() {
    return _isConnected;
  }

  void _setupCharacteristics() {
    _device!.discoverServices().then((List<BluetoothService> services) {
      _service = services.firstWhere((element) => element.uuid.toString() == _serviceUUID);
      for (BluetoothCharacteristic characteristic in _service!.characteristics) {
        switch(characteristic.uuid.toString()) {
          case _heartCharacteristicUUID: {
            _heartCharacteristic = characteristic;
          }
          break;
          case _touchCharacteristicUUID: {
            _touchCharacteristic = characteristic;
          }
          break;
          case _motorCharacteristicUUID: {
            _motorCharacteristic = characteristic;
          }
        }
      }
    });
  }


  Stream<double>? heartRateStream() {
    return _heartCharacteristic?.value.map((data) {
      final Uint8List bytes = Uint8List.fromList(data);
      final ByteData byteData = ByteData.sublistView(bytes);
      return byteData.getFloat32(0);
    });
  }

  Stream<bool>? touchedStream() {
    return _touchCharacteristic?.value.map((data) {
      for(int i in data) {
        if(i != 0) {
          return true;
        }
      }
      return false;
    });
  }

  void activateMotor(int mode) {
    if(mode < 0 || mode > 3) {
      return;
    }
    _motorCharacteristic?.write(<int>[0,0,0,mode]);
  }
}