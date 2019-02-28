ArrayList<Polygon> polygons;

class Polygon{
  PShape p;
  ArrayList<PVector> coordinates;
  
  //is university?
  boolean University;
  
  //is Water?
  boolean Water;
  
  //is Other building?
  boolean Other;
  
  Polygon(){
    coordinates = new ArrayList<PVector>();
  }
  
  Polygon(ArrayList<PVector> coords){
    coordinates = coords;
    makeShape();
  }
  
  void makeShape(){
    p = createShape();
    p.beginShape();
    
    if(University) {
      p.fill(mit,-50);
    } else if (Water){
      p.fill(water_color);
    }
      else if(Other){
        p.fill(others_color);
      } else {
      //if other building, color gray
      p.fill(polygon_fill,0);
      
      //if water, color light blue
      
      //else, color black
    }
    
    p.strokeWeight(.5);
    p.stroke(255);
    for(int i = 0; i < coordinates.size(); i++){
      PVector screenLocation = map.getScreenLocation(coordinates.get(i));
      p.vertex(screenLocation.x, screenLocation.y);
    }
    p.endShape();
  }
  
  void draw(){
    shape(p, 0, 0); //not shifting shape from coordinate system
    
  }
  
}
