#include <Wire.h>
void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  Wire.begin();
}
int i = 0;
void loop() {
  // put your main code here, to run repeatedly:
  /*
  //write data to OpenCore's Slave
  Wire.beginTransmission(85);//85 = 0x55
  Wire.write(2);//reg
  Wire.write(i);//data
  Wire.endTransmission();
  Serial.print("Write: ");
  Serial.println(i, HEX);
  delay(2000);
  i++;
  */
  //Read data from OpenCore's Slave
  Wire.beginTransmission(85);//85 = 0x55
  Wire.write(i);//reg
  //Wire.endTransmission();
  Wire.requestFrom(85,1);
  if (Wire.available())
  {
    char c = Wire.read();
    Serial.println(c, HEX);
    i++;
  }
  if (i == 255)
  {
    i = 0;
  }
  delay(3000);
}
