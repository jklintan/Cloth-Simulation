void settings(){
  size(800, 800);
  
}

int row = 10;
int col = 10;
Point plane[][] = new Point[row][col]; // create a 2D-array

float dt = 0.0005;  //Tidssteg
float m = 20/(row*col); //Partikelmasssa
float ks = 1; //Fjäderkonstant
float kd = 1; //Skapa ett plan
float R = 1; 

void setup() {
  
  
  background(100);
  frameRate(60);
  
  
  //int length = 5; //Simulationstid i sekunder
  
  
  
  for(int i = 0; i < row; i++)
  {
    for(int j = 0; j < col; j++)
    {
      plane[i][j] = new Point(i,j,1);
    }
    
  }

}


void draw(){
  
  background(100);
  //plane[3][3].z = plane[3][3].z+1;
  //plane = forceField(dt,plane,ks,kd,R,m,row,col);
  //drawPlane(plane,row,col);
  //print(plane[3][3].z);
  print(plane[3][3].y);
}
