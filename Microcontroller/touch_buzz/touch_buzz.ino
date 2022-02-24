#define motor_control D2
#define touchpin D3 
void setup() {
  // initialize digital pin LED_BUILTIN as an output.
   Serial.begin(115200);
   pinMode(motor_control, OUTPUT);
   pinMode(touchpin, INPUT);   //capacitive touch sensor   
}

// the loop function runs over and over again forever
void loop() {
    if(digitalRead(touchpin)==HIGH)
      digitalWrite(motor_control, HIGH);   
    else
      digitalWrite(motor_control, LOW);
}
