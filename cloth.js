
//Size of window and cloth, note that a square cloth is needed
var height = 900;
var width = 1200;
var col = 14;
var row = 14;
var Area = col*row;
var FPS = 60;
var offsetX = 200;
var offsetY = 100;
var DIST = 30;
var MASS_SIZE = 7;
 //Array for storing the particles in the grid

//Simulation constants
var stiffness = -700;
var damping = -2;
var k_air = 0.002;
var mass = 0.2;
var ts = 0.001; //Euler timestep (note that smaller than 0.001 needed for stability)
var gravityInfluenceFactor = 1;
var gravity = [0, -9.81*gravityInfluenceFactor, 0];

//Displaying particles and vareraction
var chosenParticle = (0, 0);
var chosen = false;
var renderParticles = true;

// Wind
var windActive;
var windFactor = 0;
//var colorT = new color(255);
//var colorT2 = color(255);
//var colorT3 = color(255);

// Background and GUI
var renderBackground = false;
var s = "CLOTH SIMULATION";
var info = "This is an vareractive simulation of a cloth. The calculations are based on a var-damper system that is solved using Euler's method";
var instruction = "Press and drag with the left mouse button on a mass to move it. Press TAB to fixate/unfixate a chosen mass.";
var moreInfo = "Change the values of the spring and damping coefficient in order to change the appearance of the cloth. Note that some values may cause an unstable behavior.";
var about = "More info can be found at: \nhttp://github.com/jklvaran/Cloth-Simulation.";



var textureIm;
var im1; 
var im2;
var im3;
var im4;
var nTextures = 1;
var renderTexture = false;
var heavyFactor = 3;

let massSlider, dampingSlider, stiffnessSlider, windSlider;

class particle {

  //Constructor
  constructor(row, col, dist, fix) {
    this.index = [row, col];
    this.initialpos = [(row-1)*dist, (col-1)*dist, 0.0];
    this.pos = (this.initialpos);
    this.oldpos = (this.initialpos);
    this.isfixed = fix;
    this.force = [0, 0, 0];
    this.vel = [0, 0, 0];
  }

  isFixed() {
    return this.isfixed;
  }

  setPos(x, y) {
    this.pos.set(x, y);
  }

  //Draw the particle 
  display() {
    fill(255);
    ellipse(this.pos[0]+offsetX, this.pos[1]+ offsetY, MASS_SIZE, MASS_SIZE);
  }

  getPos() {
    return this.pos;
  }
}

var k = 0;
var theparticles = []

function settings(){
  theparticles = [];
  for(var i = 0; i < row; i++){
    for(var j = 0; j < col; j++){
      if(i == 0 && j == 0 || i == 0 && j == col-1){
        theparticles.push(new particle(j, i, DIST, true));
        k = k + 1;
      }else{
        theparticles.push(new particle(j, i, DIST, false));
        k = k + 1;
      }

    }

}
}
   

function setup() {
  createCanvas(1200, 800);

  for(var i = 0; i < row; i++){
    for(var j = 0; j < col; j++){
      if(i == 0 && j == 0 || i == 0 && j == col-1){
        theparticles.push(new particle(j, i, DIST, true));
        k = k + 1;
      }else{
        theparticles.push(new particle(j, i, DIST, false));
        k = k + 1;
      }

    }
  }

  button = createButton("Display Masses");
  button.position(850, 620);
  button.mousePressed(RenderMasses);
  button.style('background-color: green');
  button.style('color: white');
  button.style('height: 40px');
  button.style('width: 85px');
  button.style('text-align: 12px');

  //  .setLabel("Display Masses")
  // .setColorBackground(color(28, 38, 53))
  //  .setColorActive(color(158, 182, 206))
  //  .setSize(85, 20)
  //  .setLock(true);
  
  // button2 = createButton("Render Texture");
  // button2.position(950, 620);
  // button2.mousePressed(RenderTexture);
  // button2.style('background-color: rgb(28, 38, 53)');
  // button2.style('color: white');
  // button2.style('height: 40px');
  // button2.style('width: 85px');
  // button2.style('text-align: 12px');
  
  button3 = createButton("Toggle wind");
  button3.position(950, 620);
  button3.mousePressed(toggle);
  button3.style('background-color: red');
  button3.style('color: white');
  button3.style('height: 40px');
  button3.style('width: 85px');
  button3.style('text-align: 12px');
  
  // button4 = createButton("Switch Texture");
  // button4.position(950, 700);
  // button4.mousePressed(SwitchText);
  // button4.style('background-color: rgb(28, 38, 53)');
  // button4.style('color: white');
  // button4.style('height: 40px');
  // button4.style('width: 85px');
  // button4.style('text-align: 12px');
  
  reset = createButton("Reset");
  reset.position(1050, 620);
  reset.mousePressed(Reset);
  reset.style('background-color: rgb(28, 38, 53)');
  reset.style('color: white');
  reset.style('height: 40px');
  reset.style('width: 85px');
  reset.style('text-align: 12px');

  massSlider = createSlider(5, 15, 7);
  massSlider.position(850, 375);
  massSlider.style('height: 30px');
  massSlider.style('width: 285px');

  dampingSlider = createSlider(0, 14.9, 12);
  dampingSlider.position(850, 490);
  dampingSlider.style('height: 30px');
  dampingSlider.style('width: 285px');

  stiffnessSlider = createSlider(10, 3000, 700);
  stiffnessSlider.position(850, 430);
  stiffnessSlider.style('height: 30px');
  stiffnessSlider.style('width: 285px');

  windSlider = createSlider(-3000, 3000, 0);
  windSlider.position(850, 555);
  windSlider.style('height: 30px');
  windSlider.style('width: 285px');


}

//****************************** RENDERING LOOP ******************************* //

function draw() {

  windFactor = windSlider.value();
  MASS_SIZE = massSlider.value();
  damping = -(15-dampingSlider.value());
  stiffness = - stiffnessSlider.value();

  console.log(windActive)

  //Background clear
  //emissive(0);
  stroke(0);
  background(color(11, 13, 18));
  fill(color(11, 13, 18));
  rect(2, 2, 1196, 896);

  //Draw the lattice
  theparticles = drawLattice(theparticles);
  theparticles = updateParticles(theparticles); //Update forces acting on particles and positions according to Euler


  //Lights
  //directionalLight(200, 200, 200, 0, 0, -1);
  //ambientLight(255, 255, 255);
  //lightSpecular(255, 255, 255);

  //GUI info
  //emissive(0);
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

  stroke(255);
}

//********************* Create the lattice **********************//
function createLattice(theparticles) {
  for (var rows=0; rows<row; rows++) {
    for (var cols=0; cols<col; cols++) {
      if ((rows == 0 && cols == 0) || rows == 0 && cols == col-1) {
        theparticles[cols][rows] = new particle(cols, rows, DIST, true);
      } else {
        theparticles[cols][rows] = new particle(cols, rows, DIST, false);
      }
    }
  }
}

// Draw lattice
function drawLattice(theparticles) {
  if (!renderTexture) {
   fill(255);
   strokeWeight(1);
   stroke(255);
  }

  for (var y=0; y<row; y++) {
    if (renderTexture) {
      noStroke();
      noFill();
      beginShape(QUAD_STRIP);
      texture(textureIm);
    }
    for (var x=0; x<col; x++) {
      if(theparticles != null){
        if (renderParticles && !renderTexture) {       
          theparticles[x + y*col].display();
        }

      if (renderTexture) {
        if (y < row-1 && x != col && y != row-1) {
          var index = x + y * col;
          var x1 = theparticles[index].pos[0] + offsetX;
          var y1 = theparticles[index].pos[1]+ offsetY;
          var u = map(x, 0, col-1, 0, 1);
          var v1 = map(y, 0, row-1, 0, 1);
          vertex(x1, y1, u, v1);
          index = x + (y+1)* col;
          var x2 = theparticles[index].pos[0] + offsetX;
          var y2 = theparticles[index].pos[1]+ offsetY;
          var v2 = map(y+1, 0, row-1, 0, 1);
          vertex(x2, y2, u, v2);
        }
      }

      if (!renderTexture) {
        var index = x + y * col;
        var index2 = x + (y+1) * col;
        var index3 = (x-1) + y * col;
        var index4 = x + (y-1) * col;
         if (x == 0 && y >= 0 && y < row-1) {
           line(theparticles[index].pos[0] + offsetX, theparticles[index].pos[1]+ offsetY, theparticles[index2].pos[0] + offsetX, theparticles[index2].pos[1]+ offsetY);
         }
         if (y >= 0 && x >= 1) {        
           line(theparticles[index].pos[0] + offsetX, theparticles[index].pos[1]+ offsetY, theparticles[index3].pos[0] + offsetX, theparticles[index3].pos[1]+ offsetY);  

           if (y >= 1) {
             line(theparticles[index].pos[0] + offsetX, theparticles[index].pos[1]+ offsetY, theparticles[index4].pos[0] + offsetX, theparticles[index4].pos[1]+ offsetY);
           }
         }
       }
    }
    }

    if (renderTexture) {
      endShape();
    }
  }
  return theparticles;
}

//************************* Update particles **************************//
function updateParticles(theparticles) {
  var fs1;
  var fs2;
  var fs3; 
  var fs4;
  var fs5;
  var fs6;
  var fs7;
  var fs8;
  var fb1;
  var fb2;
  var fb3;
  var fb4;
  var fb5;
  var fb6;
  var fb7;
  var fb8;
  var xij;
  var norm_xij;
  var L; 

  var xoff = 0;
  for (var r = 0; r < row; r++) {
    var yoff = 0;
    for (var c = 0; c < col; c++) {

      var nois = noise(xoff, yoff); //Wind noise

      // Stiffnes forces
      fs1 = [0.0, 0.0];
      fs2 =  [0.0, 0.0];
      fs3 =  [0.0, 0.0];
      fs4 =  [0.0, 0.0];
      fs5 =  [0.0, 0.0];
      fs6 =  [0.0, 0.0];
      fs7 =  [0.0, 0.0];
      fs8 =  [0.0, 0.0];

      // Damping forces
      fb1 =  [0.0, 0.0];
      fb2 =  [0.0, 0.0];
      fb3 =  [0.0, 0.0];
      fb4 =  [0.0, 0.0];
      fb5 =  [0.0, 0.0];
      fb6 = [0.0, 0.0];
      fb7 =  [0.0, 0.0];
      fb8 =  [0.0, 0.0];

      L = 10; //Initial link

      //Update forces for 4-neighbours (stretching forces)
      //Update forces for 8-neighbours (shearing forces)
      //Spring force according to Hook's law 
      //Damping force according to linear damping of velocity

      var ind = r + c * col;
      var ind2 = (r+1) + c * col;
      var ind3 = r + (c+1)*col;
      var ind4 = (r-1)+(c+1)*col;
      var ind5 = (r-1) + c *col;
      var ind6 = r + (c-1)*col;
      var ind1 = (r+1) + (c-1)*col;
      var ind7 = (r+1) + (c+1)*col;
      var ind8 = (r-1) + (c-1)*col;

      // Mass below
      if (r < row-1) {
         L = Math.sqrt( Math.pow((theparticles[ind].initialpos[0]-theparticles[ind2].initialpos[0]), 2) + Math.pow((theparticles[ind].initialpos[1]-theparticles[ind2].initialpos[1]), 2) );

         xij = [theparticles[ind].pos[0]-theparticles[ind2].pos[0], theparticles[ind].pos[1]-theparticles[ind2].pos[1], 0];
        norm_xij = Math.sqrt(Math.pow(xij[0],2) + Math.pow(xij[1],2));
        var s = norm_xij - L;
        var t = -stiffness*s;
        var j = [xij[0]/norm_xij, xij[1]/norm_xij, 0];
        fs2 = [j[0]*t, j[1]*t, 0];
        var n =[theparticles[ind].vel[0]-theparticles[ind2].vel[0], theparticles[ind].vel[1]-theparticles[ind2].vel[1], 0];
        fb2 = [n[0]*(-damping), n[1]*(-damping), 0];
      }

      // // Mass to the right
      if (c < col-1) {
        L = Math.sqrt( Math.pow((theparticles[ind].initialpos[0]-theparticles[ind3].initialpos[0]), 2) + Math.pow((theparticles[ind].initialpos[1]-theparticles[ind3].initialpos[1]), 2) );

        xij = [theparticles[ind].pos[0]-theparticles[ind3].pos[0], theparticles[ind].pos[1]-theparticles[ind3].pos[1], 0];
       norm_xij = Math.sqrt(Math.pow(xij[0],2) + Math.pow(xij[1],2));
       var s = norm_xij - L;
       var t = -stiffness*s;
       var j = [xij[0]/norm_xij, xij[1]/norm_xij, 0];
       fs3 = [j[0]*t, j[1]*t, 0];
       var n =[theparticles[ind].vel[0]-theparticles[ind3].vel[0], theparticles[ind].vel[1]-theparticles[ind3].vel[1], 0];
       fb3 = [n[0]*(-damping), n[1]*(-damping), 0];
      }

      // // Mass above
      if (r > 0) {
        L = Math.sqrt( Math.pow((theparticles[ind].initialpos[0]-theparticles[ind5].initialpos[0]), 2) + Math.pow((theparticles[ind].initialpos[1]-theparticles[ind5].initialpos[1]), 2) );

        xij = [theparticles[ind].pos[0]-theparticles[ind5].pos[0], theparticles[ind].pos[1]-theparticles[ind5].pos[1], 0];
       norm_xij = Math.sqrt(Math.pow(xij[0],2) + Math.pow(xij[1],2));
       var s = norm_xij - L;
       var t = -stiffness*s;
       var j = [xij[0]/norm_xij, xij[1]/norm_xij, 0];
       fs5 = [j[0]*t, j[1]*t, 0];
       var n =[theparticles[ind].vel[0]-theparticles[ind5].vel[0], theparticles[ind].vel[1]-theparticles[ind5].vel[1], 0];
       fb5 = [n[0]*(-damping), n[1]*(-damping), 0];
      }

      // // Mass to the left
      if (c > 0) {
        L = Math.sqrt( Math.pow((theparticles[ind].initialpos[0]-theparticles[ind6].initialpos[0]), 2) + Math.pow((theparticles[ind].initialpos[1]-theparticles[ind6].initialpos[1]), 2) );

        xij = [theparticles[ind].pos[0]-theparticles[ind6].pos[0], theparticles[ind].pos[1]-theparticles[ind6].pos[1], 0];
        norm_xij = Math.sqrt(Math.pow(xij[0],2) + Math.pow(xij[1],2));
        var s = norm_xij - L;
        var t = -stiffness*s;
        var j = [xij[0]/norm_xij, xij[1]/norm_xij, 0];
        fs6 = [j[0]*t, j[1]*t, 0];
        var n =[theparticles[ind].vel[0]-theparticles[ind6].vel[0], theparticles[ind].vel[1]-theparticles[ind6].vel[1], 0];
        fb6 = [n[0]*(-damping), n[1]*(-damping), 0];
      }

      // // Mass diagonal, top right
      if (r > 0 && c < col-1) {
        L = Math.sqrt( Math.pow((theparticles[ind].initialpos[0]-theparticles[ind4].initialpos[0]), 2) + Math.pow((theparticles[ind].initialpos[1]-theparticles[ind4].initialpos[1]), 2) );
        xij = [theparticles[ind].pos[0]-theparticles[ind4].pos[0], theparticles[ind].pos[1]-theparticles[ind4].pos[1], 0];
        norm_xij = Math.sqrt(Math.pow(xij[0],2) + Math.pow(xij[1],2));
        var s = norm_xij - L;
        var t = -stiffness*s;
        var j = [xij[0]/norm_xij, xij[1]/norm_xij, 0];
        fs4 = [j[0]*t, j[1]*t, 0];
        var n =[theparticles[ind].vel[0]-theparticles[ind4].vel[0], theparticles[ind].vel[1]-theparticles[ind4].vel[1], 0];
        fb4 = [n[0]*(-damping), n[1]*(-damping), 0];
      }

      // // Mass diagonal, down left
      if (r < row-1 && c > 0) {
        L = Math.sqrt( Math.pow((theparticles[ind].initialpos[0]-theparticles[ind1].initialpos[0]), 2) + Math.pow((theparticles[ind].initialpos[1]-theparticles[ind1].initialpos[1]), 2) );

        xij = [theparticles[ind].pos[0]-theparticles[ind1].pos[0], theparticles[ind].pos[1]-theparticles[ind1].pos[1], 0];
        norm_xij = Math.sqrt(Math.pow(xij[0],2) + Math.pow(xij[1],2));
        var s = norm_xij - L;
        var t = -stiffness*s;
        var j = [xij[0]/norm_xij, xij[1]/norm_xij, 0];
        fs1 = [j[0]*t, j[1]*t, 0];
        var n =[theparticles[ind].vel[0]-theparticles[ind1].vel[0], theparticles[ind].vel[1]-theparticles[ind1].vel[1], 0];
        fb1 = [n[0]*(-damping), n[1]*(-damping), 0];
      }

      // // Mass diagonal, down right
      if (r < row-1 && c < col-1) {
        L = Math.sqrt( Math.pow((theparticles[ind].initialpos[0]-theparticles[ind7].initialpos[0]), 2) + Math.pow((theparticles[ind].initialpos[1]-theparticles[ind7].initialpos[1]), 2) );

        xij = [theparticles[ind].pos[0]-theparticles[ind7].pos[0], theparticles[ind].pos[1]-theparticles[ind7].pos[1], 0];
        norm_xij = Math.sqrt(Math.pow(xij[0],2) + Math.pow(xij[1],2));
        var s = norm_xij - L;
        var t = -stiffness*s;
        var j = [xij[0]/norm_xij, xij[1]/norm_xij, 0];
        fs7 = [j[0]*t, j[1]*t, 0];
        var n =[theparticles[ind].vel[0]-theparticles[ind7].vel[0], theparticles[ind].vel[1]-theparticles[ind7].vel[1], 0];
        fb7 = [n[0]*(-damping), n[1]*(-damping), 0];
      }

      // //// Mass diagonal, top left
      if (r > 0 && c > 0) {
        L = Math.sqrt( Math.pow((theparticles[ind].initialpos[0]-theparticles[ind8].initialpos[0]), 2) + Math.pow((theparticles[ind].initialpos[1]-theparticles[ind8].initialpos[1]), 2) );

        xij = [theparticles[ind].pos[0]-theparticles[ind8].pos[0], theparticles[ind].pos[1]-theparticles[ind8].pos[1], 0];
        norm_xij = Math.sqrt(Math.pow(xij[0],2) + Math.pow(xij[1],2));
        var s = norm_xij - L;
        var t = -stiffness*s;
        var j = [xij[0]/norm_xij, xij[1]/norm_xij, 0];
        fs8 = [j[0]*t, j[1]*t, 0];
        var n =[theparticles[ind].vel[0]-theparticles[ind8].vel[0], theparticles[ind].vel[1]-theparticles[ind8].vel[1], 0];
        fb8 = [n[0]*(-damping), n[1]*(-damping), 0];
      }

      var windx = map(noise(yoff, xoff), 0, 1, 0, 10);
      var windy = map(noise(yoff + 3000, xoff+3000), -100, 1, -100, 0);
      var wind = [0, 0];

      if (windActive){
      wind = [windx*windFactor/heavyFactor, windy*windFactor/heavyFactor];
      }

      var index = r + c*col;
      var AirResistance =  [-theparticles[index].vel[0]*k_air*Area, -theparticles[index].vel[1]*k_air*Area, 0];
      theparticles[index].force = [0-fs1[0]-fb1[0]-fs2[0]-fb2[0]-fs3[0]-fb3[0]-fs4[0]-fb4[0]-fs5[0]-fb5[0]-fs6[0]-fb6[0]-fs7[0]-fb7[0]-fs8[0]-fb8[0]+AirResistance[0]+wind[0], 9.81*70-fs1[1]-fb1[1]-fs2[1]-fb2[1]-fs3[1]-fb3[1]-fs4[1]-fb4[1]-fs5[1]-fb5[1]-fs6[1]-fb6[1]-fs7[1]-fb7[1]-fs8[1]-fb8[1]+AirResistance[1]+wind[1], 0];

      xoff += 10;
    }
    yoff += 10;
  }

  ////Position, velocity, and accelleration update for all nodes
  for (var r = 0; r < row; r++) {      
    for (var c = 0; c < col; c++) {
      var index = c + r*col;
      if (!theparticles[index].isfixed) {  //Upate all nodes except the fixed ones 

        theparticles[index].acc = [theparticles[index].force[0]/mass, theparticles[index].force[1]/mass, 0];
        theparticles[index].vel = [xtEuler(theparticles[index].vel[0], theparticles[index].acc[0], ts), xtEuler(theparticles[index].vel[1], theparticles[index].acc[1], ts), 0];
        theparticles[index].pos = [xtEuler(theparticles[index].pos[0], theparticles[index].vel[0], ts), xtEuler(theparticles[index].pos[1], theparticles[index].vel[1], ts), 0];
      }
    }
  }
  
  return theparticles;
}

//**************************  EULERS METHOD ********************************//
function xtEuler(xt, xtPrim,  h) {
  return xt + h*xtPrim;
}

//**************************  USER varERACTION ********************************//

//Fix and unfix particles
function keyPressed() {
  if (keyPressed && keyCode == TAB) {
    if (chosen == true) {
      if (theparticles[chosenParticle].isFixed()) {
        theparticles[chosenParticle].isfixed = false;
      } else {
        theparticles[chosenParticle].isfixed = true;
      }
    }
  }
}

//Chose a specific particle
function mousePressed() { 
  if (mousePressed && mouseButton == LEFT) {
    var mousePos = [mouseX, mouseY];
    for (var r = 0; r < row; r++) {
      for (var c = 0; c < col; c++) {
        var index = r + c * col;  
        if (abs(theparticles[index].pos[0] - (mousePos[0]-offsetX)) < 15 && abs(theparticles[index].pos[1] - (mousePos[1]-offsetY)) < 15) {
          chosenParticle = r + c *col;
          chosen = true;
          return;
        }
      }
    }
  }
}

function mouseReleased() {
  chosen = false;
}

//Move the current particle
function mouseDragged() {
  if (chosen) {
    theparticles[chosenParticle].pos = [mouseX-200, mouseY-100, 0];
  }
}

//******************************* GUI ********************************//






function Stiffness(ks) {
  stiffness = -ks;
}

function Damping(kd) {
  damping = -(15-kd);
}

function MassSize(size) {
  MASS_SIZE = size;
}

function Gravity(g) {
  gravityInfluenceFactor = g;
}

function SwitchText() {
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

function WindStrength(w) {
  windFactor = w;
}

function RenderMasses() {
  if (renderParticles == false){
    renderParticles = true;
    button.style('background-color: green');
}else{
    renderParticles = false;
    button.style('background-color: red');
  }
}

function RenderTexture() {
  if (renderTexture == false)
    renderTexture = true;
  else
    renderTexture = false;
}

function Reset() {
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

function toggle() {
  console.log("HELLO WIND")

  if(windActive == true){
    windActive = false;
    button3.style('background-color: red');
  }else{
    windActive =true;
    button3.style('background-color: green')
  }
  console.log(windActive)
  // if (theFlag==true) {
  //   windActive = true;
  //   colorT = color(42, 117, 28);
  // } else {
  //   colorT = color(143, 53, 50);
  //   windActive = false;
  // }
}

function toggleTexture(theFlag) {
  if (theFlag==true) {
    renderTexture = true;
    colorT2 = color(42, 117, 28);
  } else {
    colorT2 = color(143, 53, 50);
    renderTexture = false;
  }
}

function toggleMasses(theFlag) {
  if (theFlag==true) {
    renderParticles = true;
    colorT3 = color(42, 117, 28);
  } else {
    colorT3 = color(143, 53, 50);
    renderParticles = false;
  }
}