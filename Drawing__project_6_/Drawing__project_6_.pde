import SimpleOpenNI.*;
SimpleOpenNI kinect;
int closestValue;
int closestX;
int closestY;
float lastX;
float lastY;
ArrayList<FloatList> lines = new ArrayList();

void setup()
{
 size(640, 480);
 kinect = new SimpleOpenNI(this);
 kinect.enableDepth();
}

void draw()
{
 closestValue = 8000;
 
 kinect.update();
 
 int[] depthValues = kinect.depthMap();
 
 for(int y = 0; y < 480; y++){
   for(int x = 0; x < 640; x++){ 
     // reverse x by moving in from
     // the right side of the image
     
     int reversedX = 640-x-1; 
     // use reversedX to calculate
     // the array index
     
     int i = reversedX + y * 640;
     
     int currentDepthValue = depthValues[i];
 // only look for the closestValue within a range
 // 610 (or 2 feet) is the minimum
 // 1525 (or 5 feet) is the maximum
     if(currentDepthValue > 610 && currentDepthValue < 1525 
           && currentDepthValue < closestValue){
         closestValue = currentDepthValue;
         closestX = x;
         closestY = y;
      }
     }
   }
    image(kinect.depthImage(),0,0);
  for(int L = 0; L < lines.size(); L++){
//    print(lines[L][0]);
//    line(lines[L][0], lines[L][1], lines[L][2], lines[L][3]);
  }

   
   
 // "linear interpolation", i.e.
 // smooth transition between last point
 // and new closest point
 

 
 float interpolatedX = lerp(lastX, closestX, 0.3f); 
 float interpolatedY = lerp(lastY, closestY, 0.3f);
 stroke(255,0,0);
 // make a thicker line, which looks nicer
 strokeWeight(3);
 line(lastX, lastY, interpolatedX, interpolatedY); 
 FloatList line = new FloatList();
  line.append(lastX);
  line.append(lastY);
  line.append(interpolatedX);
  line.append(interpolatedY);
  lines.add(line);
 lastX = interpolatedX;
 lastY = interpolatedY;
}
void mousePressed(){
 // save image to a file
 // then clear it on the screen
 save("drawing.png");
// background(0);
}

