//pins
#define TOUCH_PIN D2  //capacitive touch sensor
#define MOTOR_PIN D7  //vibrator
#define HEART_PIN A0  //heart rate sensor

//defines for PWM
#define LEDC_CHANNEL_0     0

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
      Serial.print("Heart rate = ");
      Serial.println(hr);
    }
    vTaskDelay(1000.0/(PPG_SAMPLING_RATE * portTICK_PERIOD_MS));
  }
}


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

void constHeartbeat(void * parameter)
{
  const float regularHeartrate = 70.0f;
  for(;;) //infinite loop
  {
    heartbeatVibrate(regularHeartrate);
  }
}

TaskHandle_t currBuzzTask = NULL;

void setup() {
  Serial.begin(115200);
  pinMode(TOUCH_PIN, INPUT);   //capacitive touch sensor
  pinMode(HEART_PIN, INPUT);   //ppg sensor
  pinMode(LED_BUILTIN, OUTPUT);
  
    // Setup timer and attach timer to motor pin
  ledcSetup(LEDC_CHANNEL_0, 5000, 13);
  ledcAttachPin(MOTOR_PIN, LEDC_CHANNEL_0);

  //xTaskCreate(sendHeartrate, "Send Heartrate", 8000, NULL, 1, NULL);
  xTaskCreate(constHeartbeat, "Vibrate constant heartbeat", 8000, NULL, 1, &currBuzzTask);
  digitalWrite(LED_BUILTIN, HIGH);


}

void loop()
{
  static const int onTime = 1;
  static const int offTime = 5;
  
  vTaskDelay(onTime*60*1000/portTICK_PERIOD_MS);
  vTaskSuspend(currBuzzTask);
  ledcAnalogWrite(LEDC_CHANNEL_0, 0);
  Serial.println("Off");
  digitalWrite(LED_BUILTIN, LOW);
  vTaskDelay(offTime*60*1000/portTICK_PERIOD_MS);
  vTaskResume(currBuzzTask);
  Serial.println("On");
  digitalWrite(LED_BUILTIN, HIGH);
}
