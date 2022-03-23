//pins
#define TOUCH_PIN D2  //capacitive touch sensor
#define MOTOR_PIN D7  //vibrator
#define HEART_PIN A0  //heart rate sensor

void setup() {
  pinMode(TOUCH_PIN, INPUT);   //capacitive touch sensor
  pinMode(HEART_PIN, INPUT);   //ppg sensor
  pinMode(MOTOR_PIN, OUTPUT);  //vibration motor

  //turn on motor
  digitalWrite(MOTOR_PIN, HIGH);
}

void loop()
{
  static double x=0;
  x = cos(x);

  auto touch = digitalRead(TOUCH_PIN);
  auto heart = analogRead(HEART_PIN);
}
