import java.util.*;
import java.text.*;
import processing.serial.*;

PrintWriter output;
DateFormat fnameFormat= new SimpleDateFormat("yyMMdd_HHmm");
DateFormat timeFormat = new SimpleDateFormat("hh:mm:ss.SSS");
DateFormat millisFormat = new SimpleDateFormat("ss.SSS");
String fileName;
Serial myPort;          
char HEADER = 'H';
float[] val=new float[1];
int xpos=1;
float inbyte=0;
int lastxpos=1;
int lastheight=0;

void setup()
{
  size(1440,600);
  String portName = Serial.list()[3];
  println(Serial.list());
  println(" Connecting to -> " + Serial.list()[3]);
  myPort = new Serial(this, portName, 115200);
  Date now = new Date();
  fileName = fnameFormat.format(now);
  output = createWriter(fileName + ".txt");
  myPort.clear();
  myPort.bufferUntil('\n');
  background(255); //initial white backg
}

void draw()
{
  output.println();
  String timeString = millisFormat.format(new Date());
  output.print(timeString);
  output.print('/');
  for(int i=0;i<1;i++)
  {
    output.print(val[i]);
  }
    stroke(1,34,255); //last color: 127,34,255
    strokeWeight(4);
    line(xpos,lastheight,xpos,height-inbyte);
    lastxpos=xpos;
    lastheight=int(height-inbyte);
    if(xpos>=width)
    {
      xpos=0;
      lastxpos=0;
      background(255); //white backg
    }
    else
    {
      xpos++;
    }
}

void keyPressed() 
{
  output.flush(); 
  output.close();
  exit(); 
}

void serialEvent(Serial myport)
{
  String inString=myport.readStringUntil('\n');
  if(inString!=null)
  {
    inString=trim(inString);
    float incomingval[]=float(split(inString,"\t"));
    if(incomingval.length<=1 && incomingval.length>0)
    {
      for(int i=0;i<incomingval.length;i++)
      {
        val[i]=incomingval[i];
      }
    }
    inbyte=float(inString);
    inbyte=map(inbyte,0,10,0,height);
  }
}
