import processing.opengl.*;

void settings(){
  size(800, 800);
  
}

int row = 10;
int col = 10;
Point plane[][] = new Point[row][col]; // create a 2D-array

float dt = 0.00005;  //Tidssteg
float m = 0.2; //Partikelmasssa
float ks = 2000; //Fjäderkonstant
float kd = -1; //Skapa ett plan
float R = 50; 

void setup() {
  
  
  background(100);
  frameRate(60);
  
  
  //int length = 5; //Simulationstid i sekunder
  
  
  
  for(int i = 0; i < row; i++)
  {
    for(int j = 0; j < col; j++)
    {
      plane[i][j] = new Point(i*50,j*50,1);
    }
    
  }

}


void draw(){
  
  background(100);
  //plane[3][3].z = plane[3][3].z+1;
  plane = forceField(dt,plane,ks,kd,R,m,row,col);
  drawPlane(plane,row,col);
  //print(plane[3][3].z);
}
