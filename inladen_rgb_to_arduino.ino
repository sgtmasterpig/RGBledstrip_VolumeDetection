
char val; // Data received from the serial port
int led;
int red, green, blue;

#define REDPIN 11
#define GREENPIN 9
#define BLUEPIN 10

void setup()
{
  Serial.begin(9600); // Start serial communication at 9600 bps
  pinMode(REDPIN, OUTPUT);
  pinMode(GREENPIN, OUTPUT);
  pinMode(BLUEPIN, OUTPUT);
       
}

void loop()
{


  
if (Serial.available()) {             // If data is available to read,
  val = Serial.read();                // read it and store it in val
  

  if (val == 'S') {Serial.write("start");                   //If start char is recieved,
    while (!Serial.available()) {}    //Wait until next value.
    red = Serial.read();              //Once available, assign.
Serial.write("start");
    while (!Serial.available()) {}    //Same as above.
    green = Serial.read();
    Serial.write(green);
    while (!Serial.available()) {}
    blue = Serial.read();

    while (!Serial.available()) {}
    led = Serial.read();
    setRGB(red, green, blue, led);
    }
    analogWrite(REDPIN, red);
    analogWrite(GREENPIN, green);
    analogWrite(BLUEPIN, blue);
}

}

void setRGB(uint8_t red, uint8_t green, uint8_t blue, uint8_t led){
 


}
