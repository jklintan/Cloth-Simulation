class Point{
  
    float x;
    float y;
    float z;

    PVector prevVel;
    
    boolean ifPad;

    Point(float i, float j, float k)
    {
      x = i; 
      y = j;
      z = k; 
      ifPad = false;
      prevVel = new PVector(0,0,0);
    }

    void setPrevVel(float i, float j, float k)
    {
      prevVel.x = i;
      prevVel.y = j;
      prevVel.z = k;
    }
    
    void display(){
      fill(255);
      ellipse(this.x+50, this.y+50, 10, 10);
      //translate(x,y,z);
      //sphere(0.1);
      }
}
