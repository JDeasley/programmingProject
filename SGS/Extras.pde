//Extra stuff such as loading screen and method for gradient drawing
//Modifications and additions made by D. Guzowski & O. Gallagher.

//Updates pieChart in pieScreen
void updatePie() 
{
  isLoading = true;
  int time = millis();
  pieScreen.pieChart = new PieChart(dataManager.piechart(pieScreen.date), 0.725, 0.625, 0.5);
  time = 1000 - (millis() - time);
  if (time > 0)
  {
    delay(time);
  }
  isLoading = false;
}

//Trigger loading screen any time we are transitioning to a different screen
void stateChange()
{
  isLoading = true;
  int time = millis();
  time = 1000 - (millis() - time);
  if (time > 0)
  {
    delay(time);
  }
  isLoading = false;
}

void loadSetup()
{
  isLoading = true;
  int time = millis();
  dataManager = new DataManager("jdbc:sqlite:"+dataPath("sgs.db"));
  state = 0;
  profileIndex=0;
  query="";
  screens.add(null);
  screens.add(null);
  screens.add(null);
  screens.add(null);
  screens.add(null);
  screens.add(null);
  time = 2000 - (millis() - time);
  if (time > 0)
  {
    delay(time);
  }
  isLoading = false;
  thread("stocksCreate");
}

//Resets spreadsheet inside stocksScreen
void resetStocks() 
{
  isLoading = true;
  int time = millis();
  stocksScreen.spreadsheet.update(dataManager.stocks());
  time = 1000 - (millis() - time);
  if (time > 0)
  {
    delay(time);
  }
  isLoading = false;
}

//Updates spreadsheet inside stocksScreen
void updateStocks() 
{
  isLoading = true;
  int time = millis();
  stocksScreen.spreadsheet.update(dataManager.stocks(query));
  time = 1000 - (millis() - time);
  if (time > 0)
  {
    delay(time);
  }
  isLoading = false;
}

//Updates comparison graph in comparescreen
void updateComparison() 
{
  compareScreen.update();
}

//Creates a stocks screen
void stocksCreate() 
{
  isLoading = true;
  int time = millis();
  state = 3;
  spreadsheet = new Spreadsheet(dataManager.stocks(), 0.05, 0.15, 0.9, 0.7, 7);
  stocksScreen = new StocksScreen(spreadsheet);
  screens.set(state, stocksScreen);
  time = 1000 - (millis() - time);
  if (time > 0)
  {
    delay(time);
  }
  state = 0;
  isLoading = false;
}

//Creates a pieScreen
void pieCreate() 
{
  isLoading = true;
  int time = millis();
  pieScreen = new PieScreen(dataManager);
  screens.set(state, pieScreen);
  time = 1000 - (millis() - time);
  if (time > 0)
  {
    delay(time);
  }
  isLoading = false;
}

//Creates a compareScreen
void compareCreate() 
{
  isLoading = true;
  int time = millis();
  compareScreen = new CompareScreen("RRC", "FLWS");
  screens.set(state, compareScreen);
  time = 1000 - (millis() - time);
  if (time > 0)
  {
    delay(time);
  }
  isLoading = false;
}

//Creates a profilescreen to add to profiles
void profileCreate() 
{
  isLoading = true;
  if (dataManager.profileExists(query)) 
  {
    int time = millis();
    profiles.add(new Profile(dataManager, query));
    time = 1000 - (millis() - time);
    if (time > 0)
    {
      delay(time);
    }
    profileIndex=profiles.size()-1;
    state = 1;
  }
  isLoading = false;
}

//Creates a TrendsScreen
void trendsCreate()
{
  isLoading = true;
  int time = millis();
  trendsScreen = new TrendsScreen();
  screens.set(state, trendsScreen);
  time = 1000 - (millis() - time);
  if (time > 0)
  {
    delay(time);
  }
  isLoading = false;
}

//Update trends screen to change the date
void updateTrends()
{
  isLoading = true;
  int time = millis();
  trendsScreen.trendsGraph = new GrowthGraph(dataManager.growthGraph(trendsScreen.date), 0.45, 0.35, 0.5, 0.6);
  time = 1000 - (millis() - time);
  if (time > 0)
  {
    delay(time);
  }
  isLoading = false;
}

float loadingA = 0;
float loadingB = 0.0125;
boolean isLoading = false;
String[] loadingSigns = {"€", "$", "₩", "£", "₦", "Ł", "¥"};

//Draws a loading screen using threading when data is being loaded.
void loading() //by D. Guzowski
{
  pushStyle();
  background(255); 
  fill(51);
  drawGradient(0, 0, width, 100, color(100, 150, 255), color(255), 1);
  drawGradient(0, height-100, width, 100, color(255), color(100, 150, 255), 1);
  fill(0);
  float loadSize = sqrt(width*width + height*height)/24;
  textSize(loadSize/2);
  textAlign(LEFT, CENTER);
  fill(255, 175, 0);
  noStroke();
  textAlign(CENTER);
  for (int i = 0; i < loadingSigns.length; i++)
  {   
    textSize(loadSize);
    text(loadingSigns[i], width/2 + (loadSize*2)*cos(3*loadingA + map(i, 0, loadingSigns.length, 0, TWO_PI))-250*tan(loadingA), height/2 + (loadSize*2)*sin(loadingA + map(i, 0, loadingSigns.length, 0, TWO_PI)));
    text(loadingSigns[i], width/2 + (loadSize*2)*cos(3*loadingA + map(i, 0, loadingSigns.length, 0, TWO_PI))-250*tan(loadingA+HALF_PI), height/2 + (loadSize*2)*sin(loadingA + map(i, 0, loadingSigns.length, 0, TWO_PI)));
  }

  loadingA += loadingB;
  popStyle();
}

float logoA = 0;
float logoB = 0.005;

//Draws the logo to the using threading when data is being loaded.
void logo(float pX, float pY, float size) //by D. Guzowski
{
  pushStyle();
  float logoTextSize = size;
  textSize(logoTextSize/2);
  textAlign(LEFT, CENTER);
  String logoString1 = "Googo";
  String logoString2 = "lStox";
  noStroke();
  textAlign(CENTER);
  textSize(logoTextSize*1.5);
  fill(51);
  text(logoString1, width*pX - textWidth(logoString1)/2.5, height*pY);
  fill(255, 175, 0);
  for (int i = 0; i < loadingSigns.length; i++)
  {   
    textSize(map(sin(logoA + map(i, 0, loadingSigns.length, 0, TWO_PI)), -1, 1, logoTextSize*0.5, logoTextSize*1.75));
    text(loadingSigns[i], width*pX - (logoTextSize*(1000/600)*1.01)*cos(logoA + map(i, 0, loadingSigns.length, 0, TWO_PI))*3 - logoTextSize/20, height*pY + (logoTextSize*(1000/600)*1.25)*sin(logoA + map(i, 0, loadingSigns.length, 0, TWO_PI)) - (logoTextSize*2.25)*cos(logoA + map(i, 0, loadingSigns.length, 0, TWO_PI)));
  }
  textSize(logoTextSize*1.5);
  fill(51);
  text(logoString2, width*pX + (textWidth(logoString1))/2.15, height*pY);
  popStyle();
  logoA += ( width+height )* 0.000005;
}

//Draws a gradient from color1 to color2, from a specified (x, y) and the width and height of the gradient.
void drawGradient(float x, float y, float gradWidth, float gradHeight, color c1, color c2, int type) //by D. Guzowski
{
  pushStyle();
  if (type == 1 || type != 2)
  {
    noFill();
    for (int i = int(y); i <= y+gradHeight; i++) 
    {
      float inter = map(i, y, y+gradHeight, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(x, i, x+gradWidth, i);
    }
  } else if (type == 2)
  {
    noFill();
    for (int i = int(x); i <= x+gradWidth; i++) 
    {
      float inter = map(i, x, x+gradWidth, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(i, y, i, y+gradHeight);
    }
  }
  popStyle();
}

//Stylistic background colour gradients
void drawGradient(float x, float y, int radius, color c1, color c2) 
{
  pushStyle();
  noStroke();
  for (int r = radius; r > 0; --r) 
  {
    color c = lerpColor(c1, c2, map(r, radius, 0, 1, 0));
    stroke(c);
    noFill();
    ellipse(x, y, r, r);
  }
  popStyle();
}
