//19.0942, 19.0391, 72.8462, 72.8143

float MARGIN = 0.03;
int baseAlpha = 50;
int lnColor = 255;

color colorBuildingResidential = color(0,0,0);
color colorCoastline = color(128,128,128);
color colorRail = color(255,170,170);
color colorStreet = color(0,200,255,100);
color colorWaterway = color(0,0,255); 
color mrf_fill = color(173,255,47); //MRF points (yellow)
color k_fill = color(34, 200, 34); //Kabadiwala shops(green)

void drawInfo(){
  text(frameRate, 25, 25);
  
  //draw title box
  int bgColor = 230;
  noStroke();
  fill(bgColor, 2*baseAlpha);
  rect(520,20,700,120,10);
  //draw title text
  fill(255,255,255);
  textSize(24);
  text("The Kabadiwala's Journey", 540, 50);
  //draw description
  fill(240,240,240);
  textSize(12);
  text("Kabadiwalas are the informal recycling heroes of Mumbai, India. \nThey collect recyclable plastic, paper, glass, and metal from households and sell it up the value chain.",540,70);
  text("This map shows kabadiwalas between their shop (red) and the source of material (yellow). \n Bundle of Materials: red circle",540,110);
  text("By Jacob Kohn", 1100,50);
  //draw input box
  fill(bgColor, 2*baseAlpha);
  rect(520, 150, 300, 500, 10);
  //draw input title
  textSize(16);
  rect(520,150,300,50,10);
  fill(139,0,0);
  text("Inputs",600,180);
  fill(255,255,255);
  //draw input content
  textSize(12);
  text("# kabadiwalas: "+numKabadiwalas,525,220);
  text("# bundles per kabadiwala: "+numBundlesPerKabadiwala,525,240);
  //quantities
  text("---------Quantities-------------------", 525,260);
  text("Paper: "+ wt_paper + " KG",525,280);
  text("Plastic : " + wt_plastic + " KG",525,300);
  text("Glass: " + wt_glass + " KG",525,320);
  text("Metal: " + wt_metal + " KG",525,340);
  text("----------Buying Prices---------------", 525,360);
  //buying prices
  text("Paper Sale Price to Kabadiwala: "+paperKBuy + " INR",525,380);
  text("Plastic Sale Price to Kabadiwala: "+plasticKBuy + " INR",525,400);
  text("Glass Sale Price to Kabadiwala: "+glassKBuy + " INR",525,420);
  text("Metal Sale Price to Kabadiwala: "+metalKBuy + " INR",525,440);
  //selling prices
  //total cost of buying
  text("----Kabadiwala Total Cost of Buying---", 525,460);
  text("Paper: "+kabadiwala_pickup_cost_paper,525,480);
  text("Plastic: "+kabadiwala_pickup_cost_plastic,525,500);
  text("Glass: "+kabadiwala_pickup_cost_glass,525,520);
  text("Metal: "+kabadiwala_pickup_cost_metal,525,540);
  text("Miscellaneous Items: "+ misc + " INR",525,560);


  //draw output box
  fill(bgColor, 2*baseAlpha);
  rect(920, 150, 300, 500, 10);
  //draw output title
  textSize(16);
  rect(920,150,300,50,10);
  fill(0,100,0);
  text("Outputs",1040,180);
  //draw output content
  fill(255,255,255);
  textSize(12);
  text("Kabadiwala's Gross Profit: "+ (kabadiwala_offload_cost_paper - totalKPickupCost)+ " INR",925,220);
  text("Kabadiwala's Roundtrip Distance: "+ roundtripKM + " KM", 925, 240);
  text("---------Bundle Status----------------", 925,260);
  //text("bundle times collected: "+b.timesCollected,925,280);
  //text("bundle is picked up? "+b.pickedUp,925,300);
  text("---------Wholesalers----------------", 925,320);
  
  
}
