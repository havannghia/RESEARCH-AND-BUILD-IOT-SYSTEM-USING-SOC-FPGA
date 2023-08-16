#include <Wire.h>

void setup()
{
  Serial.begin(9600);
  Wire.begin(85);
  Wire.onReceive(receiveEvent);
  Wire.onRequest(requestEvent);
}

void loop()
{
}
void receiveEvent(int16_t  byteCount)
{
  while(Wire.available())
  {
    char c = Wire.read();
    Serial.println(c, HEX);

  }
}

void requestEvent()
{
    Wire.write(0x23);
    Serial.println("Master read");
}



