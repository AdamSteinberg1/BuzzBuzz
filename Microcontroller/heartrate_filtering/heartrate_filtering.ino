#define HEART_PIN A0

//Band pass chebyshev filter order=4 alpha1=0.01 alpha2=0.1 
class filter
{
  public:
    filter()
    {
      for(int i=0; i <= 8; i++)
        v[i]=0;
    }
  private:
    short v[9];
  public:
    short step(short x)
    {
      v[0] = v[1];
      v[1] = v[2];
      v[2] = v[3];
      v[3] = v[4];
      v[4] = v[5];
      v[5] = v[6];
      v[6] = v[7];
      v[7] = v[8];
      long tmp = ((((x * 375311L) >> 16)  //= (   6.9907084736e-4 * x)
        + ((v[0] * -377607L) >> 6)  //+( -0.7202284483*v[0])
        + ((v[1] * 369606L) >> 3) //+(  5.6397367172*v[1])
        + ((v[2] * -322199L) >> 1)  //+(-19.6654779847*v[2])
        + (v[3] * 326826L)  //+( 39.8958114748*v[3])
        + (v[4] * -421993L) //+(-51.5127880567*v[4])
        + (v[5] * 355093L)  //+( 43.3463479352*v[5])
        + ((v[6] * -380223L) >> 1)  //+(-23.2069976442*v[6])
        + ((v[7] * 473405L) >> 3) //+(  7.2235939173*v[7])
        )+4096) >> 13; // round and downshift fixed point /8192

      v[8]= (short)tmp;
      return (short)((/* xpart */
         (((v[0] + v[8]))<<14) /* 262144L (^2)*/
         - (((v[2] + v[6]))<<16) /* -262144L (^2)*/
         + (393216L * v[4])
        )
+32768) >> 16; // round and downshift fixed point

    }
};

filter f;
void setup() {
   pinMode(HEART_PIN,INPUT);    
   Serial.begin(115200);

}

// The Main Loop Function
void loop() 
{
  short heartval = analogRead(HEART_PIN); 
  short filtered = f.step(heartval);
  Serial.println(filtered);                   
  delay(10);
}
