int radius = 15;
int direction = 1; 
int direction2 = 0 ;

//want to render multiple kabadiwala; what does each of them look like?
class KabadiwalaAgent{
  float w, h;
  String id;
  
  //constructor
  KabadiwalaAgent(float wpos, float hpos){
    w = wpos;
    h = hpos;
  }
  
  void display(){
    fill(0,175,255);
    smooth();
    noStroke();
    render();
  }
  
  void render() {
  for ( int i=-1; i < 2; i++) {
    for ( int j=-1; j < 2; j++) {
      pushMatrix();
      translate(w + (i * width), h + (j*height));
      if ( direction == -1) { 
        rotate(PI);
      }
      if ( direction2 == 1) { 
        rotate(HALF_PI);
      }
      if ( direction2 == -1) { 
        rotate( PI + HALF_PI );
      }
      arc(0, 0, radius, radius, map((millis() % 500), 0, 500, 0, 0.52), map((millis() % 500), 0, 500, TWO_PI, 5.76) );
      popMatrix();
      // mouth movement //
    }
  }
}
  
}
  
  
