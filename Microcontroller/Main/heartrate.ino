#define PPG_SAMPLING_RATE 250 //Hz

//2nd order bandpass butterworth filter from 0.4Hz-4Hz
float filter(float x)
{
  static float v[] = {0.0f, 0.0f, 0.0f, 0.0f, 0.0f};
  v[0] = v[1];
  v[1] = v[2];
  v[2] = v[3];
  v[3] = v[4];
  v[4] = (1.948990633217252992e-3 * x)
     + (-0.87989313724757045598 * v[0])
     + (3.63015359772365897584 * v[1])
     + (-5.62050728461365700639 * v[2])
     + (3.87024586488467736700 * v[3]);
  return (v[0] + v[4]) - 2 * v[2];
}

float heartrate()
{
  float val = filter(analogRead(HEART_PIN));
  const float threshold = 0.0f; //if val crosses this, considered a heartbeat
  static int num_samples = 0;    //number of samples since last heartbeat 
  static float heartrate =0.0f;
  static float lastVal=0.0f;

  num_samples++;
  if(val >= threshold && lastVal < threshold) //if we cross threshold
  {
    float tmp = (PPG_SAMPLING_RATE*60.0f)/num_samples; //calculate a heartrate
    if(tmp < 24.0f)       //if heartrate is too low
    {
      num_samples=0;
    }
    else if(tmp < 240.0f) //if heartrate is not too high
    {
      heartrate=tmp;
      num_samples=0;
    }
  }

  lastVal=val;
  return heartrate;
}

float boxcarAvg(float x)
{
  const int max_size = 3;
  static float boxcar[max_size];
  static int size = 0;
  static int index = 0;
  
  size = min(size+1, max_size);
  boxcar[index] = x;
  index=(index+1)%max_size;

  float sum = 0.0f;
  for(int i =0; i < size; i++)
  {
    sum+=boxcar[i];
  }
  return sum/size;  
}


void sendHeartrate(void * parameter)
{  
  float prev = 0;
  for(;;) //infinite loop
  { 
    float reading = heartrate();
    if(reading != prev) //if heartrate has changed
    {
      prev=reading;
      float hr = boxcarAvg(reading);
      heartCharacteristic->setValue(hr);
      heartCharacteristic->notify();
      Serial.print("Heart rate = ");
      Serial.println(hr);
    }
    vTaskDelay(1000.0/(PPG_SAMPLING_RATE * portTICK_PERIOD_MS));
  }
}
