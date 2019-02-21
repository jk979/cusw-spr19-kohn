class Garbage{
  
  // define variables
  float xpos, ypos;
  float radius;
  boolean locked;
  
  //constructor
  Garbage(){
    xpos = random(100, width - 100);
    ypos = random(100, height - 100);
  }
  
// functions
 void display(){
   fill(200,0,100);
   ellipse(xpos, ypos,20, 20);
 }
 
 
void reset(){
    xpos = random(100, width - 100);
    ypos = random(100, height - 100);
 }   
}
