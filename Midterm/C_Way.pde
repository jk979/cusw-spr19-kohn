import java.util.HashSet;
ArrayList<HashSet<PVector>> collectionOfCollections = new ArrayList<HashSet<PVector>>();
HashSet collectionOfPairs = new HashSet<PVector>();

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
    println("CC is now"+collectionOfCollections.size());
    //coordinates.size() is the size of each road array
    //firstElement and secondElement are the base road elements--the first and second lat-long coordinate pairs in a node: [] and []
    //singlePair is a pair of joined road nodes: [ [],[] ]
    //collectionOfPairs will be a collection of pairs of road nodes: [ [ [],[] ], [ [],[] ] ]
    //concatenate collectionOfPairs for all streets you loop through
      PVector firstElement = new PVector();
      PVector secondElement = new PVector();

      //for each element in the single road array:
      println("size of this block is " + coordinates.size());
      for(int a = 0; a < coordinates.size()-1; a++){
        ArrayList singlePair = new ArrayList<PVector>();
        firstElement = coordinates.get(a);
        secondElement = coordinates.get(a+1);
        //add 1 and 2 to singlePair
        singlePair.add(firstElement);
        singlePair.add(secondElement);
        //add singlePair to the collection for that road
        collectionOfPairs.add(singlePair);
      }

      println("this block of " +coordinates.size()+ " road segments and so far we have added "+collectionOfPairs.size()+" segments");
      //+collectionOfPairs+"\n");
      //println("next we'll add"+collectionOfPairs+" to bigger list");
      
      //each collectionOfPairs is working, but it's not concatenating to a bigger list every time there's a Street
      collectionOfCollections.add(collectionOfPairs);
      println(collectionOfCollections.size());

    //draw road nodes
    for(int i = 0; i<coordinates.size()-1; i++){
        //iterate through the coordinates and draw lines
        PVector screenStart = map.getScreenLocation(coordinates.get(i));
        PVector screenEnd = map.getScreenLocation(coordinates.get(i+1));
        //get each of the elements inside this array
        
        //generate intermediate points
        PVector intermediates = map.intermediate(coordinates.get(i),coordinates.get(i+1), 0.5);
        PVector screenInt = map.getScreenLocation(intermediates);
        fill(color(255,0,0));
        noStroke();
        ellipse(screenInt.x, screenInt.y, 3, 3);
        
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
