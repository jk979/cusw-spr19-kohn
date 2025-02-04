ArrayList<FoodPOI> foods;

class FoodPOI{
    PVector foodcoord;
  
    //lat, lon values
    float lat_food; 
    float lon_food;
  
   //make constructor to get ready to build the thing
   FoodPOI(float _lat, float _lon){
     lat_food = _lat;
     lon_food = _lon;
     foodcoord = new PVector(lat_food, lon_food);
   }

  //Drawing point
  void draw(){
     PVector screenLocation = map.getScreenLocation(foodcoord); //converting screen into coordinates
     fill(food_fill); //fill pois
     noStroke(); //remove point border
     ellipse(screenLocation.x, screenLocation.y, 10, 10); //fill food
    //shape(f, 0, 0);
  }
  
}
