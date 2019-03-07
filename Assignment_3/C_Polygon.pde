ArrayList<Polygon> PopPolygons;
Polygon outline_wards; 
Polygon outline_city;

class Polygon{
  //Shape, coordinates, and color variables
  PShape p;
  ArrayList<PVector>coordinates;
  color fill;
  float pop;
  int id; 
  float score;
  boolean cityOutline; 
  boolean wardOutline;

  //Empty constructor
  Polygon(){
    coordinates = new ArrayList<PVector>();
  }
  
  //Constructor with coordinates
  Polygon(ArrayList<PVector> coords){
    coordinates = coords;
  }
  
  Polygon(ArrayList<PVector> coords, color _c){
    coordinates = coords;
    fill = _c;
  }
  
  
  void colorByScore(){
    //fill = color(score,82,190); 
    if(score>200000){
      fill = color(128,128,128);
    }
    else if(score<=200000 && score>100000){
      fill = color(149,149,149);
    }
    else if(score<=100000 && score>50000){
      fill = color(170,170,170);
    }
    else if(score<=50000 && score>20000){
      fill = color(192,192,192);
    }
    else if(score<=20000 && score>10000){
      fill = color(213,213,213);
    }
    else if(score<=10000 && score>5000){
      fill = color(234,234,234);
    }
    else if(score<=5000 && score>=0){
      fill = color(244,244,244);
    }
    else{ //color red to highlight
    fill = color(255,0,0);
    }
      
     
     //fill choropleth according to population buckets
    //println(score*255/760573);
  }
  
  //Making the shape to draw
  void makeShape(){

    p = createShape();
    p.beginShape();
    p.fill(fill);
    p.stroke(0);
    p.strokeWeight(.5);
    
    if(cityOutline){
      p.noFill();
      p.stroke(outline_color);
      p.strokeWeight(1);
    } 
    else if(wardOutline){
      p.noFill();
      p.stroke(ward_color);
      p.strokeWeight(0.5);
    }
    
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

boolean pointInPolygon(PVector pos) {
    int i, j;
    boolean c=false;
    int sides = coordinates.size();
    for (i=0,j=sides-1;i<sides;j=i++) {
      if (( ((coordinates.get(i).y <= pos.y) && (pos.y < coordinates.get(j).y)) || ((coordinates.get(j).y <= pos.y) && (pos.y < coordinates.get(i).y))) &&
            (pos.x < (coordinates.get(j).x - coordinates.get(i).x) * (pos.y - coordinates.get(i).y) / (coordinates.get(j).y - coordinates.get(i).y) + coordinates.get(i).x)) {
        c = !c;
      }
    }
    return c;
  }
}
