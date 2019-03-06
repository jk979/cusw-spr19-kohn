ArrayList<Way> ways; 

class Way{
  //coordinates and color variables
  ArrayList<PVector>coordinates;
  
  //empty constructor
  Way(){}
  
  //Constructor of coordinates
  Way(ArrayList<PVector> coords){
    coordinates = coords;
  }
  
  //draw the road
  void draw(){
    strokeWeight(1);
    stroke(road_color);
    //must be less than coordinates size -1 because it's second to last element
    for(int i = 0; i < coordinates.size() - 1; i++){
    //iterate through coordinates and draw lines
    PVector screenStart = map.getScreenLocation(coordinates.get(i));
    PVector screenEnd = map.getScreenLocation(coordinates.get(i+1));
    line(screenStart.x, screenStart.y, screenEnd.x, screenEnd.y);
    }
    noStroke();
  }
}
