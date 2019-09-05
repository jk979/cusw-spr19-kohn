
class Way{
  //Coordinates and color variables
  ArrayList<PVector>coordinates;

  color stroke;
  boolean HH_paths;
  
  //Empty constructor
  Way(){}
  
  //Constructor of coordinates
  Way(ArrayList<PVector> coords){
    coordinates =  coords;
  }
  
  //Draw the road
  void draw(){

    if(HH_paths){
       strokeWeight(1);
       stroke(200,200,200);
       for(int i = 0; i<coordinates.size()-1; i++){
            //iterate through the coordinates and draw lines
            //PVector screenStart = map.getScreenLocation(coordinates.get(i));
            //PVector screenEnd = map.getScreenLocation(coordinates.get(i+1));
            //line(screenStart.x, screenStart.y, screenEnd.x, screenEnd.y);
            line(coordinates.get(i).x, coordinates.get(i).y, coordinates.get(i+1).x, coordinates.get(i+1).y);
        }
     }
  }
}
