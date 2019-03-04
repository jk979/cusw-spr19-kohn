
class Point_k{
    PVector kcoord;
  
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
     fill(k_fill); //fill pois
     noStroke(); //remove point border
     ellipse(screenLocation.x, screenLocation.y, 10, 10); //fill food
    //shape(f, 0, 0);
  }
  
}
