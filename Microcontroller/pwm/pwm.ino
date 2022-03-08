#include <cmath>

// use first channel of 16 channels (started from zero)
#define LEDC_CHANNEL_0     0

// use 13 bit precission for LEDC timer
#define LEDC_TIMER_13_BIT  13

// use 5000 Hz as a LEDC base frequency
#define LEDC_BASE_FREQ     5000


#define PWM_PIN            D2
// Arduino like analogWrite
// value has to be between 0 and valueMax
void ledcAnalogWrite(uint8_t channel, uint32_t value, uint32_t valueMax = 255) {
  // calculate duty, 8191 from 2 ^ 13 - 1
  uint32_t duty = (8191 / valueMax) * min(value, valueMax);

  // write duty to LEDC
  ledcWrite(channel, duty);
}

void setup() {
  Serial.begin(115200);
  // Setup timer and attach timer to a led pin
  ledcSetup(LEDC_CHANNEL_0, LEDC_BASE_FREQ, LEDC_TIMER_13_BIT);
  ledcAttachPin(PWM_PIN, LEDC_CHANNEL_0);
}

void heartbeatVibrate(float bpm)
{
  static const float heartbeat[] = {12,45,84,124,163,195,220,236,249,253,255,251,245,235,226,218,216,214,209,197,183,167,159,154,150,146,150,156,163,169,178,183,183,177,174,172,169,162,155,145,135,121,109,100,93,82,70,61,56,50,47,46,46,39,33,29,28,27,29,32,36,37,38,39,40,37,34,27,25,23,24,22,18,12,8,5,7,9,15,19,16,5,0};  
  static const int n = sizeof(heartbeat)/sizeof(heartbeat[0]);
  const int period = 60000.0f/(n*bpm); //milliseconds
  static int i = 0;
  ledcAnalogWrite(LEDC_CHANNEL_0, heartbeat[i]);
  delay(period);
  i=(i+1)%n;
}

void breatheVibrate()
{
  static const int breath[] = {5, -40, 5, -28, 5, -21, 5, -16, 6, -11, 6, -9, 5, -8, 6, -7, 6, -8, 5, -3, 1, -4, 6, -8, 5, -3, 1, -6, 5, -3, 1, -6, 5, -9, 6, -9, 6, -10, 5, -11, 6, -12, 7, -16, 5, -26, 6, -42, 5, -75, 5};
  for(int val : breath)
  {
    ledcAnalogWrite(LEDC_CHANNEL_0, std::signbit(val)?0:255);
    delay(abs(val)*10);
  }
  ledcAnalogWrite(LEDC_CHANNEL_0, 0);
  delay(4500);
}

void loop() 
{
  static float t=0.0f;
  t+=0.001;
  float bpm = 60.0f + 20.0f*sin(t);
  Serial.println(bpm);
  heartbeatVibrate(bpm);
}
