ArrayList<POI> pois;

class POI{
  //define properties
    //coordinates
    PVector coord;
  
    //lat, lon values
    float lat; 
    float lon;
  
     //is restaurant?
     boolean Restaurant;
   
     //Type --may use later
     String type;
   
   //make constructor to get ready to build the thing
   POI(float _lat, float _lon){
     lat = _lat;
     lon = _lon;
     coord = new PVector(lat, lon);
   }
   
   void draw(){
     PVector screenLocation = map.getScreenLocation(coord); //converting screen into coordinates
     fill(poi_fill); //fill pois
     if(Restaurant) fill(restaurant);
     noStroke(); //remove point border
     ellipse(screenLocation.x, screenLocation.y, 6, 6); //fill restaurant
   }
   
}
