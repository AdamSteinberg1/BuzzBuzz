#define motor_control D2

void setup() {
  // initialize digital pin LED_BUILTIN as an output.
   Serial.begin(115200);
   pinMode(motor_control, OUTPUT);
   
}

// the loop function runs over and over again forever
void loop() {
    digitalWrite(motor_control, HIGH);   
    delay(1000);                       // wait for a second
    digitalWrite(motor_control, LOW);   
    delay(1000);                       // wait for a second
}
