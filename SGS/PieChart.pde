//Class by D. Guzowski
//Used for displaying companie sales volume on a particular day

class PieChart extends Graph 
{
  float graphX, graphY, graphRadius, graphRadiusReductionFactor;
  float totalValue = 0;
  color[] colors;
  float[] values;
  HashMap<Integer, String> dataMap;
  boolean emptyTable;
  
  PieChart(Table tab, float x, float y, float reductionFactor) //by D. Guzowski
  {
    graphX = x;
    graphY = y;
    dataMap = new HashMap<Integer, String>();
    colors = new color[tab.getRowCount()];
    values = new float[tab.getRowCount()];
    processTable(tab);
    graphRadiusReductionFactor = reductionFactor;
  }
  
  
  //Draws the piechart onto the screen.
  void draw() //by D. Guzowski
  {
    if(!emptyTable)
    {
    pushStyle();
    stroke(255);
   // noStroke();
    strokeWeight(0.75);
    float currentTotal = 0;
    float prevTotal = 0;
    graphRadius = ((width+height)/2)*graphRadiusReductionFactor;
    for(int i = 0; i < values.length; i++)
    {
      fill(colors[i]);
      currentTotal += values[i];
      arc(graphX*width, graphY*height, graphRadius, graphRadius, TWO_PI*(prevTotal/totalValue), TWO_PI*(currentTotal/totalValue), PIE);
      prevTotal = currentTotal;
    }
    noFill();
    strokeWeight(1);
    stroke(0);
    ellipse(graphX*width, graphY*height, graphRadius, graphRadius);
    popStyle();
    }
    else
    {
      pushStyle();
      fill(255);
      stroke(0);
      strokeWeight(0.75);
      fill(0);
      textAlign(CENTER, CENTER);
      textSize(sqrt(width*width + height*height)/24);
      text("NO DATA", graphX*width, graphY*height);
      popStyle();
    }
  }
  
  //Calculates the total values for the piechart, assigns color values to each piece of data, stores the float value for each piece of data and stores 
  //the information string in a HashMap that is accessed by the correct color.
  void processTable(Table dataTable) //by D. Guzowski
  {
    if(dataTable.getRowCount() > 0)
    {
      emptyTable = false;
    }
    else
    {
      emptyTable = true;
    }
    
    if(!emptyTable)
    {
    pushStyle();
    colorMode(HSB);
    for(int i = 0; i < dataTable.getRowCount(); i++)
    {
       TableRow row = dataTable.getRow(i);
       totalValue += Float.parseFloat(row.getString(0));
       color c = color(map(i, 0, dataTable.getRowCount(), 0, 255), 255, 255);
       colors[i] = c;
       values[i] = Float.parseFloat(row.getString(0));
    }
    for(int i = 0; i < dataTable.getRowCount(); i++)
    {
      TableRow row = dataTable.getRow(i);
      String temp = String.format("%s%n%s%n%s%n%s: %s%n%s", row.getString(2).length() < 30 ? row.getString(2) : row.getString(2).substring(0, 27) + "...", row.getString(1),  row.getString(3).length() < 30 ? row.getString(3) : row.getString(3).substring(0, 27) + "...", "Volume", row.getString(0), values[i]/totalValue*100 + "%");   
      dataMap.put(colors[i], temp);
    }
    popStyle();
    }
  }
  
  //Returns the information string assigned to each color when the mouse is over that color.
  String getValue() //by D. Guzowski
  {
    if(!emptyTable)
    {
    if(dist(mouseX, mouseY, graphX*width, graphY*height) < graphRadius/2)
    {
      if(dataMap.containsKey(get(mouseX, mouseY)))
      {
        return dataMap.get(get(mouseX, mouseY));
      }
    }
    }
    return "";
  }
}
