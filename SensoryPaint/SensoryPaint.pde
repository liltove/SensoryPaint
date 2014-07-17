import java.util.Map;
import java.util.Iterator;

import SimpleOpenNI.*;

import controlP5.*;

ControlP5 cp5;

int STROKEWEIGHT = 3;
int NUMBER_OF_CLICKS = 0;
float RGB_R = 255;
float RGB_G = 0;
float RGB_B = 0;
boolean ENABLE_RGB = false;
int n = 0;
PImage picture1;
boolean ENABLE_T = false; 

int c1, c2;

SimpleOpenNI context;
int handVecListSize = 20;
Map<Integer, ArrayList<PVector>>  handPathList = new HashMap<Integer, ArrayList<PVector>>();
color[]       userClr = new color[] { 
  color(255, 0, 0), 
  //color(0,255,0),
  //color(0,0,255),
  //color(255,255,0),
  //color(255,0,255),
  //color(0,255,255)
};
void setup()
{
  //  frameRate(200);
  size(750, 480);
  background(255);
  picture1 = loadImage("2.png");


  context = new SimpleOpenNI(this);
  cp5 = new ControlP5(this);

  if (context.isInit() == false)
  {
    println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
    exit();
    return;
  }   

  // enable depthMap generation 
  context.enableDepth();

  // disable mirror
  context.setMirror(true);
  //enable RBG image generation
  context.enableRGB();

  // enable hands + gesture generation
  //context.enableGesture();
  context.enableHand();

  // add focus gestures  
  //context.startGesture(SimpleOpenNI.GESTURE_WAVE);
  context.startGesture(SimpleOpenNI.GESTURE_HAND_RAISE);
  //context.startGesture(SimpleOpenNI.GESTURE_CLICK);


  // set how smooth the hand capturing should be
  //context.setSmoothingHands(.5);
  // create a new button with name 'penColor'
  cp5.addButton("penColor")
    .setValue(0)
      .setPosition(640, 20)
        .setSize(100, 20)
          ;
  // create a new button with name 'adjust Pen Width'
  cp5.addButton("Adjust Pen Width")
    .setValue(0)
      .setPosition(640, 55)
        .setSize(100, 20)
          ;
  // create a new button with name 'increase'
  cp5.addButton("Increase")
    .setValue(0)
      .setPosition(640, 80)
        .setSize(100, 20)
          ;
  // create a new button with name 'decrease'
  cp5.addButton("Decrease")
    .setValue(0)
      .setPosition(640, 105)
        .setSize(100, 20)
          ;
  // create a new button with name 'save'
  cp5.addButton("Save")
    .setValue(0)
      .setPosition(640, 140)
        .setSize(100, 20)
          ;
  n= 1;
  // create a new button with name 'New'
  cp5.addButton("New")
    .setValue(0)
      .setPosition(640, 165)
        .setSize(100, 20)
          ;  
  // create a new button with name 'Template'
  cp5.addButton("Template")
    .setValue(0)
      .setPosition(640, 190)
        .setSize(100, 20)
          ;
  // create a new button with name 'Enable RBG'
  cp5.addButton("enableRGB")
    .setValue(0)
      .setPosition(640, 215)
        .setSize(100, 20)
          ;
}

void draw()
{
  // update the cam
  context.update();
  if( ENABLE_RGB == true){
    image(context.rgbImage(), 0, 0);
  }
  else if (ENABLE_T == true){
        image(context.depthImage(), 0, 0);

    image(picture1,0,0);

  }
  else{
    image(context.depthImage(), 0, 0);
  }
  
  

  // draw the tracked hands
  if (handPathList.size() > 0)  
  {    
    Iterator itr = handPathList.entrySet().iterator();     
    while (itr.hasNext ())
    {
      Map.Entry mapEntry = (Map.Entry)itr.next(); 
      int handId =  (Integer)mapEntry.getKey();
      ArrayList<PVector> vecList = (ArrayList<PVector>)mapEntry.getValue();
      PVector p;
      PVector p2d = new PVector();

      //stroke(userClr[ (handId - 1) % userClr.length ]);
      stroke(RGB_R, RGB_G, RGB_B);
      noFill(); 
      strokeWeight(STROKEWEIGHT);        
      Iterator itrVec = vecList.iterator(); 
      beginShape();
      while ( itrVec.hasNext () ) 
      { 
        p = (PVector) itrVec.next(); 

        context.convertRealWorldToProjective(p, p2d);
        vertex(p2d.x, p2d.y);
      }
      endShape();   

      //stroke(userClr[ (handId - 1) % userClr.length ]);
      stroke(RGB_R, RGB_G, RGB_B); 
      strokeWeight(STROKEWEIGHT);
      p = vecList.get(0);
      context.convertRealWorldToProjective(p, p2d);
      point(p2d.x, p2d.y);
    }
  }
}

// function changeColor will receive changes from 
// controller with name colorB
void penColor(int theValue) {
  println("a button event from colorB: "+theValue);
  //color(random(3, 255), random(3, 255), random(3, 255));
  RGB_R = random(3,255);
  RGB_G = random(3,255);
  RGB_B = random(3,255);
}

// function increase will increase the strokeweight 
// controller with name increase
void Increase() {
  STROKEWEIGHT += 1;
}
// function decrease will decrease the strokeweight 
// controller with name decrease
void Decrease() {

  if (STROKEWEIGHT > 1) {
    STROKEWEIGHT -= 1;
  }
}

// function decrease will prompt to save drawing
// controller with name decrease
void Save() {
 // if (n == 1) {

   // cp5.addTextfield("EnterName")
     // .setPosition(260, 220)
       // .setSize(200, 40)
         // .setColorValue(color(255))
           // ;
    //save("drawing_" + cp5.get(Textfield.class,"EnterName").getText()+ ".png");
    NUMBER_OF_CLICKS +=1;
  save("drawing_" + NUMBER_OF_CLICKS+ ".png");  
}
  

  //n = 0;
  // function dnew will begin new drawing
  // controller with name decrease
 // void New() {
  //handPathList.clear();
   //n = 0;

  // }

// function enableRGB will turn on RGB tracking
//controller with name enableRGB
void enableRGB(){
        println("here");

    if (ENABLE_RGB == false){
         ENABLE_RGB = true;
      }
       else{
         ENABLE_RGB = false;
       }
}

// function decrease will prompt to save drawing
// controller with name decrease
//void Template() {
  // picture1 = loadImage("elements/1.jpg");
  //image(picture1, 0,0, width/2, height/2);
 // }

// function Template adds a template to trace
//controller name template
void Template (){
  if (ENABLE_T == false){
    ENABLE_T = true; 
  }
  else{
    ENABLE_T = false;
  }
}
    


  // -----------------------------------------------------------------
  // hand events

  void onNewHand(SimpleOpenNI curContext, int handId, PVector pos)
  {
    println("onNewHand - handId: " + handId + ", pos: " + pos);

    ArrayList<PVector> vecList = new ArrayList<PVector>();
    vecList.add(pos);

    handPathList.put(handId, vecList);
  }

  void onTrackedHand(SimpleOpenNI curContext, int handId, PVector pos)
  {
    //println("onTrackedHand - handId: " + handId + ", pos: " + pos );

    ArrayList<PVector> vecList = handPathList.get(handId);
    if (vecList != null)
    {
      vecList.add(0, pos);
      //if(vecList.size() >= handVecListSize)
      // remove the last point 
      //vecList.remove(vecList.size()-1);
    }
  }

  void onLostHand(SimpleOpenNI curContext, int handId)
  {
    println("onLostHand - handId: " + handId);
    handPathList.remove(handId);
  }

  // -----------------------------------------------------------------
  // gesture events

  void onCompletedGesture(SimpleOpenNI curContext, int gestureType, PVector pos)
  {
    println("onCompletedGesture - gestureType: " + gestureType + ", pos: " + pos);
    //  
    int handId = context.startTrackingHand(pos);
    println("hand stracked: " + handId);
  }


  

