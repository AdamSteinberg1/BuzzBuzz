#define PPG_SAMPLING_PERIOD 8 //in milliseconds

float calcThreshold(float val)
{
  const int size = 128;
  static float samples[size];
  static int i=0;
  samples[i]=abs(val);
  i=(i+1)%size;

  float sum = 0.0;
  for(int j=0; j<size; j++)
  {
    sum += samples[j];
  }
  float avg = sum/size;
  return avg*1.5;
}

float heartrate()
{
  static FilterBuBp4 filter;
  float val = filter.step(analogRead(HEART_PIN));
  const float threshold = calcThreshold(val); //if val crosses this, considered a heartbeat
  static int num_samples = 0;    //number of samples since last heartbeat 
  static float heartrate =0;
  static float lastVal=0;
  Serial.print(threshold);
  Serial.print("\t");

  num_samples++;
  if(val >= threshold && lastVal < threshold)
  {
    float tmp = 60.0f/(num_samples*PPG_SAMPLING_PERIOD*0.001);
    if(tmp > 24.0f && tmp < 240.0f)
    {
      heartrate = tmp;
      num_samples = 0; 
    }
    heartrate=tmp;
    num_samples=0;
  }

  lastVal=val;
  return heartrate;
}

void sendHeartrate(void * parameter)
{  
  for(;;) //infinite loop
  { 
    auto hr = heartrate();
        
    vTaskDelay(PPG_SAMPLING_PERIOD / portTICK_PERIOD_MS);
  }
}
