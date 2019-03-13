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
    
    for(int i = 0; i<coordinates.size()-1; i++){
        //iterate through the coordinates and draw lines
        PVector screenStart = map.getScreenLocation(coordinates.get(i));
        PVector screenEnd = map.getScreenLocation(coordinates.get(i+1));
        
        //make and print intermediate points between streets
        //for(int p = 0; p<50; p++){
        PVector intermediates = map.intermediate(coordinates.get(i),coordinates.get(i+1), 0.8);
        PVector screenInt = map.getScreenLocation(intermediates);
        fill(color(255,0,0));
        noStroke();
        ellipse(screenInt.x, screenInt.y, 3, 3);
        //}
        
        //any road has an equal probability of calling the kabadiwala
        //randomly choose a segment
        //weight segments according to total length
        //randomly place along the length of an edge
        //generate random number between 1 and 128km (Bandra total), 
        //for each edge, designate the 
        //range that it will be selected. 
        //calculate total length of segments, so each range is length/total
        
        
        //make 1 point somewhere within this polygon, and move it to the closest line
        //make PVector Point within location
        //snap PVector Point to closest line
        //add more points
        //map ScreenLocation
        //fill, stroke, point
        
        //make street network
        strokeWeight(2);
        stroke(colorStreet);
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
