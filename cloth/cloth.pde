//Cloth simulation

//Basic variables
int height = 200;
int width = 400;
int col = 8;
int row = 8;
float stiffness = 40;
float damping = 12;
float mass = 1;
float ts = 1;
PVector gravity = new PVector(0, -9.81);

particle[][] theparticles = new particle[row][col]; //Array for storing the particles in the grid

import controlP5.*; // import controlP5 library
ControlP5 controlP5; // controlP5 object

void settings(){
  size(900, 600); //Size of window
  
  //Create lattice grid for cloth
  createLattice();
    
}

void setup(){

  frameRate(1);
  
  //Interactive GUI menu
  controlP5 = new ControlP5(this);
  controlP5.addSlider("Damping",10,100,30,700,30,30,120); // parameters : name, minimum, maximum, default value (float), x, y, width, height
  controlP5.addSlider("Stiffness",10,100,30,780,30,30,120); // parameters : name, minimum, maximum, default value (float), x, y, width, height
  //controlP5.addNumberbox("numberbox1",100,650,30,100,40); // parameters : name, default value, posX, posY, sizeX, sizeY
  
  background(0, 0, 0);
  stroke(255);
  



}


void draw(){
  background(0);
  
  //Draw the particles
  drawLattice();
  
  //Calculate forces
  updateParticles();
  
  //print(theparticles[1][1].pos);
  
  //Update positions with numerical method

}


void createGUI(){
}

// Create the lattice
void createLattice(){
  for(int r=0; r<row; r++){
    for(int c=0; c<col; c++){
      if(r == 0){
        theparticles[r][c] = new particle(r, c, 40, true);
        print("fixed");
      }else{
       theparticles[r][c] = new particle(r, c, 40, false);
      }
    }
  }
}

// Draw lattice
void drawLattice(){
  for(int r=0; r<row; r++){
    for(int c=0; c<col; c++){
       theparticles[r][c].display();
       if(r >= 1 && c >= 1){
          strokeWeight(1);
          line(theparticles[r-1][c].pos.x, theparticles[r-1][c].pos.y, theparticles[r][c].pos.x, theparticles[r][c].pos.y);
          line(theparticles[r][c-1].pos.x, theparticles[r][c-1].pos.y, theparticles[r][c].pos.x, theparticles[r][c].pos.y);
          line(theparticles[r-1][c-1].pos.x, theparticles[r-1][c-1].pos.y, theparticles[r][c].pos.x, theparticles[r][c].pos.y);
       }
    }
  }
}

// Update particles
void updateParticles(){
    int nextRow, prevRow, nextCol, prevCol;
    PVector fs1, fs2, fs3, fs4, fs5, fs6, fs7, fs8, fb1, fb2, fb3, fb4, fb5, fb6, fb7, fb8, xij;
    float norm_xij, L; 
    
    for(int r = 0; r < row; r++){
        nextRow = r + 1;
        prevRow = r - 1;
        
        for(int c = 0; c < col; c++){
            nextCol = c + 1;
            prevCol = c - 1;
            
            // Stiffnes forces
            fs1 = new PVector(0.0 , 0.0);
            fs2 = new PVector(0.0 , 0.0);
            fs3 = new PVector(0.0 , 0.0);
            fs4 = new PVector(0.0 , 0.0);
            fs5 = new PVector(0.0 , 0.0);
            fs6 = new PVector(0.0 , 0.0);
            fs7 = new PVector(0.0 , 0.0);
            fs8 = new PVector(0.0 , 0.0);
            
            // Damping forces
            fb1 = new PVector(0.0 , 0.0);
            fb2 = new PVector(0.0 , 0.0);
            fb3 = new PVector(0.0 , 0.0);
            fb4 = new PVector(0.0 , 0.0);
            fb5 = new PVector(0.0 , 0.0);
            fb6 = new PVector(0.0 , 0.0);
            fb7 = new PVector(0.0 , 0.0);
            fb8 = new PVector(0.0 , 0.0);
           
            L = 10; //Initial link
            
            //Link 1
            if (r < row-1 && c > 0){
                L = theparticles[r][c].initialpos.dist(theparticles[nextRow][prevCol].initialpos);
                xij = PVector.sub(theparticles[r][c].pos, theparticles[nextRow][prevCol].pos);
                norm_xij = xij.mag();           
                float s = norm_xij - L;
                float t = -stiffness*s;
                PVector j = xij.div(norm_xij);
                fs1 = j.mult(t);
                PVector n = PVector.sub(theparticles[r][c].vel, theparticles[nextRow][prevCol].vel);
                fb1 = n.mult(-damping);
            }

            // Link 2
            if (r < row-1){
                L = theparticles[r][c].initialpos.dist(theparticles[nextRow][c].initialpos);
                xij = PVector.sub(theparticles[r][c].pos, theparticles[nextRow][c].pos);
                norm_xij = xij.mag();
                float s = norm_xij - L;
                float t = -stiffness*s;
                PVector j = PVector.div(xij, norm_xij);
                fs2 = PVector.mult(j, t);
                PVector n = PVector.sub(theparticles[r][c].vel, theparticles[nextRow][c].vel);
                fb2 = PVector.mult(n, -damping);
            }

            //Link 3
            if (c < col-1){
                L = PVector.dist(theparticles[r][c].initialpos, theparticles[r][nextCol].initialpos);
                xij = PVector.sub(theparticles[r][c].pos, theparticles[r][nextCol].pos);
                norm_xij = xij.mag();
                float s = norm_xij - L;
                float t = -stiffness*s;
                PVector j = PVector.div(xij, norm_xij);
                fs3 = PVector.mult(j, t);
                PVector n = PVector.sub(theparticles[r][c].vel, theparticles[r][nextCol].vel);
                fb3 = PVector.mult(n, -damping);
            }

            // Link 4
            if (r > 0 && c < col-1){
                L = theparticles[r][c].initialpos.dist(theparticles[prevRow][nextCol].initialpos);
                xij = PVector.sub(theparticles[r][c].pos, theparticles[prevRow][nextCol].pos);
                norm_xij = xij.mag();
                float s = norm_xij - L;
                float t = -stiffness*s;
                PVector j = PVector.div(xij, norm_xij);
                fs4 = PVector.mult(j, t);
                PVector n = PVector.sub(theparticles[r][c].vel, theparticles[prevRow][nextCol].vel);
                fb4 = PVector.mult(n, -damping);
            }

            //Link 5
            if (r > 0){
                L = theparticles[r][c].initialpos.dist(theparticles[prevRow][c].initialpos);
                xij = PVector.sub(theparticles[r][c].pos, theparticles[prevRow][c].pos);
                norm_xij = xij.mag();
                float s = norm_xij - L;
                float t = -stiffness*s;
                PVector j = PVector.div(xij, norm_xij);
                fs5 = PVector.mult(j, t);
                PVector n = PVector.sub(theparticles[r][c].vel, theparticles[prevRow][c].vel);
                fb5 = PVector.mult(n, -damping);
            }

            //Link 6
            if (c > 0){
                L = theparticles[r][c].initialpos.dist(theparticles[r][prevCol].initialpos);
                xij = PVector.sub(theparticles[r][c].pos, theparticles[r][prevCol].pos);
                norm_xij = xij.mag();
                float s = norm_xij - L;
                float t = -stiffness*s;
                PVector j = PVector.div(xij, norm_xij);
                fs6 = PVector.mult(j, t);
                PVector n = PVector.sub(theparticles[r][c].vel, theparticles[r][prevCol].vel);
                fb6 = PVector.mult(n, -damping);
            }
            
            // Link 7
            if (r < row-1 && c < col-1){
                L = theparticles[r][c].initialpos.dist(theparticles[nextRow][nextCol].initialpos);
                xij = PVector.sub(theparticles[r][c].pos, theparticles[nextRow][nextCol].pos);
                norm_xij = xij.mag();
                float s = norm_xij - L;
                float t = -stiffness*s;
                PVector j = PVector.div(xij, norm_xij);
                fs7 = PVector.mult(j, t);
                PVector n = PVector.sub(theparticles[r][c].vel, theparticles[nextRow][nextCol].vel);
                fb7 = PVector.mult(n, -damping);
            }
            
            // Link 8
            if (r > 0 && c > 0){
                L = theparticles[r][c].initialpos.dist(theparticles[prevRow][prevCol].initialpos);
                xij = PVector.sub(theparticles[r][c].pos, theparticles[prevRow][prevCol].pos);
                norm_xij = xij.mag();
                float s = norm_xij - L;
                float t = -stiffness*s;
                PVector j = PVector.div(xij, norm_xij);
                fs8 = PVector.mult(j, t);
                PVector n = PVector.sub(theparticles[r][c].vel, theparticles[prevRow][prevCol].vel);
                fb8 = PVector.mult(n, -damping);
            }

            PVector def = new PVector(0,0,0);
            PVector allForces = def.add(fs1).add(fs2).add(fs3).add(fs4).add(fs5).add(fs6).add(fs7)
                                        .add(fs8).add(fb1).add(fb2).add(fb3).add(fb4).add(fb5)
                                        .add(fb6).add(fb7).add(fb8)
                                        .add(PVector.mult(gravity, mass)).sub(theparticles[r][c].force);
            theparticles[r][c].force.set(0, 9.81);// = new PVector(0, -9999.81, 0);
            //disp(node(r,c).force)

        }
    }

    ////Position, velocity, and accelleration update for all nodes
    for(int r = 0; r < row; r++){      
        for(int c = 0; c < col; c++){
            if(r != 0){  //Upate all nodes except the fixed ones 

                theparticles[r][c].acc.set(PVector.div(theparticles[r][c].force, mass));
                theparticles[r][c].vel.set(theparticles[r][c].vel.x + ts*theparticles[r][c].acc.x, theparticles[r][c].vel.y + ts*theparticles[r][c].acc.y);
                theparticles[r][c].pos.set(theparticles[r][c].pos.x + ts*theparticles[r][c].vel.x, theparticles[r][c].pos.y + ts*theparticles[r][c].vel.y);
                //print(theparticles[r][c].pos);
                
                //Euler method for updating position and velocity
                //theparticles[r][c].vel.x = xtEuler(theparticles[r][c].vel.x, theparticles[r][c].acc.x, ts);
                //theparticles[r][c].vel.y = xtEuler(theparticles[r][c].vel.y, theparticles[r][c].acc.y, ts);
                //theparticles[r][c].pos.x = xtEuler(theparticles[r][c].pos.x, theparticles[r][c].vel.x, ts);
                //theparticles[r][c].pos.y = xtEuler(theparticles[r][c].pos.y, theparticles[r][c].vel.y, ts);
                //theparticles[r][c].setPos(xtEuler(theparticles[r][c].pos.x, theparticles[r][c].vel.x, ts), xtEuler(theparticles[r][c].pos.y, theparticles[r][c].vel.y, ts));
                
               // print(theparticles[r][c].pos);
                //Verlet method for updating position and velocity
                //[node(r,c).pos_old, node(r,c).pos, node(r,c).vel] = Verlet(node(r,c).pos, node(r,c).pos_old, node(r,c).acc, ts);
            }else{
              print("FIXED");
              theparticles[r][c].isfixed = false;
              theparticles[r][c].pos.set((r-1)*20, (c-1)*20);
            }
        }
    }

}

// Update velocity or position according to Eulers method
float xtEuler(float xt, float xtPrim, float h){
  return xt + h*xtPrim;
}
