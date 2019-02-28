color poi_fill = color(255, 99, 71); //any point color
color restaurant = color(255, 255, 0); //if poi is restaurant
color mit = color(32, 178, 170); 
color polygon_fill = color(32, 255, 170);
color road_color = color(105,105,105);
color food_fill = color(0,250,0); //food color
color mit_bldgs = color(32, 178, 170);

void drawInfo(){ 
  //Rectangle
  fill(0);
  rect(600, 500, 200,180);
  textSize(16);
  //POI
  fill(poi_fill);
  text("poi", 610, 520);
  //Free Food
  fill(food_fill);
  text("free food", 610, 540);
  //Restaurant
  fill(restaurant);
  text("Restaurants", 610, 560);
  fill(road_color);
  text("Roads", 610, 580);
  fill(polygon_fill);
  text("Buildings", 610, 600);
  fill(mit);
  text("MIT Campus", 610, 620);
}
