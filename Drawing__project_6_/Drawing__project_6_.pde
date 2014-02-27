import SimpleOpenNI.*;
SimpleOpenNI kinect;
int closestValue;
int closestX;
int closestY;
float lastX;
float lastY;

//** CREATE ARRAYLIST OF A LIST OF FLOATS **
//** TO STORE LINES ALREADY DRAWN AND **
//** REDRAW ONTOP OF DEPTH IMAGE **
ArrayList<FloatList> lines = new ArrayList();

//** THESE VARIABLES ARE FOR PICKING UP AND **
//** PUTTING DOWN THE "PEN" **
boolean freeze = false; // PEN IS UP(TRUE), PEN IS DOWN(FALSE)
boolean just_frozen = false; // FOR BEING ABLE TO KEEP TRACK OF VARIABLES NEEDED

void setup()
{
 size(640, 480);
 kinect = new SimpleOpenNI(this);
 kinect.enableDepth();
}

void draw()
{
  //** WILL NOT DRAW IF FREEZE IS TRUE ** 
  if(freeze != true){
   closestValue = 8000;
 
   kinect.update();
 
   int[] depthValues = kinect.depthMap();
 
   for(int y = 0; y < 480; y++){
     for(int x = 0; x < 640; x++){     
     
//**IN FINISHED EXAMPLE HE REVERSES THE VALUES**
//**NOT SURE WHY, SO CHANGED BACK TO FOLLOW HAND**
       int i = x + y * 640;      
       int currentDepthValue = depthValues[i];
     
 // only look for the closestValue within a range
 // 610 (or 2 feet) is the minimum
 // 1525 (or 5 feet) is the maximum
       if(currentDepthValue > 610 && currentDepthValue < 1525 
             && currentDepthValue < closestValue){
         //**FOR FUN**
         //**CHANGE COLOR OF LINE DEPENDENT ON HOW CLOSE YOU ARE**
         //**MORE BLUE FARTHER AWAY, MORE RED CLOSER **
         int n = (currentDepthValue-610); // JUST TO SIMPLIFY NEXT LINE A BIT
         stroke(((255*(915-n))/915),0, ((255*(n))/915));
//           if(currentDepthValue >610 && currentDepthValue <= 915){
//             stroke(255,0,0);
//           }
//           if(currentDepthValue > 915 && currentDepthValue <= 1220){
//             stroke(0,255,0);
//           }
//           if(currentDepthValue > 1220 && currentDepthValue < 1525){
//             stroke(0,0,255);
//           }
           closestValue = currentDepthValue;
           closestX = x;
           closestY = y;
        }
       }
     }
     
   //**DRAWS THE DEPTH IMAGE FROM THE KINECT **
    image(kinect.depthImage(),0,0);
    


   
   
 // "linear interpolation", i.e.
 // smooth transition between last point
 // and new closest point
 float interpolatedX = lerp(lastX, closestX, 0.3f); 
 float interpolatedY = lerp(lastY, closestY, 0.3f);
 
 
 // make a thicker line, which looks nicer
 strokeWeight(10);
 
 //** just_frozen VARIABLE ONLY UPDATED AFTER MOST RECENT **
 //** LOCATION HAS BEEN STORED **
 if(just_frozen == false){
   
   //** REDRAWS ALL LINES FROM lines VARIABLE WHICH**
    //** STORES EVERY LINE DRAWN **
   for(int L = 0; L < lines.size(); L++){
    if(lines.get(L).get(0) != 0){
    line(lines.get(L).get(0), lines.get(L).get(1), lines.get(L).get(2), lines.get(L).get(3));
    }
  }

 // **CREATE LIST OF FLOATS THAT GOES INTO lines LIST**
 // **AND APPEND ALL THE FLOATS TO THE LIST **
 // **THEN APPEND THE FLOATS LIST TO lines LIST **
 FloatList line = new FloatList();
  line.append(lastX);
  line.append(lastY);
  line.append(interpolatedX);
  line.append(interpolatedY);
  lines.add(line);
  
 lastX = interpolatedX;
 lastY = interpolatedY;
 }
 
 //** FOR THE ONE LOOP THAT just_frozen IS TRUE **
 //** UPDATE THE lastX AND lastY TO EXACT POSITION OF HAND** 
 //** interpolatedX/Y DOES NOT WORK**
 else{
   lastX = closestX;
   lastY = closestY;
 }
 
 just_frozen = false; //MAKE FALSE AFTER ONE LOOP FOR PROPER VARIABLES TO BE STORED
  }
  
  
  //** WHEN FROZEN **
  //** REDRAW THE CURRENT DEPTH IMAGE AND LINES ALREADY DRAWN **
  else{
    kinect.update();
    image(kinect.depthImage(),0,0);
    
    //** REDRAWS ALL LINES FROM lines VARIABLE WHICH**
    //** STORES EVERY LINE DRAWN **
    for(int L = 0; L < lines.size(); L++){
      if(lines.get(L).get(0) != 0){
        line(lines.get(L).get(0), lines.get(L).get(1), lines.get(L).get(2), lines.get(L).get(3));
      }
    }
  }
}

void mousePressed(){
 // save image to a file
 save("drawing.png");
 
 //**RESETS JUST THE LINES LIST SO AFTER MOUSE CLICK,**
 //**SAVES DRAWING AND RESETS TO NEW LINE**
 lines = new ArrayList();
 
}


//** TO PICK UP AND PUT DOWN "PEN" **
//** WHEN UP ARROW SELECTED, "PEN" PICKED UP **
//** WHEN DOWN ARROW SELECTED "PEN" PUT DOWN ** 
void keyPressed(){
  if(key == CODED){
    if(keyCode == UP){
      freeze = true;
      just_frozen = true;
    }
    if(keyCode == DOWN){
      freeze = false;
    }  
  }
  
}


