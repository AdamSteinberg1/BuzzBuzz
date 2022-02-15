#define HEART_PIN A0

//Band pass chebyshev filter order=4 alpha1=0.01 alpha2=0.1 
class  FilterChBp4
{
  public:
    FilterChBp4()
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
      v[8] = (6.990708473643422001e-4 * x)
         + (-0.72022844834803867453 * v[0])
         + (5.63973671715499857982 * v[1])
         + (-19.66547798469508023800 * v[2])
         + (39.89581147478009626184 * v[3])
         + (-51.51278805671013572010 * v[4])
         + (43.34634793515346018467 * v[5])
         + (-23.20699764422411703890 * v[6])
         + (7.22359391733537758995 * v[7]);
      return 
         (v[0] + v[8])
        - 4 * (v[2] + v[6])
        +6 * v[4];
    }
};

FilterChBp4 f;
void setup() {
   pinMode(HEART_PIN,INPUT);    
   Serial.begin(115200);

}

// The Main Loop Function
void loop() 
{
  float heartval = analogRead(HEART_PIN); 
  float filtered = f.step(heartval);
  Serial.println(filtered);                   
  delay(10);
}
