#include <PeakDetection.h>
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


//Band pass butterworth filter order=4 alpha1=0.0032 alpha2=0.032 
class  FilterBuBp4
{
  public:
    FilterBuBp4()
    {
      for(int i=0; i <= 8; i++)
        v[i]=0.0;
    }
  private:
    float v[9];
  public:
    float step(float x) //class II 
    {
      v[0] = v[1];
      v[1] = v[2];
      v[2] = v[3];
      v[3] = v[4];
      v[4] = v[5];
      v[5] = v[6];
      v[6] = v[7];
      v[7] = v[8];
      v[8] = (5.348593628400667856e-5 * x)
         + (-0.62274482260825803071 * v[0])
         + (5.26554689556619948121 * v[1])
         + (-19.50037760703271771945 * v[2])
         + (41.31320176261429821807 * v[3])
         + (-54.76383502861359886538 * v[4])
         + (46.51050681663608088456 * v[5])
         + (-24.71449515360401605335 * v[6])
         + (7.51219713682921774733 * v[7]);
      return 
         (v[0] + v[8])
        - 4 * (v[2] + v[6])
        +6 * v[4];
    }
};

//High pass butterworth filter order=2 alpha1=0.0032 
class  FilterBuHp2
{
  public:
    FilterBuHp2()
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
      v[2] = (9.858833571126852657e-1 * x)
         + (-0.97196600376085784401 * v[0])
         + (1.97156742468988244177 * v[1]);
      return 
         (v[0] + v[2])
        - 2 * v[1];
    }
};





FilterBuBp2 f;
Timer<millis> timer = 8; // milliseconds
PeakDetection peakDetection; // create PeakDetection object

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
    /*
    if(tmp > 24.0f && tmp < 240.0f)
    {
      heartrate = tmp;
      num_samples = 0; 
    }
    */
    heartrate=tmp;
    num_samples=0;
  }

  lastVal=val;
  return heartrate;
}

float derivative(float val)
{
  static float lastVal=0;
  const float diff = val-lastVal;  
  lastVal=val;
  return diff/(timer.getInterval()*0.001);
}

void setup() {
   pinMode(HEART_PIN,INPUT);  
   Serial.begin(115200);
   peakDetection.begin(100, 2.6, 0); // sets the lag, threshold and influence
}

// The Main Loop Function
void loop() 
{
  if (timer)
  {
    float heartval = analogRead(HEART_PIN); 
    heartval = f.step(heartval);
    //peakDetection.add(heartval);
    auto hr = heartrate(heartval);
    //Serial.print(25*peakDetection.getPeak());
    //Serial.print(hr);
    Serial.print("\t");
    Serial.println(heartval);        
  }
}
