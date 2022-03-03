#include <Arduino_Helpers.h> //https://github.com/tttapa/Arduino-Helpers
#include <AH/Timing/MillisMicrosTimer.hpp>

#define HEART_PIN A0

//http://www.schwietering.com/jayduino/filtuino/
//Band pass butterworth filter order=2 alpha1=0.0032 alpha2=0.032 
/*
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
*/
//Band pass butterworth filter order=2 alpha1=0.0016 alpha2=0.016 
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
      v[4] = (1.948990633217252992e-3 * x)
         + (-0.87989313724757045598 * v[0])
         + (3.63015359772365897584 * v[1])
         + (-5.62050728461365700639 * v[2])
         + (3.87024586488467736700 * v[3]);
      return 
         (v[0] + v[4])
        - 2 * v[2];
    }
};

//Low pass butterworth filter order=2 alpha1=0.016 
class  FilterBuLp2
{
  public:
    FilterBuLp2()
    {
      v[0]=0.0;
      v[1]=0.0;
      v[2]=0.0;
    }
  private:
    float v[3];
  public:
    float step(float x) //class II 
    {
      v[0] = v[1];
      v[1] = v[2];
      v[2] = (2.357208772852337209e-3 * x)
         + (-0.86747213379166820957 * v[0])
         + (1.85804329870025886073 * v[1]);
      return 
         (v[0] + v[2])
        +2 * v[1];
    }
};


FilterBuBp2 f;
Timer<millis> timer = 4; // milliseconds

float calcThreshold(float val)
{
  const int size = 512;
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
  return avg*1.2;
}

float heartrate(float val)
{
  const float threshold = 0.0f; //calcThreshold(val); //if val crosses this, considered a heartbeat
  //Serial.print(threshold);
  //Serial.print("\t");
  static int num_samples = 0;    //number of samples since last heartbeat 
  static float heartrate =0;
  static float lastVal=0;
  //Serial.print(threshold);
  //Serial.print("\t");

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
    //Serial.print(heartval);
    //Serial.print("\t");
    heartval = f.step(heartval);
    auto hr = heartrate(heartval);
    Serial.print(heartval);
    Serial.print("\t");
    Serial.print(hr);
    Serial.println();       
  }
}
