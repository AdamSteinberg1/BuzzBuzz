#define motor_control 2

void setup() {
  // initialize digital pin LED_BUILTIN as an output.
   Serial.begin(115200);
   pinMode(D2, OUTPUT);
   pinMode(D3, OUTPUT);
   pinMode(D4, OUTPUT);
   pinMode(D7, OUTPUT); 
   pinMode(2, OUTPUT);
}

// the loop function runs over and over again forever
void loop() {
    int i = D2;
    Serial.println(i);
    digitalWrite(i, HIGH);   // turn the LED on (HIGH is the voltage level)
    digitalWrite(2, HIGH);   // turn the LED on (HIGH is the voltage level)
    delay(1000);                       // wait for a second
    digitalWrite(i, LOW);    // turn the LED off by making the voltage LOW
    digitalWrite(2, LOW);   // turn the LED on (HIGH is the voltage level)
    delay(1000);                       // wait for a second
}
