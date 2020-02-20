//Interactive Cloth simulation

// ************************* SETTINGS AND GLOBAL VARIABLE ***************************** //
int height = 200;
int width = 400;
int col = 15;
int row = 15;
float stiffness = -700;
float damping = -2;
float k_air = 0.002;
int Area = col*row;
float mass = 0.2;
float ts = 0.001;
int FPS = 60;
int offset = 200;
int gravityInfluenceFactor = 700;
PVector gravity = new PVector(0, -9.81*gravityInfluenceFactor);
PVector chosenParticle = new PVector(0, 0);
boolean chosen = false;
boolean renderParticles = true;
int DIST = 30;
int MASS_SIZE = 7;
boolean renderBackground = false;
String s = "CLOTH SIMULATION";
String info = "This is an interactive simulation of a cloth. The calculations are based on a string-damper system that is solved using Euler's method";
String instruction = "Press and drag with the left mouse button on a mass to move it. Press F to fixate/unfixate a chosen mass.";
String moreInfo = "Change the values of the spring and damping coefficient in order to change the appearance of the cloth. Note that some values may cause an unstable behavior.";
String about = "This simulation was created by Josefine Klintberg, Julius Halldan, Elin Karlsson and Olivia Enroth as a course project at Linköping University during 4 weeks 2020. \n\nMore info can be found at: \nhttp://github.com/jklintan/Cloth-Simulation.";

particle[][] theparticles = new particle[row][col]; //Array for storing the particles in the grid

import controlP5.*; // import controlP5 library
ControlP5 gui; // controlP5 object

// ******************* SETTINGS ********************* //

void settings() {
  size(1200, 900); //Size of window

  //Create lattice grid for cloth
  createLattice();
}

// ********************* SETUP ******************** //

void setup() {

  frameRate(60);

  //Interactive GUI menu
  gui = new ControlP5(this);
  Button b = gui.addButton("RenderMasses");
  b.setPosition(850, 600);
  b.setLabel("Toggle Masses");
  b.setColorBackground(color(58, 76, 100));
  b.setColorActive(color(158, 182, 206));
  b.setSize(130, 40);
  b.activateBy(ControlP5.PRESS);

  Button reset = gui.addButton("Reset");
  reset.setPosition(1000, 600);    
  reset.setColorActive(color(158, 182, 206));
  reset.setColorBackground(color(58, 76, 100));
  reset.setLabel("Reset");
  reset.setSize(130, 40);
  reset.activateBy(ControlP5.PRESS);

  gui.addSlider ("MassSize")
    .setPosition(850, 400)
    .setSize(280, 30)
    .setRange(5, 15)
    .setValue(7)
    .setColorBackground(color(99, 127, 158))
    .setColorForeground(color(158, 182, 206))
    .setColorActive(color(58, 76, 100))
    .setColorValue(255)
    .setSliderMode(Slider.FLEXIBLE);

  gui.addSlider ("Stiffness")
    .setPosition(850, 460)
    .setSize(280, 30)
    .setRange(10, 1000)
    .setValue(700)
    .setColorBackground(color(99, 127, 158))
    .setColorForeground(color(158, 182, 206))
    .setColorActive(color(58, 76, 100))
    .setColorValue(255)
    .setSliderMode(Slider.FLEXIBLE);

  gui.addSlider ("Damping")
    .setPosition(850, 520)
    .setSize(280, 30)
    .setRange(0, 14.9)
    .setValue(12)
    .setColorBackground(color(99, 127, 158))
    .setColorForeground(color(158, 182, 206))
    .setColorActive(color(58, 76, 100))
    .setColorValue(255)
    .setSliderMode(Slider.FLEXIBLE);

  drawLattice();
}


//****************************** RENDERING LOOP ******************************* //

void draw() {

  //Draw the particles
  stroke(0);
  background(color(11, 13, 18));
  fill(color(11, 13, 18));
  rect(2, 2, 1196, 896);

  //GUI info
  fill(255);
  rect(795, 5, 400, 890);
  fill(color(11, 13, 18));
  textSize(28.7);
  text(s, 850, 60, 350, 100); 
  textSize(12);
  text(info, 850, 130, 300, 100); 
  text(instruction, 850, 200, 300, 100); 
  text(moreInfo, 850, 270, 300, 100); 
  text("Stiffness", 850, 440, 280, 100); 
  text("Damping", 850, 500, 280, 100); 
  text("Mass Size", 850, 380, 280, 100); 

  textSize(10);
  text(about, 850, 700, 280, 200); 

  stroke(255);
  drawLattice();
  updateParticles(); //Update forces acting on particles and positions according to Euler
}


void createGUI() {
}

// Create the lattice
void createLattice() {
  for (int rows=0; rows<row; rows++) {
    for (int cols=0; cols<col; cols++) {
      if ((rows == 0 && cols == 0) || rows == 0 && cols == col-1 || (rows == 0 && cols == floor(col/2))) {
        theparticles[cols][rows] = new particle(cols, rows, DIST, true);
      } else {
        theparticles[cols][rows] = new particle(cols, rows, DIST, false);
      }
    }
  }
}

// Draw lattice
void drawLattice() {
  for (int y=0; y<row; y++) {
    for (int x=0; x<col; x++) {
      if (renderParticles) {
        theparticles[y][x].display();
      }
      fill(255);
      strokeWeight(1);
      stroke(255);
      if (x == 0 && y >= 0 && y < row-1) {
        line(theparticles[y][x].pos.x + offset, theparticles[y][x].pos.y + 100, theparticles[y+1][x].pos.x + offset, theparticles[y+1][x].pos.y + 100);
      }
      if (y >= 0 && x >= 1) {        
        line(theparticles[y][x].pos.x + offset, theparticles[y][x].pos.y + 100, theparticles[y][x-1].pos.x + offset, theparticles[y][x-1].pos.y + 100);  
        if (y >= 1) {
          line(theparticles[y][x].pos.x + offset, theparticles[y][x].pos.y + 100, theparticles[y-1][x].pos.x + offset, theparticles[y-1][x].pos.y + 100);
        }
      }
    }
  }
}

// Update particles
void updateParticles() {
  PVector fs1, fs2, fs3, fs4, fs5, fs6, fs7, fs8, fb1, fb2, fb3, fb4, fb5, fb6, fb7, fb8, xij;
  float norm_xij, L; 

  for (int r = 0; r < row; r++) {

    for (int c = 0; c < col; c++) {

      // Stiffnes forces
      fs1 = new PVector(0.0, 0.0);
      fs2 = new PVector(0.0, 0.0);
      fs3 = new PVector(0.0, 0.0);
      fs4 = new PVector(0.0, 0.0);
      fs5 = new PVector(0.0, 0.0);
      fs6 = new PVector(0.0, 0.0);
      fs7 = new PVector(0.0, 0.0);
      fs8 = new PVector(0.0, 0.0);

      // Damping forces
      fb1 = new PVector(0.0, 0.0);
      fb2 = new PVector(0.0, 0.0);
      fb3 = new PVector(0.0, 0.0);
      fb4 = new PVector(0.0, 0.0);
      fb5 = new PVector(0.0, 0.0);
      fb6 = new PVector(0.0, 0.0);
      fb7 = new PVector(0.0, 0.0);
      fb8 = new PVector(0.0, 0.0);

      L = 10; //Initial link

      //Update forces for 4-neighbours (stretching forces)
      //Update forces for 8-neighbours (shearing forces)
      //Spring force according to Hook's law 
      //Damping force according to linear damping of velocity

      // Mass below
      if (r < row-1) {
        L = theparticles[c][r].initialpos.dist(theparticles[c][r+1].initialpos);
        xij = PVector.sub(theparticles[c][r].pos, theparticles[c][r+1].pos);
        norm_xij = xij.mag();
        float s = norm_xij - L;
        float t = -stiffness*s;
        PVector j = PVector.div(xij, norm_xij);
        fs2 = PVector.mult(j, t);
        PVector n = PVector.sub(theparticles[c][r].vel, theparticles[c][r+1].vel);
        fb2 = PVector.mult(n, -damping);
      }

      // Mass to the right
      if (c < col-1) {
        L = PVector.dist(theparticles[c][r].initialpos, theparticles[c+1][r].initialpos);
        xij = PVector.sub(theparticles[c][r].pos, theparticles[c+1][r].pos);
        norm_xij = xij.mag();
        float s = norm_xij - L;
        float t = -stiffness*s;
        PVector j = PVector.div(xij, norm_xij);
        fs3 = PVector.mult(j, t);
        PVector n = PVector.sub(theparticles[c][r].vel, theparticles[c+1][r].vel);
        fb3 = PVector.mult(n, -damping);
      }

      // Mass above
      if (r > 0) {
        L = theparticles[c][r].initialpos.dist(theparticles[c][r-1].initialpos);
        xij = PVector.sub(theparticles[c][r].pos, theparticles[c][r-1].pos);
        norm_xij = xij.mag();
        float s = norm_xij - L;
        float t = -stiffness*s;
        PVector j = PVector.div(xij, norm_xij);
        fs5 = PVector.mult(j, t);
        PVector n = PVector.sub(theparticles[c][r].vel, theparticles[c][r-1].vel);
        fb5 = PVector.mult(n, -damping);
      }

      // Mass to the left
      if (c > 0) {
        L = theparticles[c][r].initialpos.dist(theparticles[c-1][r].initialpos);
        xij = PVector.sub(theparticles[c][r].pos, theparticles[c-1][r].pos);
        norm_xij = xij.mag();
        float s = norm_xij - L;
        float t = -stiffness*s;
        PVector j = PVector.div(xij, norm_xij);
        fs6 = PVector.mult(j, t);
        PVector n = PVector.sub(theparticles[c][r].vel, theparticles[c-1][r].vel);
        fb6 = PVector.mult(n, -damping);
      }

      // Mass diagonal, top right
      if (r > 0 && c < col-1) {
        L = theparticles[c][r].initialpos.dist(theparticles[c+1][r-1].initialpos);
        xij = PVector.sub(theparticles[c][r].pos, theparticles[c+1][r-1].pos);
        norm_xij = xij.mag();
        float s = norm_xij - L;
        float t = -stiffness*s;
        PVector j = PVector.div(xij, norm_xij);
        fs4 = PVector.mult(j, t);
        PVector n = PVector.sub(theparticles[c][r].vel, theparticles[c+1][r-1].vel);
        fb4 = PVector.mult(n, -damping);
      }

      // Mass diagonal, down left
      if (r < row-1 && c > 0) {
        L = theparticles[c][r].initialpos.dist(theparticles[c-1][r+1].initialpos);
        xij = PVector.sub(theparticles[c][r].pos, theparticles[c-1][r+1].pos);
        norm_xij = xij.mag();           
        float s = norm_xij - L;
        float t = -stiffness*s;
        PVector j = xij.div(norm_xij);
        fs1 = j.mult(t);
        PVector n = PVector.sub(theparticles[c][r].vel, theparticles[c-1][r+1].vel);
        fb1 = n.mult(-damping);
      }

      // Mass diagonal, down right
      if (r < row-1 && c < col-1) {
        L = theparticles[c][r].initialpos.dist(theparticles[c+1][r+1].initialpos);
        xij = PVector.sub(theparticles[c][r].pos, theparticles[c+1][r+1].pos);
        norm_xij = xij.mag();
        float s = norm_xij - L;
        float t = -stiffness*s;
        PVector j = PVector.div(xij, norm_xij);
        fs7 = PVector.mult(j, t);
        PVector n = PVector.sub(theparticles[c][r].vel, theparticles[c+1][r+1].vel);
        fb7 = PVector.mult(n, -damping);
      }

      //// Mass diagonal, top left
      if (r > 0 && c > 0) {
        L = theparticles[c][r].initialpos.dist(theparticles[c-1][r-1].initialpos);
        xij = PVector.sub(theparticles[c][r].pos, theparticles[c-1][r-1].pos);
        norm_xij = xij.mag();
        float s = norm_xij - L;
        float t = -stiffness*s;
        PVector j = PVector.div(xij, norm_xij);
        fs8 = PVector.mult(j, t);
        PVector n = PVector.sub(theparticles[c][r].vel, theparticles[c-1][r-1].vel);
        fb8 = PVector.mult(n, -damping);
      }

      PVector def = new PVector(0, 0, 0);
      theparticles[c][r].force = def.sub(fs1).sub(fs2).sub(fs3).sub(fs4).sub(fs5).sub(fs6).sub(fs7)
        .sub(fs8).sub(fb1).sub(fb2).sub(fb3).sub(fb4).sub(fb5)
        .sub(fb6).sub(fb7).sub(fb8)
        .sub(PVector.mult(gravity, mass));
      PVector AirResistance =  new PVector().add(theparticles[c][r].vel).mult(k_air*Area);
      theparticles[c][r].force.add(theparticles[c][r].force).sub(AirResistance); //Add air resistance
    }
  }

  ////Position, velocity, and accelleration update for all nodes
  for (int r = 0; r < row; r++) {      
    for (int c = 0; c < col; c++) {
      if (!theparticles[c][r].isfixed) {  //Upate all nodes except the fixed ones 
        theparticles[c][r].acc.set(PVector.div(theparticles[c][r].force, mass));
        theparticles[c][r].vel.set(xtEuler(theparticles[c][r].vel.x, theparticles[c][r].acc.x, ts), xtEuler(theparticles[c][r].vel.y, theparticles[c][r].acc.y, ts));
        theparticles[c][r].pos.set(xtEuler(theparticles[c][r].pos.x, theparticles[c][r].vel.x, ts), xtEuler(theparticles[c][r].pos.y, theparticles[c][r].vel.y, ts));
      }
    }
  }
}

//**************************  EULERS METHOD ********************************//
float xtEuler(float xt, float xtPrim, float h) {
  return xt + h*xtPrim;
}

//**************************  USER INTERACTION ********************************//

//Fix and unfix particles
void keyPressed() {
  if (keyPressed && keyCode == 'F' || keyCode == 'f') {
    if (chosen) {
      if (theparticles[int(chosenParticle.x)][int(chosenParticle.y)].isFixed()) {
        theparticles[int(chosenParticle.x)][int(chosenParticle.y)].isfixed = false;
      } else {
        theparticles[int(chosenParticle.x)][int(chosenParticle.y)].isfixed = true;
      }
    }
  }
}

//Chose a specific particle
void mousePressed() { 
  if (mousePressed && (mouseButton == LEFT)) {
    PVector mousePos = new PVector(mouseX, mouseY);
    for (int r = 0; r < row; r++) {
      for (int c = 0; c < col; c++) {
        if (abs(theparticles[c][r].pos.x - mousePos.x + 200) < 15 && abs(theparticles[c][r].pos.y - mousePos.y + 100) < 15) {
          chosenParticle = new PVector(c, r);
          chosen = true;
          return;
        }
      }
    }
  }
}

void mouseReleased() {
  chosen = false;
}

//Move the current particle
void mouseDragged() {
  if (chosen) {
    theparticles[int(chosenParticle.x)][int(chosenParticle.y)].setPos(mouseX-200, mouseY-100);
  }
}

//******************************* GUI ********************************//

public void Stiffness(int ks) {
  stiffness = -ks;
}

public void Damping(int kd) {
  damping = -(15-kd);
}

public void MassSize(int size) {
  MASS_SIZE = size;
}

public void Gravity(int g) {
  gravityInfluenceFactor = g;
}

public void RenderMasses() {
  if (renderParticles == false)
    renderParticles = true;
  else
    renderParticles = false;
}

public void Reset() {
  renderParticles = true;
  settings();
}
