#define touchPin D3
//TTP223B 
void setup() {
  Serial.begin(9600);
  pinMode(touchPin, INPUT);
}
 
void loop() {
  int touchValue = digitalRead(touchPin);
  if (touchValue == HIGH) {
    Serial.println("TOUCHED");
  }
  if (touchValue == LOW) {
    Serial.println("NotTouched");
  }
  delay(350);
}
