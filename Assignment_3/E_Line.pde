ArrayList<Way> transport_ways = new ArrayList<Way>();

class Way{
  //coordinates and color variables
 ArrayList<PVector>coordinates;
  float lat;
  float lon;
  
  boolean typeWestern;
  boolean typeCentral;
  //empty constructor
  Way(){}
  
  //Constructor of coordinates
  Way(float _lat, float _lon){
    lat = _lat;
    lon = _lon;
  }
  
  //draw the road
  void draw(){
    if(typeWestern){
    strokeWeight(1);
    stroke(road_color);
    //must be less than coordinates size -1 because it's second to last element
    for(int i = 0; i < coordinates.size() - 1; i++){
    //iterate through coordinates and draw lines
    PVector screenStart = map.getScreenLocation(coordinates.get(i));
    PVector screenEnd = map.getScreenLocation(coordinates.get(i+1));
    line(screenStart.x, screenStart.y, screenEnd.x, screenEnd.y);
    noStroke();
    }
    }
  }
}
