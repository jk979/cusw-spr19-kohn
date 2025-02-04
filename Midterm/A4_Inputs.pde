//set the costs and quantities (can change these dynamically)

//only set Sources that are 1-3km from the shop
int dist_from_shop = 2000;

//set global quantities generated per household
float wt_plastic = 6; //6kg per household
float wt_paper = 25; //25kg per household
float wt_glass = 1; //1kg per household
float wt_metal = 0.17; //0.17kg per household

//weekly quantities
int paperQuantity = 1500;
int plasticQuantity = 120; 
int glassQuantity = 60; 
int metalQuantity = 10; 

//paper
float kabadiwala_pickup_cost_paper;
float paperKBuy = 10;

float kabadiwala_offload_cost_paper;
float paperKSell = 12;

//plastic
float kabadiwala_pickup_cost_plastic;
float plasticKBuy = 12; 

float kabadiwala_offload_cost_plastic;
float plasticKSell = 20;

//glass
float kabadiwala_pickup_cost_glass;
float glassKBuy = 1; 

float kabadiwala_offload_cost_glass;
float glassKSell = 4;

//metal
float kabadiwala_pickup_cost_metal;
float metalKBuy = 80; 
float kabadiwala_offload_cost_metal;
float metalKSell = 100;

//misc
int misc = 3000;

//profit
float totalKPickupCost;

//distance calculation
float HavD;
int roundtripKM;
