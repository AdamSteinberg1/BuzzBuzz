/*
  Blink Test

  Turns an LED on for one second, then off for one second, repeatedly.
  http://www.arduino.cc/en/Tutorial/Blink
*/

//pin 2 is the onboard LED for ESP32
#define LED_BUILTIN 2

// the setup function runs once when you press reset or power the board
void setup() {
  // initialize digital pin LED_BUILTIN as an output.
  pinMode(LED_BUILTIN, OUTPUT);
}

// the loop function runs over and over again forever
void loop() {
  digitalWrite(LED_BUILTIN, HIGH);   // turn the LED on (HIGH is the voltage level)
  delay(5000);                       // wait for a second
  digitalWrite(LED_BUILTIN, LOW);    // turn the LED off by making the voltage LOW
  delay(1000);                       // wait for a second
}
