//Cloth simulation

//Basic variables
int height = 200;
int width = 400;
int col = 10;
int row = 10;

import controlP5.*; // import controlP5 library
ControlP5 controlP5; // controlP5 object

void settings(){
  size(900, 600); //Size of window
    
}

void setup(){

  frameRate(60);
  
  //Interactive GUI menu
  controlP5 = new ControlP5(this);
  controlP5.addSlider("Damping",10,100,30,700,30,30,120); // parameters : name, minimum, maximum, default value (float), x, y, width, height
  controlP5.addSlider("Stiffness",10,100,30,780,30,30,120); // parameters : name, minimum, maximum, default value (float), x, y, width, height
  //controlP5.addNumberbox("numberbox1",100,650,30,100,40); // parameters : name, default value, posX, posY, sizeX, sizeY
  
  background(0, 0, 0);
  stroke(255);
  
  //Create lattice grid for cloth
  for(int i=0; i<width; i+=10){
    line(i,0,i,height);
  }
  for(int w=0; w<height; w+=10){
     line(0,w,width,w);
  }

}


void draw(){
  
  background(0);
  
  

  
  //Calculate forces
  
  
  //Update positions with numerical method

}


void drawGrid(){

for(int c = 0; c < col; c++){
  for(int r = 0; r < row; r++){

}
}
}
