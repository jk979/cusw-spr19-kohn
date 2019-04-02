class Polygon{
  //Shape, coordinates, and color variables
  PShape p;
  ArrayList<PVector>coordinates;
  color fill;
   //get sub-features: buildings, water, beach, land, park, road
    
    //buildings: properties/tags/building/residential
    boolean BuildingResidential;

  //Empty constructor
  Polygon(){
    coordinates = new ArrayList<PVector>();
  }
  
  //Constructor with coordinates
  Polygon(ArrayList<PVector> coords){
    coordinates = coords;
    fill = color(0, 255, 255, 100);
    makeShape();
  }
  
  //Making the shape to draw
  void makeShape(){
    p = createShape();
    p.beginShape();
    
    if(BuildingResidential){
      p.fill(colorBuildingResidential);
      p.noStroke();
    }
    
    /*
    p.fill(fill);
    p.noStroke();
    }
    */
    for(int i = 0; i<coordinates.size(); i++){
        PVector screenLocation = map.getScreenLocation(coordinates.get(i));
        p.vertex(screenLocation.x, screenLocation.y);
    }
    p.endShape();
  }

  //Drawing shape
  void draw(){
    shape(p, 0, 0);
  }
}
