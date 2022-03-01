//This the code to run all of the stuff at once

//libraries
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>
#include <Wire.h>
#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>
#include <BLE2902.h>


//pins
#define TOUCH_PIN D3  //capacitive touch sensor
#define MOTOR_PIN D2  //vibrator
#define HEART_PIN A0  //heart rate sensor

//BLE UUIDs
#define SERVICE_UUID "c747d8bf-7ebb-4496-849c-423df0faa334"
#define HEART_CHARACTERISTIC_UUID "9ffca074-9adf-4d92-902a-0147ca8c0977"

//task handles
TaskHandle_t heartHandle = NULL;

//characteristics (this is the data shared over BLE)
BLECharacteristic *heartCharacteristic;

class MyServerCallbacks: public BLEServerCallbacks {
  void onConnect(BLEServer* pServer) {
    vTaskResume(heartHandle);
  };

  void onDisconnect(BLEServer* pServer) {
    vTaskSuspend(heartHandle);
  }
};

void setup() {
  Serial.begin(115200);
  pinMode(MOTOR_PIN, OUTPUT);  //vibrator
  pinMode(TOUCH_PIN, INPUT);   //capacitive touch sensor
  pinMode(HEART_PIN, INPUT);   //ppg sensor

  //create tasks and immediately suspend them
  xTaskCreate(sendHeartrate, "Send Heartrate", 1000, NULL, 1, &heartHandle);
  vTaskSuspend(heartHandle); 


  // Create the BLE Device
  BLEDevice::init("BuzzBuzz Bracelet");


  // Create the BLE Server
  BLEServer *pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());


  // Create the BLE Service
  BLEService *pService = pServer->createService(SERVICE_UUID);


  // Create a BLE Characteristic
    heartCharacteristic = pService->createCharacteristic(
    HEART_CHARACTERISTIC_UUID,
    BLECharacteristic::PROPERTY_READ   |
    BLECharacteristic::PROPERTY_WRITE  |
    BLECharacteristic::PROPERTY_NOTIFY
  );


  // https://www.bluetooth.com/specifications/gatt/viewer?attributeXmlFile=org.bluetooth.descriptor.gatt.client_characteristic_configuration.xml
  // Create a BLE Descriptor
  heartCharacteristic->addDescriptor(new BLE2902());


  // Start the service
  pService->start();


  // Start advertising
  pServer->getAdvertising()->start();
}

void loop() {}
