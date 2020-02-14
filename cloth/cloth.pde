//Cloth simulation

//Basic variables
int height = 200;
int width = 400;
int col = 15;
int row = 15;
float stiffness = -20;
float damping = -4;
float mass = 0.2;
float ts = 0.001;
int FPS = 60;
PVector gravity = new PVector(0, -9.81);

particle[][] theparticles = new particle[row][col]; //Array for storing the particles in the grid

import controlP5.*; // import controlP5 library
ControlP5 controlP5; // controlP5 object

void settings(){
  size(800, 800); //Size of window
  
  //Create lattice grid for cloth
  createLattice();
    
}

void setup(){

  frameRate(60);
  
  //Interactive GUI menu
  controlP5 = new ControlP5(this);
  //controlP5.addSlider("Damping",10,100,30,700,30,30,120); // parameters : name, minimum, maximum, default value (float), x, y, width, height
  //controlP5.addSlider("Stiffness",10,100,30,780,30,30,120); // parameters : name, minimum, maximum, default value (float), x, y, width, height
  //controlP5.addNumberbox("numberbox1",100,650,30,100,40); // parameters : name, default value, posX, posY, sizeX, sizeY
  
  background(0, 0, 0);
  stroke(255);
  
  //for(int rows=0; rows<row; rows++){
  //  for(int cols=0; cols<col; cols++){
  //    theparticles[cols][rows].setPos(0, rows);
  //  }
  //}
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
  for(int rows=0; rows<row; rows++){
    for(int cols=0; cols<col; cols++){
      if(rows == 0 && cols == col-1){
         theparticles[cols][rows] = new particle(cols, rows,20, true);
      }
      else if(rows == 0 && cols == 0){
       theparticles[cols][rows] = new particle(cols, rows,20, true);
      //  print("fixed");
      }else{
       theparticles[cols][rows] = new particle(cols, rows, 20, false);
      }
    }
  }
}

// Draw lattice
void drawLattice(){
  for(int y=0; y<row; y++){
    for(int x=0; x<col; x++){
       theparticles[y][x].display();
       strokeWeight(0.5);
       if(x == 0 && y >= 0 && y < row-1){
         line(theparticles[y][x].pos.x +150, theparticles[y][x].pos.y +150, theparticles[y+1][x].pos.x +150, theparticles[y+1][x].pos.y +150);
       }
       if(y == 0 && x >= 0 && x < col-1){
         //line(theparticles[y][x].pos.x, theparticles[y][x].pos.y, theparticles[y][x+1].pos.x, theparticles[y][x+1].pos.y);
       }
       if(y >= 0 && x >= 1){
          
          line(theparticles[y][x].pos.x +150, theparticles[y][x].pos.y +150, theparticles[y][x-1].pos.x +150, theparticles[y][x-1].pos.y +150);
          
          
          
          if(y >= 1){
            line(theparticles[y][x].pos.x + 150, theparticles[y][x].pos.y + 150, theparticles[y-1][x].pos.x + 150, theparticles[y-1][x].pos.y +150);
        
            //line(theparticles[y][x-1].pos.x, theparticles[y][x-1].pos.y, theparticles[y][x].pos.x, theparticles[y][x].pos.y);      
            //line(theparticles[y-1][x-1].pos.x, theparticles[y-1][x-1].pos.y, theparticles[y][x].pos.x, theparticles[y][x].pos.y);
          }  
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
                L = theparticles[c][r].initialpos.dist(theparticles[prevCol][nextRow].initialpos);
                xij = PVector.sub(theparticles[c][r].pos, theparticles[prevCol][nextRow].pos);
                norm_xij = xij.mag();           
                float s = norm_xij - L;
                float t = -stiffness*s;
                PVector j = xij.div(norm_xij);
                fs1 = j.mult(t);
                PVector n = PVector.sub(theparticles[c][r].vel, theparticles[prevCol][nextRow].vel);
                fb1 = n.mult(-damping);
            }

            // Link 2
            if (r < row-1){
                L = theparticles[c][r].initialpos.dist(theparticles[c][nextRow].initialpos);
                xij = PVector.sub(theparticles[c][r].pos, theparticles[c][nextRow].pos);
                norm_xij = xij.mag();
                float s = norm_xij - L;
                float t = -stiffness*s;
                PVector j = PVector.div(xij, norm_xij);
                fs2 = PVector.mult(j, t);
                PVector n = PVector.sub(theparticles[c][r].vel, theparticles[c][nextRow].vel);
                fb2 = PVector.mult(n, -damping);
            }

            ////Link 3
            if (c < col-1){
                L = PVector.dist(theparticles[c][r].initialpos, theparticles[nextCol][r].initialpos);
                xij = PVector.sub(theparticles[c][r].pos, theparticles[nextCol][r].pos);
                norm_xij = xij.mag();
                float s = norm_xij - L;
                float t = -stiffness*s;
                PVector j = PVector.div(xij, norm_xij);
                fs3 = PVector.mult(j, t);
                PVector n = PVector.sub(theparticles[c][r].vel, theparticles[nextCol][r].vel);
                fb3 = PVector.mult(n, -damping);
            }

            //// Link 4
            if (r > 0 && c < col-1){
                L = theparticles[c][r].initialpos.dist(theparticles[nextCol][prevRow].initialpos);
                xij = PVector.sub(theparticles[c][r].pos, theparticles[nextCol][prevRow].pos);
                norm_xij = xij.mag();
                float s = norm_xij - L;
                float t = -stiffness*s;
                PVector j = PVector.div(xij, norm_xij);
                fs4 = PVector.mult(j, t);
                PVector n = PVector.sub(theparticles[c][r].vel, theparticles[nextCol][prevRow].vel);
                fb4 = PVector.mult(n, -damping);
            }

            ////Link 5
            if (r > 0){
                L = theparticles[c][r].initialpos.dist(theparticles[c][prevRow].initialpos);
                xij = PVector.sub(theparticles[c][r].pos, theparticles[c][prevRow].pos);
                norm_xij = xij.mag();
                float s = norm_xij - L;
                float t = -stiffness*s;
                PVector j = PVector.div(xij, norm_xij);
                fs5 = PVector.mult(j, t);
                PVector n = PVector.sub(theparticles[c][r].vel, theparticles[c][prevRow].vel);
                fb5 = PVector.mult(n, -damping);
            }

            ////Link 6
            if (c > 0){
                L = theparticles[c][r].initialpos.dist(theparticles[prevCol][r].initialpos);
                xij = PVector.sub(theparticles[c][r].pos, theparticles[prevCol][r].pos);
                norm_xij = xij.mag();
                float s = norm_xij - L;
                float t = -stiffness*s;
                PVector j = PVector.div(xij, norm_xij);
                fs6 = PVector.mult(j, t);
                PVector n = PVector.sub(theparticles[c][r].vel, theparticles[prevCol][r].vel);
                fb6 = PVector.mult(n, -damping);
            }
            
            // Link 7
            if (r < row-1 && c < col-1){
                L = theparticles[c][r].initialpos.dist(theparticles[nextCol][nextRow].initialpos);
                xij = PVector.sub(theparticles[c][r].pos, theparticles[nextCol][nextRow].pos);
                norm_xij = xij.mag();
                float s = norm_xij - L;
                float t = -stiffness*s;
                PVector j = PVector.div(xij, norm_xij);
                fs7 = PVector.mult(j, t);
                PVector n = PVector.sub(theparticles[c][r].vel, theparticles[nextCol][nextRow].vel);
                fb7 = PVector.mult(n, -damping);
            }
            
            //// Link 8
            if (r > 0 && c > 0){
                L = theparticles[c][r].initialpos.dist(theparticles[prevCol][prevRow].initialpos);
                xij = PVector.sub(theparticles[c][r].pos, theparticles[prevCol][prevRow].pos);
                norm_xij = xij.mag();
                float s = norm_xij - L;
                float t = -stiffness*s;
                PVector j = PVector.div(xij, norm_xij);
                fs8 = PVector.mult(j, t);
                PVector n = PVector.sub(theparticles[c][r].vel, theparticles[prevCol][prevRow].vel);
                fb8 = PVector.mult(n, -damping);
            }

            PVector def = new PVector(0,0,0);
            //PVector allForces = def.add(fs1).add(fs2).add(fs3).add(fs4).add(fs5).add(fs6).add(fs7)
            //                            .add(fs8).add(fb1).add(fb2).add(fb3).add(fb4).add(fb5)
            //                            .add(fb6).add(fb7).add(fb8)
            //                            .add(PVector.mult(gravity, mass)).sub(theparticles[r][c].force);
            theparticles[c][r].force = def.sub(fs1).sub(fs2).sub(fs3).sub(fs4).sub(fs5).sub(fs6).sub(fs7)
                                        .sub(fs8).sub(fb1).sub(fb2).sub(fb3).sub(fb4).sub(fb5)
                                        .sub(fb6).sub(fb7).sub(fb8)
                                        .sub(PVector.mult(gravity, mass));
            theparticles[c][r].force.add(theparticles[c][r].force);
           //theparticles[c][r].force = def.sub(PVector.mult(gravity, mass)).mult(2);
           print(theparticles[1][1].force + "\n");

        }
    }

    ////Position, velocity, and accelleration update for all nodes
    for(int r = 0; r < row; r++){      
        for(int c = 0; c < col; c++){
            if(!theparticles[c][r].isfixed){  //Upate all nodes except the fixed ones 
                theparticles[c][r].acc.set(PVector.div(theparticles[c][r].force, mass));
               // PVector lastPos = theparticles[c][r].pos;
               // theparticles[c][r].pos.set(2*theparticles[c][r].pos.x - theparticles[c][r].oldpos.x + ts*ts*theparticles[c][r].acc.x, 2*theparticles[c][r].pos.y - theparticles[c][r].oldpos.y + ts*ts*theparticles[c][r].acc.y);
                //theparticles[c][r].vel.set(1/2*ts * theparticles[c][r].pos.x - lastPos.x, 1/2*ts * theparticles[c][r].pos.y - lastPos.y);
                //theparticles[c][r].oldpos.set(theparticles[c][r].pos);

               theparticles[c][r].vel.set(theparticles[c][r].vel.x + ts*theparticles[c][r].acc.x, theparticles[c][r].vel.y + ts*theparticles[c][r].acc.y);
               theparticles[c][r].pos.set(theparticles[c][r].pos.x + ts*theparticles[c][r].vel.x, theparticles[c][r].pos.y + ts*theparticles[c][r].vel.y);
                //print(theparticles[c][r].pos);

                
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
              //print(theparticles[r][c].pos);
              //theparticles[r][c].isfixed = false;
              //theparticles[r][c].pos.set((r-1)*20, (c-1)*20);
            }
        }
    }

}

// Update velocity or position according to Eulers method
float xtEuler(float xt, float xtPrim, float h){
  return xt + h*xtPrim;
}
