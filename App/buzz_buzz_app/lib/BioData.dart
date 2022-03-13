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
  final StreamController<double> _heartrateStreamController = StreamController.broadcast();
  final StreamController<bool> _touchStreamController = StreamController.broadcast();


  BioData() {

    //set _device if it is already connected
    FlutterBluePlus.instance.connectedDevices.then((List<BluetoothDevice> connectedDevices) {
      for (BluetoothDevice device in connectedDevices) {
        device.discoverServices().then((List<BluetoothService> services) {
          if(services.any((element) => element.uuid.toString() == _serviceUUID)) {
            _isConnectedController.sink.add(true);
            _setDevice(device);
            _setupCharacteristics();
          }
        });
      }
    });

    //start listener to is connected stream
    _isConnectedController.stream.listen(isConnectedListener);
  }

  void isConnectedListener(bool event) {
    _isConnected=event;
  }

  void connectToDevice() {
    if(_device == null) {
      FlutterBluePlus.instance
          .scan(withServices: [Guid(_serviceUUID)])
          .first
          .then((value) {
        _setDevice(value.device);
        _device!.connect().then((_) {
          _setupCharacteristics();
        });
        ;
        FlutterBluePlus.instance.stopScan();
      });
    } else {
      _device?.connect().then((_) {
        _setupCharacteristics();
      });
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
            _heartCharacteristic!.setNotifyValue(true);
          }
          break;
          case _touchCharacteristicUUID: {
            _touchCharacteristic = characteristic;
            _touchCharacteristic!.setNotifyValue(true);
          }
          break;
          case _motorCharacteristicUUID: {
            _motorCharacteristic = characteristic;
          }
        }
      }

      _heartrateStreamController.sink.addStream(
          _heartCharacteristic!.value.map((data) {
            return ByteData.sublistView(Uint8List.fromList(data)).getFloat32(0, Endian.little);
          })
      );

      _touchStreamController.sink.addStream(
          _touchCharacteristic!.value.asBroadcastStream().map((data) {
            return data.any((element) => element!=0);
          })
      );

    });
  }


  Stream<double> heartRateStream() {
    return _heartrateStreamController.stream;
  }

  Stream<bool> touchedStream() {
    return _touchStreamController.stream;
  }

  void activateMotor(int mode) {
    if(mode < 0 || mode > 3) {
      return;
    }
    _motorCharacteristic?.write(<int>[0,0,0,mode]);
  }
}