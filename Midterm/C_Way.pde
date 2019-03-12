class Way{
  //Coordinates and color variables
  ArrayList<PVector>coordinates;
  color stroke;
  boolean Street;
  boolean Coastline;
  boolean Rail;
  boolean Waterway;
  
  //Empty constructor
  Way(){}
  
  //Constructor of coordinates
  Way(ArrayList<PVector> coords){
    coordinates =  coords;
  }
  
  //Draw the road
  void draw(){
    
    if(Street){
    strokeWeight(2);
    stroke(colorStreet);
    for(int i = 0; i<coordinates.size()-1; i++){
        //iterate through the coordinates and draw lines
        PVector screenStart = map.getScreenLocation(coordinates.get(i));
        PVector screenEnd = map.getScreenLocation(coordinates.get(i+1));
        line(screenStart.x, screenStart.y, screenEnd.x, screenEnd.y);
    }
    }
    else if(Coastline){
      strokeWeight(3);
      stroke(colorCoastline);
    for(int i = 0; i<coordinates.size()-1; i++){
        //iterate through the coordinates and draw lines
        PVector screenStart = map.getScreenLocation(coordinates.get(i));
        PVector screenEnd = map.getScreenLocation(coordinates.get(i+1));
        line(screenStart.x, screenStart.y, screenEnd.x, screenEnd.y);
    }
 }
     else if(Rail){
       strokeWeight(0.5);
       stroke(colorRail);
       for(int i = 0; i<coordinates.size()-1; i++){
            //iterate through the coordinates and draw lines
            PVector screenStart = map.getScreenLocation(coordinates.get(i));
            PVector screenEnd = map.getScreenLocation(coordinates.get(i+1));
            line(screenStart.x, screenStart.y, screenEnd.x, screenEnd.y);
        }
     }
     else if(Waterway){
       strokeWeight(1);
       stroke(colorWaterway);
       for(int i = 0; i<coordinates.size()-1; i++){
            //iterate through the coordinates and draw lines
            PVector screenStart = map.getScreenLocation(coordinates.get(i));
            PVector screenEnd = map.getScreenLocation(coordinates.get(i+1));
            line(screenStart.x, screenStart.y, screenEnd.x, screenEnd.y);
        }
     }
   
}
}
