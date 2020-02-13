class particle {
  float mass = 0.1;
  PVector pos = new PVector(0.0, 0.0, 0.0);
  PVector oldpos = new PVector(0.0, 0.0, 0.0);
  PVector initialpos = new PVector(0.0, 0.0, 0.0);
  PVector vel = new PVector(0.0, 0.0, 0.0);
  PVector acc = new PVector(0.0, 0.0, 0.0);
  PVector forces = new PVector(0.0, 0.0, 0.0);
  boolean isfixed = false;
  
  //Constructor
  particle(float x, float y){
    this.pos.set(x, y, 0.0);
  }
  
  
  public float getMass(){
    return mass;
  }

}
