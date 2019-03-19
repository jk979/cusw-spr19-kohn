ArrayList<Point_k> k_array = new ArrayList<Point_k>();
ArrayList<Point_k> mrf_array = new ArrayList<Point_k>();

class Point_k{
    PVector kcoord;
    
    boolean typeMRF;
    boolean typeK;
  
    //lat, lon values
    float lat_k; 
    float lon_k;
  
   //make constructor to get ready to build the thing
   Point_k(float _lat, float _lon){
     lat_k = _lat;
     lon_k = _lon;
     kcoord = new PVector(lat_k, lon_k);
   }

  //Drawing point
  void draw(){
     PVector screenLocation = map.getScreenLocation(kcoord); //converting screen into coordinates

     if(typeK){
       fill(k_fill); //fill pois
       noStroke(); //remove point border
       ellipse(screenLocation.x, screenLocation.y, 4, 4); //fill point
     } else if(typeMRF){
       fill(mrf_fill);
       noStroke();
       polygon(screenLocation.x, screenLocation.y,5,4);
     }
    //shape(f, 0, 0);
  }
  
}

void polygon(float x, float y, float radius, int npoints) {
  float angle = TWO_PI / npoints;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}
