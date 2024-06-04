#include <Servo.h>

Servo servo1, servo2;
int pos = 90; 

void setup() {
  servo1.attach(9); 
  servo2.attach(10);
  servo1.write(pos);
  servo2.write(pos);
}

void loop() {
  for (pos = 55; pos <= 125; pos += 1) {
    servo1.write(pos);
    servo2.write(pos);
    delay(15);         
  }
  for (pos = 125; pos >= 55; pos -= 1) {
    servo1.write(pos);  
    servo2.write(pos);  
    delay(15);           
  }
}
