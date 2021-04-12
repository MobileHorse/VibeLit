import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:vibelit/bloc/bloc.dart';
import 'package:vibelit/config/params.dart';
import 'package:vibelit/config/styles.dart';
import 'package:vibelit/util/preference_helper.dart';
import 'package:vibelit/util/toasts.dart';
import 'package:vibelit/widget/button/icon_circle_button.dart';

class BluetoothPairScreen extends StatefulWidget {

  final bool fromSetting;

  BluetoothPairScreen({this.fromSetting = false});

  @override
  _BluetoothPairScreenState createState() => _BluetoothPairScreenState();
}

class _BluetoothPairScreenState extends State<BluetoothPairScreen> {

  String connectedDevice, connectingDevice;
  bool isConnecting;
  List<BluetoothDevice> _devicesList = [];
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  BluetoothBloc _bluetoothBloc;


  StreamSubscription<BluetoothDiscoveryResult> _streamSubscription;
  List<BluetoothDiscoveryResult> results = List<BluetoothDiscoveryResult>();
  bool isDiscovering;
  String processingDevice;

  @override
  void initState() {
    super.initState();
    _bluetoothBloc = BlocProvider.of<BluetoothBloc>(context);
    isConnecting = false;
    connectingDevice = "";
    connectedDevice = PreferenceHelper.getString(Params.lastDevice);
    getPairedDevices();

    processingDevice = null;
    _startDiscovery();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  void _startDiscovery() {
    _streamSubscription = FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
          setState(() {
            results.add(r);
          });
        });

    _streamSubscription.onDone(() {
      setState(() {
        isDiscovering = false;
      });
    });
  }

  void _restartDiscovery() {
    setState(() {
      results.clear();
      isDiscovering = true;
    });

    _startDiscovery();
  }

  Future<void> getPairedDevices() async {
    List<BluetoothDevice> devices = [];

    try {
      devices = await _bluetooth.getBondedDevices();
    } on PlatformException {
      print("Error");
    }

    if (!mounted) return;

    setState(() {
      _devicesList = devices;
    });
  }

  bool _isConnectingDevice(BluetoothDevice device) {
    return isConnecting && connectingDevice == device.address;
  }

  bool _isConnectedDevice(BluetoothDevice device) {
    return connectedDevice == device.address;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.primaryGrey,
      body: Column(
        children: [
          widget.fromSetting ? Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 60),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconCircleButton(
                  icon: Icon(
                    Icons.clear,
                    size: 24,
                    color: Colors.white,
                  ),
                  onClick: () {
                    Navigator.pop(context);
                  },
                  size: 24,
                ),
                Expanded(child: Container()),
                IconCircleButton(
                  icon: Icon(
                    Icons.refresh,
                    size: 24,
                    color: Colors.white,
                  ),
                  onClick: () {
                    _restartDiscovery();
                  },
                  size: 24,
                ),
              ],
            ),
          ) : Container(),
          SizedBox(height: 40,),
          Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: widget.fromSetting ? 0 : 60,),
                    Text(
                      "Devices",
                      style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
                    ),
                    SizedBox(height: 40,),
                    ListView.separated(
                      padding: const EdgeInsets.only(bottom: 30),
                      itemCount: results.length,
                        primary: false,
                        shrinkWrap: true,
                        itemBuilder: (context, index) => _buildDeviceItem(index),
                    separatorBuilder: (context, index) => SizedBox(height: 20,),)
                  ],
                ),
              )
          )
        ],
      ),
    );
  }

  Widget _buildDeviceItem(int index) {
    BluetoothDevice device = results[index].device;
    int rssi = results[index].rssi;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Color(0xff8b9399).withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(device.name ?? "Unknown device", style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Montserrat'),),
              SizedBox(height: 5,),
              Text(device.address, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12, fontFamily: 'Montserrat'),),
            ],
          ),
          Expanded(child: Container()),
          device.address == processingDevice ? SizedBox(
            child: CircularProgressIndicator(strokeWidth: 2,),
            height: 20.0,
            width: 20.0,
          ) : Container(),
          !device.isConnected ? IconCircleButton(
            icon: Icon(Icons.link, size: 24, color: Colors.white,),
            size: 24,
            padding: 8,
            onClick: () async {
              setState(() {
                processingDevice = device.address;
              });
              bool bonded = false;
              if (device.isBonded) {
                await FlutterBluetoothSerial.instance.removeDeviceBondWithAddress(device.address);
                ToastUtils.showSuccessToast(context, "Unbonded device successfully.");
                PreferenceHelper.remove(Params.lastDevice);
                _bluetoothBloc.add(BluetoothCheckEvent());
              } else {
                bonded = await FlutterBluetoothSerial.instance.bondDeviceAtAddress(device.address);
                ToastUtils.showSuccessToast(context, "Bonded device successfully");
              }
              setState(() {
                results[index] = BluetoothDiscoveryResult(
                    device: BluetoothDevice(
                      name: device.name ?? 'Unknown',
                      address: device.address,
                      isConnected: false,
                      type: device.type,
                      bondState: bonded
                          ? BluetoothBondState.bonded
                          : BluetoothBondState.none,
                    ),
                    rssi: rssi);
              });
            },
          ) : Container(),
          !device.isBonded ? Container() : IconCircleButton(
            icon: Icon(Icons.import_export, size: 24, color: Colors.white,),
            size: 24,
            padding: 8,
            onClick: () async {
              setState(() {
                processingDevice = device.address;
              });
              bool isConnected = false;
              if (device.isConnected) {
                if (_bluetoothBloc.state is BluetoothConnectedState) {
                  await (_bluetoothBloc.state as BluetoothConnectedState).connection.close();
                }
                ToastUtils.showSuccessToast(context, "Disconnected from ${device.name ?? device.address}");
                PreferenceHelper.remove(Params.lastDevice);
                _bluetoothBloc.add(BluetoothCheckEvent());
              } else {
                BluetoothConnection connection = await BluetoothConnection.toAddress(device.address);
                isConnected = true;
                ToastUtils.showSuccessToast(context, "Connected to ${device.name ?? device.address}");
                PreferenceHelper.setString(Params.lastDevice, device.address);
                _bluetoothBloc.add(BluetoothConnectedEvent(connection: connection));
              }
              setState(() {
                results[index] = BluetoothDiscoveryResult(
                    device: BluetoothDevice(
                      name: device.name ?? 'Unknown',
                      address: device.address,
                      isConnected: isConnected,
                      type: device.type,
                      bondState: BluetoothBondState.bonded,
                    ),
                    rssi: rssi);
              });
            },
          )
        ],
      ),
    );
  }

  Widget buildDeviceItem(int index) {
    BluetoothDevice _device = _devicesList[index];
    bool connected = _isConnectedDevice(_device);
    bool isConnectingDevice = _isConnectingDevice(_device);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 30),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Color(0xff8b9399).withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          Text(_device.name, style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Montserrat'),),
          Expanded(child: Container()),
          isConnectingDevice ? SizedBox(
            child: CircularProgressIndicator(strokeWidth: 2,),
            height: 20.0,
            width: 20.0,
          ) : Container(),
          TextButton(
            child: Text(
              isConnectingDevice ? "Connecting..." : connected ? "Disconnect" : "Connect",
              style: TextStyle(color: isConnectingDevice ? Styles.bgYellow : connected ? Styles.bgGreen : Colors.white, fontSize: 12, fontFamily: 'Montserrat'),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              backgroundColor: Colors.white.withOpacity(isConnectingDevice || connected ? 0 : 0.1),
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32))),
            ),
            onPressed: () async {
              if (!connected) {
                await connect(_device.address);
              } else {
                await disconnect();
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> connect(String address) async {
    setState(() {
      isConnecting = true;
      connectingDevice = address;
    });
    await BluetoothConnection.toAddress(address).then((value) {
      if (value.isConnected) {
        ToastUtils.showSuccessToast(context, "Connected successfully.");
        PreferenceHelper.setString(Params.lastDevice, address);
        setState(() {
          isConnecting = false;
          connectingDevice = "";
          connectedDevice = address;
        });
        _bluetoothBloc.add(BluetoothConnectedEvent(connection: value));
      } else {
        ToastUtils.showErrorToast(context, "Connection failed");
        setState(() {
          isConnecting = false;
          connectingDevice = "";
        });
      }
    });
  }

  Future<void> disconnect() async {
    if (_bluetoothBloc.state is BluetoothConnectedState) {
      await (_bluetoothBloc.state as BluetoothConnectedState).connection.close();
      setState(() {
        connectedDevice = "";
        PreferenceHelper.remove(Params.lastDevice);
        _bluetoothBloc.add(BluetoothCheckEvent());
      });
    }
  }
}
