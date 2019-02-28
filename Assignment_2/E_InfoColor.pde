color poi_fill = color(255, 99, 71); //any point color
color restaurant = color(255, 255, 0); //if poi is restaurant
color mit = color(32, 178, 170); 
color polygon_fill = color(32, 255, 170);
color road_color = color(220,20,60);
color food_fill = color(0,250,0); //food color
color mit_bldgs = color(32, 178, 170);
color water_color = color(16,12,68);
color others_color = color(100,100,100);

void drawInfo(){ 
  //Rectangle
  fill(0);
  rect(820+280, 400+105, 200, 300);
  textSize(14);
  //POI
  //fill(poi_fill);
  //text("poi", 810, 520);
  //Free Food
  fill(food_fill);
  text("Free Food", 830+280, 460+105);
  //Restaurant
  fill(restaurant);
  text("Restaurants", 830+280, 480+105);
  fill(road_color);
  text("Streets", 830+280, 500+105);
  //fill(polygon_fill);
  //text("Buildings", 810, 600);
  fill(mit);
  text("MIT Campus", 830+280, 520+105);
  fill(others_color);
  text("Other Buildings", 830+280,540+105);
}
