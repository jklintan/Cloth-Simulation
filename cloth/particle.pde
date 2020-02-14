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
  particle(int row, int col, int dist, boolean fix){
    this.index.set(row, col);
    this.initialpos.set((row-1)*dist, (col-1)*dist, 0.0);
    this.pos.set(this.initialpos);
    this.oldpos.set(this.initialpos);
    this.isfixed = fix;
    this.force.set(0, 0, 0);
    this.vel.set(0,0,0);
  }
  
  boolean isFixed(){
    return this.isfixed;
  }
  
  void setPos(float x, float y){
    this.pos.set(x, y);
  }
  
  
  //Draw the particle 
  public void display() {
   fill(255);
   ellipse(this.pos.x+150, this.pos.y+150, 3, 3);
  }

}
