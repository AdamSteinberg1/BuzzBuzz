#include <Arduino_Helpers.h> //https://github.com/tttapa/Arduino-Helpers
#include <AH/Timing/MillisMicrosTimer.hpp>

#define HEART_PIN A0

//http://www.schwietering.com/jayduino/filtuino/
//Band pass butterworth filter order=2 alpha1=0.0032 alpha2=0.032 
class  FilterBuBp2
{
  public:
    FilterBuBp2()
    {
      for(int i=0; i <= 4; i++)
        v[i]=0.0;
    }
  private:
    float v[5];
  public:
    float step(float x) //class II 
    {
      v[0] = v[1];
      v[1] = v[2];
      v[2] = v[3];
      v[3] = v[4];
      v[4] = (7.341658834256903181e-3 * x)
         + (-0.77421695285500158334 * v[0])
         + (3.28700821082246630311 * v[1])
         + (-5.25046507275355889277 * v[2])
         + (3.73765936644686647128 * v[3]);
      return 
         (v[0] + v[4])
        - 2 * v[2];
    }
};

FilterBuBp2 f;
Timer<millis> timer = 8; // milliseconds

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

float heartrate(float val)
{
  const float threshold = calcThreshold(val); //if val crosses this, considered a heartbeat
  static int num_samples = 0;    //number of samples since last heartbeat 
  static float heartrate =0;
  static float lastVal=0;
  Serial.print(threshold);
  Serial.print("\t");

  num_samples++;
  if(val >= threshold && lastVal < threshold)
  {
    float tmp = 60.0f/(num_samples*timer.getInterval()*0.001);
    heartrate=tmp;
    num_samples=0;
  }

  lastVal=val;
  return heartrate;
}

void setup() 
{
   pinMode(HEART_PIN,INPUT);  
   Serial.begin(115200);
}

// The Main Loop Function
void loop() 
{
  if (timer)
  {
    float heartval = analogRead(HEART_PIN); 
    heartval = f.step(heartval);
    auto hr = heartrate(heartval);
    Serial.print(heartval);
    Serial.print("\t");
    Serial.println(hr);        
  }
}
