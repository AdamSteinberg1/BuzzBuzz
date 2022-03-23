TaskHandle_t currBuzzTask = NULL;

// Arduino like analogWrite
// value has to be between 0 and valueMax
void ledcAnalogWrite(uint8_t channel, uint32_t value, uint32_t valueMax = 255) 
{
  // calculate duty, 8191 from 2 ^ 13 - 1
  uint32_t duty = (8191 / valueMax) * min(value, valueMax);

  // write duty to LEDC
  ledcWrite(channel, duty);
}

void heartbeatVibrate(float bpm)
{
  static const float heartbeat[] = {12,45,84,124,163,195,220,236,249,253,255,251,245,235,226,218,216,214,209,197,183,167,159,154,150,146,150,156,163,169,178,183,183,177,174,172,169,162,155,145,135,121,109,100,93,82,70,61,56,50,47,46,46,39,33,29,28,27,29,32,36,37,38,39,40,37,34,27,25,23,24,22,18,12,8,5,7,9,15,19,16,5,0};  
  static const int n = sizeof(heartbeat)/sizeof(heartbeat[0]);
  const int period = 60000.0f/(n*bpm); //milliseconds
  static int i = 0;
  ledcAnalogWrite(LEDC_CHANNEL_0, heartbeat[i]*0.7);
  vTaskDelay(period / portTICK_PERIOD_MS);
  i=(i+1)%n;
}

void guidedBreathing(void * parameter)
{
  static const int breath[] = {50, -400, 50, -280, 50, -210, 50, -160, 60, -110, 60, -90, 50, -80, 60, -70, 60, -80, 50, -30, 10, -40, 60, -80, 50, -30, 10, -60, 50, -30, 10, -60, 50, -90, 60, -90, 60, -100, 50, -110, 60, -120, 70, -160, 50, -260, 60, -420, 50, -750, 50};
  for(;;) //infinite loop
  {
    for(int val : breath)
    {
      ledcAnalogWrite(LEDC_CHANNEL_0, std::signbit(val)?0:255);
      vTaskDelay(abs(val) / portTICK_PERIOD_MS);
    }
    ledcAnalogWrite(LEDC_CHANNEL_0, 0);
    vTaskDelay(4500 / portTICK_PERIOD_MS);
  }
}

void constHeartbeat(void * parameter)
{
  const float regularHeartrate = 70.0f;
  for(;;) //infinite loop
  {
    heartbeatVibrate(regularHeartrate);
  }
}


void decHeartbeat(void * parameter)
{
  const float rate = 1.0f; //amount for bpm to decrease by per second
  
  //last read heart rate
  //float hr = *((float*)heartCharacteristic->getData());
  float hr = 80.0f;
  for(;;)
  {
    auto start = millis();
    heartbeatVibrate(hr);
    auto duration = millis()-start;
    if(hr > 70.0f)
      hr -= 0.001*rate*duration;
    else if (hr < 70.0f)
      hr = 70.0f;
  }
    
}


void vibrate(int mode)
{
  static int currMode = 0;

  //if the mode isn't changing, don't do anything
  if(currMode == mode)
    return;

  currMode = mode;

  //stop whatever buzzing mode is happening
  if(currBuzzTask != NULL)
    vTaskDelete(currBuzzTask);

    
  switch(currMode)
  {
    case 0: //no vibration
      Serial.println("No vibration");
      ledcAnalogWrite(LEDC_CHANNEL_0, 0);
      break;
    case 1: //constant heartbeat
      Serial.println("Vibrate constant heartbeat");
      xTaskCreate(constHeartbeat, "Vibrate constant heartbeat", 8000, NULL, 1, &currBuzzTask);
      break;
    case 2: //decreasing heartbeat
      Serial.println("Vibrate decreasing heartbeat");
      xTaskCreate(decHeartbeat, "Vibrate decreasing heartbeat", 8000, NULL, 1, &currBuzzTask);
      break;
    case 3: 
      Serial.println("Vibrate guided breathing");
      xTaskCreate(guidedBreathing, "Vibrate guided breathing", 8000, NULL, 1, &currBuzzTask);
      break;
    default:
      Serial.println("Unknown vibration mode");
  }
}
