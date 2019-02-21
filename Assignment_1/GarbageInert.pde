class GarbageInert {
  
//define properties
    PVector position;  //it has a position property
    float radius, m; //this position has a radius and a "m" of buffer
    PVector screenLocation;
    boolean locked;
    
//create Constructor
    GarbageInert(float x, float y, float r_) {
    position = new PVector(x,y);
    radius = r_;
    m = radius*.1;
    screenLocation = new PVector(width/2, height/2);
  }
    
//"appear"
void drawGarbage(){
    noStroke(); //no outline
    if (hoverEvent()){ //color it when mouse over
      fill(#00FF00);
    }
    else{
      fill(255); //white fill
    }
    ellipse(screenLocation.x, screenLocation.y, 30, 30);
  }
  
//randomly place the GarbageInert circle
  void reset() {
    screenLocation = new PVector(random(width), random(height));
  }

//if mouse hovering, return true; otherwise, return false
boolean hoverEvent() { 
  float xDistance = abs(mouseX - screenLocation.x); 
  float yDistance = abs(mouseY - screenLocation.y);
  if (xDistance <= 15 && yDistance <=15){
    return true;
  } else {
    return false;
  }
}

//if mouse clicked, checkSelection and update location
boolean checkSelection(){
  if(hoverEvent()){
    locked = true;
  } else {
    locked = false;
  }
  return locked;
}

//update garbage location
void update(){
  if(locked) { 
    screenLocation = new PVector(mouseX, mouseY);
  }
}
  
void display() {
    noStroke();
    fill(204);
    ellipse(position.x, position.y, radius*2, radius*2);
  }
  
}
