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
    
    //ArrayList<HashSet<PVector>> collectionOfCollections = new ArrayList<HashSet<PVector>>();
    //concatenate all collectionOfPairs
    //HashSet collectionOfPairs = new HashSet<PVector>();

    if(Street){
    
    //draw road nodes
    for(int i = 0; i<coordinates.size()-1; i++){
        //iterate through the coordinates and draw lines
        PVector screenStart = map.getScreenLocation(coordinates.get(i));
        PVector screenEnd = map.getScreenLocation(coordinates.get(i+1));
        //get each of the elements inside this array
        
        //generate intermediate points
        PVector intermediates = map.intermediate(coordinates.get(i),coordinates.get(i+1), 0.5);
        PVector screenInt = map.getScreenLocation(intermediates);
        //fill(color(255,0,0));
        //noStroke();
        //ellipse(screenInt.x, screenInt.y, 3, 3);
        
        //make street network
        strokeWeight(2);
        stroke(colorStreet);
        line(screenStart.x, screenStart.y, screenEnd.x, screenEnd.y);
    }
    }
    
     //println("now let's start building the collection of collections");
     //println("collection of collections size: " +collectionOfCollections.size());  
    
    //draw coastline
    if(Coastline){
      strokeWeight(3);
      stroke(colorCoastline);
    for(int i = 0; i<coordinates.size()-1; i++){
        //iterate through the coordinates and draw lines
        PVector screenStart = map.getScreenLocation(coordinates.get(i));
        PVector screenEnd = map.getScreenLocation(coordinates.get(i+1));
        line(screenStart.x, screenStart.y, screenEnd.x, screenEnd.y);
    }
 }
 
 //draw rail
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
     
//draw waterway
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
