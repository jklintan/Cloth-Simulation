//Interactive Cloth simulation

// ************************* PARTICLE CLASS ***************************** //

class particle {
  float mass = 0.1;
  PVector pos = new PVector(0.0, 0.0, 0.0);
  PVector oldpos = new PVector(0.0, 0.0, 0.0);
  PVector initialpos = new PVector(0.0, 0.0, 0.0);
  PVector vel = new PVector(0.0, 0.0, 0.0);
  PVector acc = new PVector(0.0, 0.0, 0.0);
  PVector force = new PVector(0.0, 0.0, 0.0);
  boolean isfixed = false;
  PVector index = new PVector(0.0, 0.0);

  //Constructor
  particle(int row, int col, int dist, boolean fix) {
    this.index.set(row, col);
    this.initialpos.set((row-1)*dist, (col-1)*dist, 0.0);
    this.pos.set(new PVector(0.0, 0.0, 0.0));
    this.oldpos.set(new PVector(0.0, 0.0, 0.0));
    this.isfixed = fix;
    this.force.set(new PVector(0.0, 0.0, 0.0));
    this.vel.set(new PVector(0.0, 0.0, 0.0));
  }

  boolean isFixed() {
    return this.isfixed;
  }

  void setPos(float x, float y) {
    this.pos.set(x, y);
  }

  //Draw the particle 
  public void display() {
    fill(255);
    ellipse(this.pos.x+offsetX, this.pos.y+ offsetY, MASS_SIZE, MASS_SIZE);
  }

  PVector getPos() {
    return this.pos;
  }
}

// ************************* SETTINGS AND GLOBAL VARIABLE ***************************** //

//Size of window and cloth, note that a square cloth is needed
int height = 900;
int width = 1200;
int col = 14;
int row = 14;
int Area = col*row;
int FPS = 60;
int offsetX = 200;
int offsetY = 100;
int DIST = 30;
int MASS_SIZE = 7;
particle[][] theparticles = new particle[row][col]; //Array for storing the particles in the grid

//Simulation constants
float stiffness = -700;
float damping = -2;
float k_air = 0.002;
float mass = 0.2;
float ts = 0.001; //Euler timestep (note that smaller than 0.001 needed for stability)
int gravityInfluenceFactor = 700;
PVector gravity = new PVector(0, -9.81*gravityInfluenceFactor);

//Displaying particles and interaction
PVector chosenParticle = new PVector(0, 0);
boolean chosen = false;
boolean renderParticles = true;

// Wind
boolean windActive = false;
int windFactor = 0;
int colorT = color(255);
int colorT2 = color(255);
int colorT3 = color(255);

// Background and GUI
boolean renderBackground = false;
String s = "CLOTH SIMULATION";
String info = "This is an interactive simulation of a cloth. The calculations are based on a string-damper system that is solved using Euler's method";
String instruction = "Press and drag with the left mouse button on a mass to move it. Press F to fixate/unfixate a chosen mass.";
String moreInfo = "Change the values of the spring and damping coefficient in order to change the appearance of the cloth. Note that some values may cause an unstable behavior.";
String about = "More info can be found at: \nhttp://github.com/jklintan/Cloth-Simulation.";
//import controlP5.*; // import controlP5 library
//ControlP5 gui; // controlP5 object
PImage textureIm, im1, im2, im3, im4;
int nTextures = 1;
boolean renderTexture = false;
int heavyFactor = 3;

// ******************* SETTINGS ********************* //

void settings() {
  size(width, height, P3D); //Size of window

  //Create lattice grid for cloth
  createLattice();
}

// ********************* SETUP ******************** //

void setup() {

  frameRate(60);

  //Interactive GUI menu
  //createGUI();

  //Draw the lattice
  drawLattice();

  //Textures
  im1 = loadImage("cloth.jpg");
  im2 = loadImage("silk.jpg");
  im3 = loadImage("fabric.jpg");
  im4 = loadImage("mt.png");
  textureMode(NORMAL);
  textureIm = im1;
}


//****************************** RENDERING LOOP ******************************* //

void draw() {

  //Background clear
  emissive(0);
  stroke(0);
  background(color(11, 13, 18));
  fill(color(11, 13, 18));
  rect(2, 2, 1196, 896);

  //Draw the lattice
  //drawLattice();
  //updateParticles(); //Update forces acting on particles and positions according to Euler


  //Lights
  directionalLight(200, 200, 200, 0, 0, -1);
  ambientLight(255, 255, 255);
  lightSpecular(255, 255, 255);

  //GUI info
  emissive(0);
  fill(255);
  rect(795, 5, 400, 890);
  fill(color(11, 13, 18));
  textSize(28.7);
  text(s, 850, 60, 350, 100); 
  textSize(12);
  text(info, 850, 120, 280, 100); 
  text(instruction, 850, 190, 280, 100); 
  text(moreInfo, 850, 260, 280, 100); 
  text("Stiffness", 850, 420, 280, 100); 
  text("Damping", 850, 480, 280, 100); 
  text("Mass Size", 850, 360, 280, 100); 
  text("Wind Strength and Direction", 850, 540, 280, 100); 
  //gui.getController("toggle").setColorBackground(colorT);
  //gui.getController("toggleTexture").setColorBackground(colorT2);
  //gui.getController("toggleMasses").setColorBackground(colorT3);
  textSize(10);
  text(about, 850, 830, 280, 200); 

  //stroke(255);
}

//********************* Create the lattice **********************//
void createLattice() {
  for (int rows=0; rows<row; rows++) {
    for (int cols=0; cols<col; cols++) {
      if ((rows == 0 && cols == 0) || rows == 0 && cols == col-1) {
        theparticles[cols][rows] = new particle(cols, rows, DIST, true);
      } else {
        theparticles[cols][rows] = new particle(cols, rows, DIST, false);
      }
    }
  }
}

// Draw lattice
void drawLattice() {
  shininess(200.0);
  if (!renderTexture) {
    fill(255);
    strokeWeight(1);
    stroke(255);
  }

  for (int y=0; y<row; y++) {

    if (renderTexture) {
      noStroke();
      noFill();
      beginShape(QUAD_STRIP);
      texture(textureIm);
    }
    for (int x=0; x<col; x++) {
      if(theparticles[y][x].pos == null){
        background(color(255, 255, 255));
      }else{
        if (renderParticles && !renderTexture) {
          //theparticles[y][x].display();
        }

        if (renderTexture) {
          if (y < row-1 && x != col && y != row-1) {
            float x1 = theparticles[x][y].pos.x + offsetX;
            float y1 = theparticles[x][y].pos.y+ offsetY;
            float u = map(x, 0, col-1, 0, 1);
            float v1 = map(y, 0, row-1, 0, 1);
            vertex(x1, y1, u, v1);
            float x2 = theparticles[x][y+1].pos.x + offsetX;
            float y2 = theparticles[x][y+1].pos.y+ offsetY;
            float v2 = map(y+1, 0, row-1, 0, 1);
            vertex(x2, y2, u, v2);
          }
        }

        if (!renderTexture) {
          if (x == 0 && y >= 0 && y < row-1) {
            line(theparticles[y][x].pos.x + offsetX, theparticles[y][x].pos.y+ offsetY, theparticles[y+1][x].pos.x + offsetX, theparticles[y+1][x].pos.y+ offsetY);
          }
          if (y >= 0 && x >= 1) {        
            line(theparticles[y][x].pos.x + offsetX, theparticles[y][x].pos.y+ offsetY, theparticles[y][x-1].pos.x + offsetX, theparticles[y][x-1].pos.y+ offsetY);  

            if (y >= 1) {
              line(theparticles[y][x].pos.x + offsetX, theparticles[y][x].pos.y+ offsetY, theparticles[y-1][x].pos.x + offsetX, theparticles[y-1][x].pos.y+ offsetY);
            }
          }
      }
      }
    }

    if (renderTexture) {
      endShape();
    }
  }
}

//************************* Update particles **************************//
void updateParticles() {
  PVector fs1, fs2, fs3, fs4, fs5, fs6, fs7, fs8, fb1, fb2, fb3, fb4, fb5, fb6, fb7, fb8, xij;
  float norm_xij, L; 

  float xoff = 0;
  for (int r = 0; r < row; r++) {
    float yoff = 0;
    for (int c = 0; c < col; c++) {

      float nois = noise(xoff, yoff); //Wind noise

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

      float windx = map(noise(yoff, xoff), 0, 1, 0, 10);
      float windy = map(noise(yoff + 3000, xoff+3000), -100, 1, -100, 0);
      PVector wind = new PVector(0, 0);

      if (windActive)
        wind = new PVector(windx, windy).mult(windFactor/heavyFactor); 

      PVector def = new PVector(0, 0, 0);
      theparticles[c][r].force = def.sub(fs1).sub(fs2).sub(fs3).sub(fs4).sub(fs5).sub(fs6).sub(fs7)
        .sub(fs8).sub(fb1).sub(fb2).sub(fb3).sub(fb4).sub(fb5)
        .sub(fb6).sub(fb7).sub(fb8)
        .sub(PVector.mult(gravity, mass)).add(wind);
      PVector AirResistance =  new PVector().add(theparticles[c][r].vel).mult(k_air*Area);
      theparticles[c][r].force.add(theparticles[c][r].force).sub(AirResistance); //Add air resistance

      xoff += 10;
    }
    yoff += 10;
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
        if (abs(theparticles[c][r].pos.x - mousePos.x + 200) < 15 && abs(theparticles[c][r].pos.y - mousePos.y+ offsetY) < 15) {
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


void createGUI() {
  //gui = new ControlP5(this);
  //Button b = gui.addButton("RenderMasses")
  //  .setPosition(850, 620)
  //  .setLabel("Display Masses")
  //  .setColorBackground(color(28, 38, 53))
  //  .setColorActive(color(158, 182, 206))
  //  .setSize(85, 20)
  //  .setLock(true);

  //Button b2 = gui.addButton("RenderTexture")
  //  .setPosition(950, 620)
  //  .setLabel("Toggle Texture")
  //  .setColorBackground(color(28, 38, 53))
  //  .setSize(85, 20)
  //  .setLock(true);

  //Button b3 = gui.addButton("WindAdd")
  //  .setPosition(1050, 620)
  //  .setLabel("Toggle Wind")
  //  .setColorBackground(color(28, 38, 53))
  //  .setSize(85, 20)
  //  .setLock(true);

  //Button toggleText = gui.addButton("SwitchText")
  //  .setPosition(950, 700)
  //  .setColorActive(color(158, 182, 206))
  //  .setColorBackground(color(28, 38, 53))
  //  .setLabel("Switch Texture")
  //  .setSize(85, 40)
  //  .activateBy(ControlP5.PRESS);

  //Button reset = gui.addButton("Reset")
  //  .setPosition(850, 760)
  //  .setColorActive(color(158, 182, 206))
  //  .setColorBackground(color(11, 13, 18))
  //  .setLabel("Reset")
  //  .setSize(290, 40)
  //  .activateBy(ControlP5.PRESS);

  //gui.addSlider ("MassSize")
  //  .setPosition(850, 380)
  //  .setSize(285, 30)
  //  .setRange(5, 15)
  //  .setValue(7)
  //  .setColorBackground(color(28, 38, 53))
  //  .setColorForeground(color(158, 182, 206))
  //  .setColorActive(color(11, 13, 18))
  //  .setColorValue(255)
  //  .setSliderMode(Slider.FLEXIBLE);

  //gui.addSlider ("Stiffness")
  //  .setPosition(850, 440)
  //  .setSize(285, 30)
  //  .setRange(10, 3000)
  //  .setValue(700)
  //  .setColorBackground(color(28, 38, 53))
  //  .setColorForeground(color(158, 182, 206))
  //  .setColorActive(color(11, 13, 18))
  //  .setColorValue(255)
  //  .setSliderMode(Slider.FLEXIBLE);

  //gui.addSlider ("WindStrength")
  //  .setPosition(850, 560)
  //  .setSize(285, 30)
  //  .setRange(-3000, 3000)
  //  .setValue(0)
  //  .setLabel("Wind Strength")
  //  .setColorBackground(color(28, 38, 53))
  //  .setColorForeground(color(158, 182, 206))
  //  .setColorActive(color(11, 13, 18))
  //  .setColorValue(255)
  //  .setSliderMode(Slider.FLEXIBLE);

  //gui.addSlider ("Damping")
  //  .setPosition(850, 500)
  //  .setSize(285, 30)
  //  .setRange(0, 14.9)
  //  .setValue(12)
  //  .setColorBackground(color(28, 38, 53))
  //  .setColorForeground(color(158, 182, 206))
  //  .setColorActive(color(11, 13, 18))
  //  .setColorValue(255)
  //  .setSliderMode(Slider.FLEXIBLE);

  //Toggle t = gui.addToggle("toggle")
  //  .setPosition(1050, 650)
  //  .setSize(85, 30)
  //  .setValue(false)
  //  .setLabel("Wind")
  //  .setColorBackground(color(58, 76, 100))
  //  .setColorForeground(color(158, 182, 206))
  //  .setColorActive(color(11, 13, 18))
  //  .setColorLabel(color(255))
  //  .setMode(ControlP5.SWITCH)
  //  ;

  //Toggle t2 = gui.addToggle("toggleTexture")
  //  .setPosition(950, 650)
  //  .setSize(85, 30)
  //  .setValue(false)
  //  .setLabel("Texture")
  //  .setColorBackground(color(58, 76, 100))
  //  .setColorForeground(color(158, 182, 206))
  //  .setColorActive(color(11, 13, 18))
  //  .setColorLabel(color(255))
  //  .setMode(ControlP5.SWITCH)
  //  ;

  //Toggle t3 = gui.addToggle("toggleMasses")
  //  .setPosition(850, 650)
  //  .setSize(85, 30)
  //  .setValue(true)
  //  .setLabel("Mass")
  //  .setColorBackground(color(58, 76, 100))
  //  .setColorForeground(color(158, 182, 206))
  //  .setColorActive(color(11, 13, 18))
  //  .setColorLabel(color(255))
  //  .setMode(ControlP5.SWITCH)
  //  ;
}


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

public void SwitchText() {
  if (renderTexture) {
    if (nTextures == 1) {
      textureIm = im2;
      nTextures += 1;
      heavyFactor = 1;
    } else if (nTextures == 2) {
      textureIm = im3;
      nTextures += 1;
      heavyFactor = 20;
    } else if (nTextures == 3) {
      textureIm = im4;
      nTextures += 1;
      heavyFactor = 2;
    } else if (nTextures == 4) {
      textureIm = im1;
      nTextures = 1;
      heavyFactor = 3;
    }
  }
}

public void WindStrength(int w) {
  windFactor = w;
}

public void RenderMasses() {
  if (renderParticles == false)
    renderParticles = true;
  else
    renderParticles = false;
}

public void RenderTexture() {
  if (renderTexture == false)
    renderTexture = true;
  else
    renderTexture = false;
}

public void Reset() {
  renderParticles = true;
  renderTexture = false;
  windActive = false;
  windFactor = 0;
  nTextures = 1;
  //gui.getController("WindStrength").setValue(0);
  //gui.getController("MassSize").setValue(7);
  //gui.getController("Damping").setValue(12);
  //gui.getController("Stiffness").setValue(700);
  //gui.getController("toggle").setValue(0);
  //gui.getController("toggleTexture").setValue(0);
  //gui.getController("toggleMasses").setValue(1);
  settings();
}

void toggle(boolean theFlag) {

  if (theFlag==true) {
    windActive = true;
    colorT = color(42, 117, 28);
  } else {
    colorT = color(143, 53, 50);
    windActive = false;
  }
}

void toggleTexture(boolean theFlag) {
  if (theFlag==true) {
    renderTexture = true;
    colorT2 = color(42, 117, 28);
  } else {
    colorT2 = color(143, 53, 50);
    renderTexture = false;
  }
}

void toggleMasses(boolean theFlag) {
  if (theFlag==true) {
    renderParticles = true;
    colorT3 = color(42, 117, 28);
  } else {
    colorT3 = color(143, 53, 50);
    renderParticles = false;
  }
}


