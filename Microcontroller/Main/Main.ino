//This the code to run all of the stuff at once

//libraries
#include <BLEDevice.h>
#include <BLEUtils.h>
#include <BLEServer.h>
#include <BLE2902.h>


//pins
#define TOUCH_PIN D2  //capacitive touch sensor
#define MOTOR_PIN D7  //vibrator
#define HEART_PIN A2  //heart rate sensor

//BLE UUIDs
#define SERVICE_UUID "c747d8bf-7ebb-4496-849c-423df0faa334"
#define HEART_CHARACTERISTIC_UUID "9ffca074-9adf-4d92-902a-0147ca8c0977"
#define TOUCH_CHARACTERISTIC_UUID "8cbb2086-64c9-4eab-84e1-0206e3261629"
#define MOTOR_CHARACTERISTIC_UUID "128896ad-95d5-45bf-8c84-05909ce01945"

//defines for PWM
#define LEDC_CHANNEL_0     0


//prototypes to appease compiler
void onTouch();
void vibrate(int mode);


//task handles
TaskHandle_t heartHandle = NULL;

//characteristics (this is the data shared over BLE)
BLECharacteristic *heartCharacteristic;
BLECharacteristic *touchCharacteristic;
BLECharacteristic *motorCharacteristic;

class MyServerCallbacks: public BLEServerCallbacks 
{
  void onConnect(BLEServer* pServer) 
  {
    Serial.println("Connect!");

    //turn on sensors
    vTaskResume(heartHandle);
    attachInterrupt(TOUCH_PIN, onTouch, CHANGE);
  };

  void onDisconnect(BLEServer* pServer) 
  {
    Serial.println("Disconnect :(");

    //turn off sensors
    vTaskSuspend(heartHandle);
    detachInterrupt(TOUCH_PIN);

    //turn off motor
    vibrate(0);

    //start looking for a client
    BLEDevice::startAdvertising();
  }
};



class MotorCharacteristicCallbacks: public BLECharacteristicCallbacks 
{
  void onWrite(BLECharacteristic* pCharacteristic)
  {
    int mode = *(pCharacteristic->getData());
    vibrate(mode);
  }
};

void setup() {
  Serial.begin(115200);
  pinMode(TOUCH_PIN, INPUT);   //capacitive touch sensor
  pinMode(HEART_PIN, INPUT);   //ppg sensor

  // Setup timer and attach timer to motor pin
  ledcSetup(LEDC_CHANNEL_0, 5000, 13);
  ledcAttachPin(MOTOR_PIN, LEDC_CHANNEL_0);
  
  //create tasks and immediately suspend them
  xTaskCreate(sendHeartrate, "Send Heartrate", 8000, NULL, 1, &heartHandle);
  vTaskSuspend(heartHandle); 


  // Create the BLE Device
  BLEDevice::init("BuzzBuzz Bracelet");


  // Create the BLE Server
  BLEServer *pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());


  // Create the BLE Service
  BLEService *pService = pServer->createService(SERVICE_UUID);


  // Create BLE Characteristic for ppg sensor
  heartCharacteristic = pService->createCharacteristic(
    HEART_CHARACTERISTIC_UUID,
    BLECharacteristic::PROPERTY_READ  |
    BLECharacteristic::PROPERTY_NOTIFY
  );

  // Create BLE Characteristic for touch sensor
  touchCharacteristic = pService->createCharacteristic(
    TOUCH_CHARACTERISTIC_UUID,
    BLECharacteristic::PROPERTY_READ |
    BLECharacteristic::PROPERTY_NOTIFY
  );

  
  // Create BLE Characteristic for motor
  motorCharacteristic = pService->createCharacteristic(
    MOTOR_CHARACTERISTIC_UUID,
    BLECharacteristic::PROPERTY_READ |
    BLECharacteristic::PROPERTY_WRITE
  );

  motorCharacteristic->setCallbacks(new MotorCharacteristicCallbacks());


  // https://www.bluetooth.com/specifications/gatt/viewer?attributeXmlFile=org.bluetooth.descriptor.gatt.client_characteristic_configuration.xml
  // Create a BLE Descriptor for notify
  heartCharacteristic->addDescriptor(new BLE2902());
  touchCharacteristic->addDescriptor(new BLE2902());


  // Start the service
  pService->start();


  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(true);
  pAdvertising->setMinPreferred(0x06);  // functions that help with iPhone connections issue
  pAdvertising->setMinPreferred(0x12);
  BLEDevice::startAdvertising();
}

void loop(){}
