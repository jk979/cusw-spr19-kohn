ArrayList<Point_k> k_array = new ArrayList<Point_k>();
ArrayList<Point_k> mrf_array = new ArrayList<Point_k>();
ArrayList<Point_k> w_array = new ArrayList<Point_k>();

class Point_k{
    PVector kcoord;
    
    boolean typeMRF;
    boolean typeK;
    boolean typeWholesaler;
  
    //lat, lon values
    float lat_k; 
    float lon_k;
  
   //make constructor to get ready to build the thing
   Point_k(float _lat, float _lon){
     lat_k = _lat;
     lon_k = _lon;
     kcoord = new PVector(lat_k, lon_k);
   }

  //Drawing point
  void draw(){
     PVector screenLocation = map.getScreenLocation(kcoord); //converting screen into coordinates

     if(typeK){
       fill(k_fill); //fill pois
       noStroke(); //remove point border
       ellipse(screenLocation.x, screenLocation.y, 4, 4); //fill point
     } else if(typeMRF){
       fill(mrf_fill);
       noStroke();
       polygon(screenLocation.x, screenLocation.y,5,4);
     } else if(typeWholesaler){
       println("printing wholesaler");
       fill(w_fill);
       noStroke();
       polygon(screenLocation.x, screenLocation.y,5,4);
     }
    //shape(f, 0, 0);
  }
  
}

void polygon(float x, float y, float radius, int npoints) {
  float angle = TWO_PI / npoints;
  beginShape();
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius;
    float sy = y + sin(a) * radius;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}

/////////////////// POI ///////////////////////
class POI{
  //What is the coordinate of the POI in lat, lon
  PVector coord;
  
  //Lat, lon values
  float lat;
  float lon;
  float elev;
  
  //fill color
  color fill;

  POI(float _lat, float _lon){
    lat = _lat;
    lon = _lon;
    coord = new PVector(lat, lon,0);
    fill = color(255, 0, 225, 100);
  }
  
  void draw(){
    PVector screenLocation = map.getScreenLocation(coord);
    fill(fill);
    noStroke();
    ellipse(screenLocation.x, screenLocation.y, 10, 10);
  } 
}

//////////////// HH /////////////////////
class POI_hh{
  //What is the coordinate of the POI in lat, lon
  PVector coord;
  
  //Lat, lon values
  float lat;
  float lon;
  float elev = 0;
  
  //fill color
  color fill;

  POI_hh(PVector p){
    p = new PVector(lat,lon,elev);
    coord = p;
    fill = color(255, 0, 225, 100);
  }
  
  void draw(){
    PVector screenLocation = map.getScreenLocation(coord);
    fill(fill);
    noStroke();
    ellipse(screenLocation.x, screenLocation.y, 10, 10);
  } 
  
  
}

//////////////////////////// WAY ////////////////////////
class Way{
  //Coordinates and color variables
  ArrayList<PVector>coordinates;

  color stroke;
  boolean Street;
  boolean Coastline;
  boolean Rail;
  boolean Railway;
  boolean Waterway;
  boolean WardBounds;
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
       pg.strokeWeight(1);
       pg.stroke(colorHHPaths);
       for(int i = 0; i<coordinates.size()-1; i++){
            //iterate through the coordinates and draw lines
            PVector screenStart = map.getScreenLocation(coordinates.get(i));
            PVector screenEnd = map.getScreenLocation(coordinates.get(i+1));
            pg.line(screenStart.x, screenStart.y, screenEnd.x, screenEnd.y);
        }
     }
     
    else if(WardBounds){
       pg.strokeWeight(0.5);
       pg.stroke(colorWardBounds);
       for(int i = 0; i<coordinates.size()-1; i++){
            //iterate through the coordinates and draw lines
            PVector screenStart = map.getScreenLocation(coordinates.get(i));
            PVector screenEnd = map.getScreenLocation(coordinates.get(i+1));
            pg.line(screenStart.x, screenStart.y, screenEnd.x, screenEnd.y);
        }
     }
     
   else if(Railway){
     pg.strokeWeight(0.5);
       pg.stroke(colorRailways);
       for(int i = 0; i<coordinates.size()-1; i++){
            //iterate through the coordinates and draw lines
            PVector screenStart = map.getScreenLocation(coordinates.get(i));
            PVector screenEnd = map.getScreenLocation(coordinates.get(i+1));
            pg.line(screenStart.x, screenStart.y, screenEnd.x, screenEnd.y);
        }
     }
     
    else if(Street){
        pg.strokeWeight(0.5);
        pg.stroke(colorStreet);
    //draw road nodes
    for(int i = 0; i<coordinates.size()-1; i++){
        //iterate through the coordinates and draw lines
        PVector screenStart = map.getScreenLocation(coordinates.get(i));
        PVector screenEnd = map.getScreenLocation(coordinates.get(i+1));
        //println(screenStart.x, screenStart.y, screenEnd.x, screenEnd.y);
        pg.line(screenStart.x, screenStart.y, screenEnd.x, screenEnd.y);
    }
    }
    
    /*
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
     */
     
     
}
}

///////////////////////// POLYGON //////////////////////////
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
