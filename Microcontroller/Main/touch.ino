void onTouch()
{
  auto touch = digitalRead(TOUCH_PIN);
  touchCharacteristic->setValue(touch);
  touchCharacteristic->notify();
  Serial.print("Touched = ");
  Serial.println(touch);
}
