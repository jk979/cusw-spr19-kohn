
float b = 640;  // Create a variable "b" of the datatype "float"
float c = 0;  // Create a variable "c" of the datatype "float"

void setup() {
  size(640,360);
}

//train game
//windmills move across the screen like the lines
//train rectangle stays in place so it looks like it's moving

void draw() {
  background(51, 204, 255); //color background sky blue
  
  /*pushMatrix();
  translate(width*0.2, height*0.5);
  rotate(frameCount / 200.0);
  star(0, 0, 5, 50, 3); 
  popMatrix();
  
  pushMatrix();
  translate(width*0.5, height*0.5);
  rotate(frameCount / 200.0);
  star(0, 0, 5, 50, 3); 
  popMatrix();
  */
  
  pushMatrix();
  translate(width*0.8, height*0.5);
  rotate(frameCount / 25.0);
  star(0, 0, 5, 50, 3); 
  popMatrix();
  
  
  //line movement
  b = b - 2; //adjust speed of the train
  
  color colorLine = color(255,251,246);
  fill(colorLine);
  
  line(b, height/2, b, height); //add stem
  star(b, height/2, 5, 50, 3); //add windmill

  line(b+150, height/2, b+150, height); //add stem
  star(b+150, height/2, 5, 50, 3); //add windmill
  
  line(b+300, height/2, b+300, height); //add stem
  star(b+300, height/2, 5, 50, 3); //add windmill
  
  line(b+450, height/2, b+450, height); //add stem
  star(b+450, height/2, 5, 50, 3); //add windmill
  
  line(b+600, height/2, b+600, height); //add stem
  star(b+600, height/2, 5, 50, 3); //add windmill
  
  pushMatrix();
  color colorSun = color(255, 255, 51);
  fill(colorSun);
  translate(width*0.25, height*0.25);
  rotate(-frameCount / 100.0);
  star(50, 150, 45, 70, 50); 
  popMatrix();
  
  color colorTrain = color(224,24,57);
  fill(colorTrain);
  c = c + 10;
  rect(50, 250, 200, 100);
  
  if(c<0) {
    c = 640;
  }
  
  if(b < 0) { //if b is more than the width of the screen, make disappear
   b = 640;
  }
  
}

void star(float x, float y, float radius1, float radius2, int npoints) {
  float angle = TWO_PI / npoints;
  float halfAngle = angle/2.0;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius2;
    float sy = y + sin(a) * radius2;
    vertex(sx, sy);
    sx = x + cos(a+halfAngle) * radius1;
    sy = y + sin(a+halfAngle) * radius1;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}
