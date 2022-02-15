//This the code to run all of the stuff at once

//libraries
#include <Adafruit_MPU6050.h>
#include <Adafruit_Sensor.h>
#include <Wire.h>


//pins
#define touchpin D3           //Capacitive touch sensor
#define motor_control D2            //vibrator

//Variables
int touchValue = LOW;
bool touched = false;
Adafruit_MPU6050 mpu;

void setup() {
  Serial.begin(115200);
  pinMode(motor_control, OUTPUT);   //vibrator
  pinMode(touchpin, INPUT);   //capacitive touch sensor

  //this chunk of code that comes next is all for the accelerometer 
      while (!Serial)
        delay(10); // will pause Zero, Leonardo, etc until serial console opens
    
      Serial.println("Adafruit MPU6050 test!");
    
      // Try to initialize!
      if (!mpu.begin()) {
        Serial.println("Failed to find MPU6050 chip");
        while (1) {
          delay(10);
        }
      }
      Serial.println("MPU6050 Found!");
    
      mpu.setAccelerometerRange(MPU6050_RANGE_8_G);
      Serial.print("Accelerometer range set to: ");
      switch (mpu.getAccelerometerRange()) {
      case MPU6050_RANGE_2_G:
        Serial.println("+-2G");
        break;
      case MPU6050_RANGE_4_G:
        Serial.println("+-4G");
        break;
      case MPU6050_RANGE_8_G:
        Serial.println("+-8G");
        break;
      case MPU6050_RANGE_16_G:
        Serial.println("+-16G");
        break;
      }
      mpu.setGyroRange(MPU6050_RANGE_500_DEG);
      Serial.print("Gyro range set to: ");
      switch (mpu.getGyroRange()) {
      case MPU6050_RANGE_250_DEG:
        Serial.println("+- 250 deg/s");
        break;
      case MPU6050_RANGE_500_DEG:
        Serial.println("+- 500 deg/s");
        break;
      case MPU6050_RANGE_1000_DEG:
        Serial.println("+- 1000 deg/s");
        break;
      case MPU6050_RANGE_2000_DEG:
        Serial.println("+- 2000 deg/s");
        break;
      }
    
      mpu.setFilterBandwidth(MPU6050_BAND_21_HZ);
      Serial.print("Filter bandwidth set to: ");
      switch (mpu.getFilterBandwidth()) {
      case MPU6050_BAND_260_HZ:
        Serial.println("260 Hz");
        break;
      case MPU6050_BAND_184_HZ:
        Serial.println("184 Hz");
        break;
      case MPU6050_BAND_94_HZ:
        Serial.println("94 Hz");
        break;
      case MPU6050_BAND_44_HZ:
        Serial.println("44 Hz");
        break;
      case MPU6050_BAND_21_HZ:
        Serial.println("21 Hz");
        break;
      case MPU6050_BAND_10_HZ:
        Serial.println("10 Hz");
        break;
      case MPU6050_BAND_5_HZ:
        Serial.println("5 Hz");
        break;
      }
    
      Serial.println("");
      delay(100);
  //end accelerometer beginning stuff 
}



//Pulse Sensor
void PulseSensor(){
  
}

//Accelerometer
void Accelerometer() {
   /* Get new sensor events with the readings */
  sensors_event_t a, g, temp;
  mpu.getEvent(&a, &g, &temp);

  /* Print out the values */
  Serial.print(" Ax:");
  Serial.print(a.acceleration.x);
  Serial.print(" Ay:");
  Serial.print(a.acceleration.y);
  Serial.print(" Az:");
  Serial.print(a.acceleration.z);
  //Serial.println(" m/s^2");

  Serial.print(" Rx:");
  Serial.print(g.gyro.x);
  Serial.print(" Ry:");
  Serial.print(g.gyro.y);
  Serial.print(" Rz:");
  Serial.print(g.gyro.z);
  //Serial.println(" rad/s");

  Serial.println("");
}

//Capacitive Touch Sensor (TTP223B)
void CapTouchSensor() {
  touchValue = digitalRead(touchpin);
    if (touchValue == HIGH) {
    Serial.println("TOUCHED");
    touched = true;
  }
  if (touchValue == LOW) {
    Serial.println("NotTouched");
    touched = false;
  }
  delay(350);
}

//Vibration Motor
void vibrator() {
    digitalWrite(motor_control, HIGH);   
    delay(1000);                       // wait for a second
    digitalWrite(motor_control, LOW);   
    delay(1000);                       // wait for a second
}

//Battery Charger
void BatteryCharger() {
  
}

void loop() {
  CapTouchSensor();
  vibrator();
  Accelerometer();
}
