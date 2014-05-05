import SimpleOpenNI.*; 
SimpleOpenNI kinect;
ArrayList<PVector> handPositions;

PVector currentHand;
PVector previousHand;

boolean freeze = false;
boolean just_frozen = false;

int STROKEWEIGHT = 5;
int NUMBER_OF_CLICKS = 0;
float RGB_R = 255;
float RGB_G = 0;
float RGB_B = 0;


void setup() {  
  size(640, 480);
  kinect = new SimpleOpenNI(this);  
  kinect.setMirror(true);
  //enable depthMap generation
  kinect.enableDepth();  
  // enable hands + gesture generation 
  kinect.enableHand();
  kinect.startGesture(SimpleOpenNI.GESTURE_WAVE); 
  handPositions = new ArrayList(); 
}



void draw() {  

  stroke(RGB_R, RGB_G, RGB_B); 
  kinect.update(); 
  image(kinect.depthImage(), 0, 0);
  strokeWeight(STROKEWEIGHT); 


    for (int i = 1; i < handPositions.size(); i++) {
      currentHand = handPositions.get(i);
      previousHand = handPositions.get(i-1);   
      line(previousHand.x, previousHand.y, currentHand.x, currentHand.y); 
    } 
}


// ----------------------------------------------------------------- // hand events 
void onNewHand(SimpleOpenNI curContext, int handId, PVector position) {  
  kinect.convertRealWorldToProjective(position, position);
  handPositions.add(position); 
}

void onTrackedHand(SimpleOpenNI curContext, int handId, PVector position) { 
  if(freeze == false){
    kinect.convertRealWorldToProjective(position, position);  
    handPositions.add(position); 
  }
}


void onLostHand(SimpleOpenNI curContext, int handId) {
  if (freeze == false){
    handPositions.clear();  
  }
 }
 
 
void onCompletedGesture(SimpleOpenNI curContext,int gestureType, PVector pos)
{  
  println("onCompletedGesture - gestureType: " + gestureType + ", pos: " + pos);
  int handID = kinect.startTrackingHand(pos);
}



void mousePressed(){
 // save image to a file
 NUMBER_OF_CLICKS += 1;
 save("drawing_" + NUMBER_OF_CLICKS + ".png");
 
 //**SAVES DRAWING AND RESETS TO NEW LINE**
  handPositions.clear();
}


//** TO PICK UP AND PUT DOWN "PEN" AND INCREASE/DECREASE "PEN" SIZE **
//** WHEN UP ARROW SELECTED, "PEN" PICKED UP **
//** WHEN DOWN ARROW SELECTED "PEN" PUT DOWN **
//** WHEN RIGHT ARROW SELECTED STROKEWEIGHT INCREASED **
//** WHEN LEFT ARROW SELECTED STROKEWIGHT DECREASED **
void keyPressed(){
  if(key == CODED){
    if(keyCode == UP){
      freeze = true;
      just_frozen = true;
    }
    if(keyCode == DOWN){
      freeze = false;
    }  
    if (keyCode == RIGHT){
      STROKEWEIGHT += 1;
    }
    if (keyCode == LEFT){
      if (STROKEWEIGHT > 1){
         STROKEWEIGHT -= 1;
      }
    }
  }
  if (keyCode == ENTER){
    handPositions.clear();
  }
  if (keyCode == TAB){
      RGB_R = random(3,255);
      RGB_B = random(3,255);
      RGB_B = random(3,255);
  }
  
  
  
}
