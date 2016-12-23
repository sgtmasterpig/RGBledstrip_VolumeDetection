import controlP5.*;
import ddf.minim.analysis.*;
import ddf.minim.*;
import ddf.minim.signals.*;
import processing.serial.*;  



Minim minim;
AudioInput input;
FFT fft;
BeatDetect beat;
BeatListener bl;
Serial myPort;
ControlP5 cp5;


int fft_base_freq = 86;
int fft_band_per_oct = 1;
int numZones = 0;
int yPos = 270;
float S;
float H;
float V;
float Hdrift;
float eRadius;
float avg1;
float avg2;
int Beatdetection;
int volorbass;
float volbrightness = 1;
int d = 20;

Slider h;
Slider s;
Slider b;
Slider hdrift;
Slider BeatDetection;
Slider VolumeOrBass;
Slider Volbrightness;


void setup()
{
  cp5 = new ControlP5(this);
  h = cp5.addSlider("Color", -1,359,0,600,290,200,30);
  H = h.getValue();
  s = cp5.addSlider("Saturation", 0,1,1,600,330,200,30);
  b = cp5.addSlider("Brightness", 0,1,0,600,370,200,30);
  hdrift = cp5.addSlider("Color Drift", -9,9,0,600,410,200,30);
  Hdrift = hdrift.getValue();
  BeatDetection = cp5.addSlider("Beatdetection",0,1,50,50,20,30);
  VolumeOrBass = cp5.addSlider("volorbass",0,1,50,100,20,30);
  Volbrightness = cp5.addSlider("volbrightness",1,3,100,100,20,30);
  
  String portName = Serial.list()[1]; //0 = COM1, 1= COM2...
  myPort = new Serial(this, portName, 9600);
  size(960, 540, P3D);
  surface.setResizable(true);
  textMode(SCREEN); 
  minim = new Minim(this);
  input = minim.getLineIn(Minim.STEREO, 2048); 
  fft = new FFT(input.bufferSize(), input.sampleRate()); 
  beat = new BeatDetect();
  beat.setSensitivity(300); 
  bl = new BeatListener(beat, input);  
  
  fft.logAverages(fft_base_freq, fft_band_per_oct);
  fft.window(FFT.HAMMING);
  numZones = fft.avgSize();
  ellipseMode(RADIUS);
  eRadius = 20;
  
  
}

class BeatListener implements AudioListener
{
  private BeatDetect beat;
  private AudioInput source;
  
  BeatListener(BeatDetect beat, AudioInput source)
  {
    this.source = source;
    this.source.addListener(this);
    this.beat = beat;
  }
  
  void samples(float[] samps)
  {
    beat.detect(source.mix);
  }
  
  void samples(float[] sampsL, float[] sampsR)
  {
    beat.detect(source.mix);
  }
}

void draw()
{
    S = s.getValue();
    V = b.getValue();
  
  background(0);
  stroke(255);
  fft.forward(input.mix);
  noStroke();
  fill(255,0,0);
  ellipse(200,50,d,d);
  fill(255,60,0);
  ellipse(200,100,d,d);
  fill(255,120,0);
  ellipse(200,150,d,d);
  fill(255,180,0);
  ellipse(200,200,d,d);
  fill(255,255,0);
  ellipse(200,250,d,d);

  fill(0,255,0);
  ellipse(250,50,d,d);
  fill(0,220,60);
  ellipse(250,100,d,d);
  fill(0,200,120);
  ellipse(250,150,d,d);
  fill(0,180,180);
  ellipse(250,200,d,d);
  fill(0,100,255);
  ellipse(250,250,d,d);
  
  fill(0,0,255);
  ellipse(300,50,d,d);
  fill(60,0,255);
  ellipse(300,100,d,d);
  fill(120,0,255);
  ellipse(300,150,d,d);
  fill(180,0,255);
  ellipse(300,200,d,d);  
  fill(255,0,255);
  ellipse(300,250,d,d);

    if( Beatdetection == 1){
      
      int highZone = numZones - 1;
      for (int i = 0; i < numZones; i++)
      {
      float average = fft.getAvg(i);
      float avg = 0;
      int lowFreq;
    
      if ( i == 0 )
        {
        lowFreq = 0;
        } 
      else
        {
        lowFreq = (int)((input.sampleRate()/2) / (float)Math.pow(2, numZones - i));
        }
    
      int hiFreq = (int)((input.sampleRate()/2) / (float)Math.pow(2, highZone - i));
      int lowBound = fft.freqToIndex(lowFreq);
      int hiBound = fft.freqToIndex(hiFreq);

      for (int j = lowBound; j <= hiBound; j++)
        {
        float spectrum = fft.getBand(j);
        avg += spectrum;
        }
    
      avg /= (hiBound - lowBound + 1);
      average = avg * 1.5;    
      rectMode(CORNER);
      stroke(255,0,0);
      
      if (i == 0)
      {
        
        fill(255,0,0);
        rect(0, height -average, width/9, average);
        //println(average);
        //save first value for low bass in avg1
        if(volorbass == 1){
          average = map(average,20,350,0.2,1);
          avg1 = average;
          
        }
      }
  
      if (i == 1) 
      { 
      fill(255,0,0);
      rect(width*1/9, height-average, width/9, average);
      //save 2nd value for higher bass value in avg2 and transmit to brightness level
      if(volorbass == 1) {
        average = map(average,20,350,0.2,1);
        avg2 = average;
        float avgbass = (avg1+avg2)/2;
        b.setValue(avgbass*volbrightness);
        }

      }  
        
      if (i == 2) 
      { 
      fill(255,0,0);
      rect(width*2/9, height-average, width/9, average);
      }
      
      if (i == 3) 
      { 
      fill(255,0,0);
      rect(width*3/9, height-average, width/9, average);
      }
      
      if (i == 4)
      { 
      fill(255,0,0);
      rect(width*4/9, height-average, width/9, average);
      }
      
      if (i == 5)
      { 
      fill(255,0,0);
      rect(width*5/9, height-average, width/9, average);
      }
    
      if (i == 6) 
      { 
      fill(255,0,0);
      rect(width*6/9, height-average, width/9, average);
      }
    
      if (i == 7) 
      { 
      fill(255,0,0);
      rect(width*7/9, height-average, width/9, average);
      }
      
      if (i == 8)
      { 
      fill(255,0,0);
      rect(width*8/9, height-average, width/9, average);
      }     
      
      Float Volume = (input.left.level() + input.right.level())/2;
      //rectMode(RADIUS);
      Volume = map(Volume,0,0.5,0.25,0.8);
      //rect(300,50,Volume*50, Volume*50);
      if(volorbass == 0) {
        b.setValue(Volume*volbrightness);
        }
      
    }  
  }
  
  
  //inputs nemen voor output  RGB waarde (hierna niets van gui stuff) 
  V = b.getValue();
  h.setValue(h.getValue()+hdrift.getValue());
  H = h.getValue();
  if( H == 359) h.setValue(0);
  if(H == -1) h.setValue(359);  

  float X=0;
  float m=0;
  float RR = 0;
  float GG = 0;
  float BB = 0;
  float C;
  float R,B,G;

  //Conversie HSB to RGB
  C = V * S;
  X = (C) * (1- (abs(((H/60)%2)-1)));
  m = V - C;
  
  if(H < 60) {RR= C;GG = X; BB = 0; }
  if(H < 120 && H > 60){RR= X;GG = C; BB = 0; }
  if(H < 180 && H > 120){RR= 0;GG = C; BB = X; }
  if(H < 240 && H > 180){RR= 0;GG = X; BB = C; }
  if(H < 300 && H > 240){RR= X;GG = 0; BB = C; }
  if(H < 360 && H > 300){RR= C;GG = 0; BB = X; }
  
  
  R= (RR+(m))*255;
  G= (GG+(m))*255;
  B= (BB+(m))*255;
  fill(R,G,B);
  noStroke();
  ellipse(700,150,100,100);
  
  //println(frameRate);
  println("S",int(R),int(G),int(B));
  

  setRGB(int(R),int(G),int(B),0);

 
}


void setRGB (int red , int green, int blue, int led) {
 myPort.write('S'); 
 myPort.write(red); 
 myPort.write(green); 
 myPort.write(blue); 
 myPort.write(led); 
 
}
 