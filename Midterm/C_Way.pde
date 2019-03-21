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
        pg.strokeWeight(2);
        pg.stroke(colorStreet);
        pg.line(screenStart.x, screenStart.y, screenEnd.x, screenEnd.y);
    }
    }
    
     //println("now let's start building the collection of collections");
     //println("collection of collections size: " +collectionOfCollections.size());  
    
    //draw coastline
    if(Coastline){
      pg.strokeWeight(3);
      pg.stroke(colorCoastline);
    for(int i = 0; i<coordinates.size()-1; i++){
        //iterate through the coordinates and draw lines
        PVector screenStart = map.getScreenLocation(coordinates.get(i));
        PVector screenEnd = map.getScreenLocation(coordinates.get(i+1));
        pg.line(screenStart.x, screenStart.y, screenEnd.x, screenEnd.y);
    }
 }
 
 //draw rail
     else if(Rail){
       pg.strokeWeight(0.5);
       pg.stroke(colorRail);
       for(int i = 0; i<coordinates.size()-1; i++){
            //iterate through the coordinates and draw lines
            PVector screenStart = map.getScreenLocation(coordinates.get(i));
            PVector screenEnd = map.getScreenLocation(coordinates.get(i+1));
            pg.line(screenStart.x, screenStart.y, screenEnd.x, screenEnd.y);
        }
     }
     
//draw waterway
     else if(Waterway){
       pg.strokeWeight(1);
       pg.stroke(colorWaterway);
       for(int i = 0; i<coordinates.size()-1; i++){
            //iterate through the coordinates and draw lines
            PVector screenStart = map.getScreenLocation(coordinates.get(i));
            PVector screenEnd = map.getScreenLocation(coordinates.get(i+1));
            pg.line(screenStart.x, screenStart.y, screenEnd.x, screenEnd.y);
        }
     }

}
}

/*
//code to flatten an array collection

    //finally, flatten collectionOfCollections
    //make a finalCollection
    ArrayList finalCollection = new ArrayList<PVector>();
    
      //collectionOfCollections exists as [ ( [pair1, pair2] ),( [pair1, pair2] ) ] 
      //goal: [ [pair1, pair2],[pair1, pair2] ]
      //drill into Segment
      for (int p = 0; p<collectionOfCollections.size(); p++){
        //HashSet segment = new HashSet<PVector>();
        ArrayList segment = new ArrayList<PVector>();
        segment = collectionOfCollections.get(p);
        //drill into Pair
        //println(segment.size());
        for (int q = 0; q<segment.size(); q++){
          ArrayList<PVector> pair = new ArrayList<PVector>();
          //pair = segment.get(q);
          //add Pair into a new ArrayList
          //finalCollection.add(segment.get(q));
        }
      }
      //print the new, flattened ArrayList
      //println(finalCollection.size());

*/
