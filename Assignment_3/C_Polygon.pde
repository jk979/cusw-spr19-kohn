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
    println("score is "+score);
    if(score>500000){
      fill = pop_6;
    }
    else if(score<=500000 && score>170000){
      fill = pop_5;
    }
    else if(score<=170000 && score>100000){
      fill = pop_4;
    }
    else if(score<=100000 && score>60000){
      fill = pop_3;
    }
    else if(score<=60000 && score>25000){
      fill = pop_2;
    }
    else if(score<=25000 && score>=0){
      fill = pop_1;
    }
    else if(score==0){
      fill = color(128,128,128);
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
