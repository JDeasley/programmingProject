//Class by D. Guzowski
//Used to compare 2 companies growth over time

class ComparisonGraph extends Graph  
{
  float graphX, graphY, graphWidth, graphHeight;
  float maxX, maxY, minX, minY, intervalX, intervalY;
  int noOfXIntervals, noOfYIntervals;
  String graphTitle;
  ArrayList<Table> dataTable;
  boolean emptyTable;

  //Creates a graph that plots a given y-variable against the Date from a dataTable that was previously sorted by date, using 2 sets of data from 2 dataTables.
  ComparisonGraph(Table[] tab, String title, float xProp, float yProp, float w, float h)  //by D. Guzowski
  {
    if (xProp < 0 || xProp > 1 || yProp < 0 || yProp > 1 || w < 0 || w > 1 || h < 0 || h > 1)
    {
      throw new IllegalArgumentException("All values must be between 0 - 1");
    }

    graphX = xProp;
    graphY = yProp;
    graphWidth = w;
    graphHeight = h;
    graphTitle = title;
    dataTable = new ArrayList<Table>();
    for (int i = 0; i < tab.length; i++)
    {
      if (tab[i].getRowCount()>1)
      {
        dataTable.add(tab[i]);
      }
    }
    if (dataTable.size( ) < 2)
    {
      emptyTable = true;
    } else if (dataTable.get(0).getRowCount() < 2 || dataTable.get(1).getRowCount() < 2)
    {
      emptyTable = true;
    }

    if (!emptyTable)
    {
      for (Table t : dataTable)
      {
        Table temp = t;
        for (float i = t.getRowCount()-1; i >= 0; i -= 1.1) //1.1 determines the reduction, where 1 is 100% reduction, 2 is 50% etc.
        {
          temp.removeRow(int(i));
        } 
        dataTable.set(dataTable.indexOf(t), temp);
      }
    }
    setScale();
  }

  //Draws the graph to the screen and allows user interaction. (The only method available for use outside this class)
  void draw() //by D. Guzowski
  {
    if (!emptyTable)
    {
      pushStyle();
      //Draws the background gradient, and prints the axis values onto the screen, as well as prints the title of the graph.
      drawGraphBackground();
      colorMode(HSB);
      //Draws a white shape based on the size of the graph, that excludes the space below the graphed points.
      for (Table table : dataTable)
      {
        stroke(map(dataTable.indexOf(table), 0, dataTable.size(), 0, 255), 255, 170);    

        for (int i = 0; i < table.getRowCount()-1; i++)
        {
          line(map(Date.toDays(table.getString(i, 0)), minX, maxX, graphX*width, graphX*width + graphWidth*width), map(float(table.getString(i, 1)), minY, maxY, graphY*height + graphHeight*height, graphY*height), map(Date.toDays(table.getString(i+1, 0)), minX, maxX, graphX*width, graphX*width + graphWidth*width), map(float(table.getString(i+1, 1)), minY, maxY, graphY*height + graphHeight*height, graphY*height));
        }
      }
      popStyle();
    } else
    {
      //Draw empty graph box with "NO DATA" text, for invalid entries
      pushStyle();
      textSize(((width / 10 + height / 10) / 1.5)*0.2);
      fill(0);
      textAlign(CENTER);
      text(graphTitle, ((graphX*width)+((graphWidth*width)/2)), graphY*height-3);
      fill(255, 50);
      rectMode(CORNERS);
      rect(graphX*width, graphY*height, graphX*width + graphWidth*width, graphY*height + graphHeight*height);
      textAlign(CENTER, CENTER);
      textSize(sqrt(width*width + height*height)/16);
      fill(0);
      text("NO DATA", graphX*width + graphWidth*width/2, graphY*height + graphHeight*height/2);
      popStyle();
    }
  }

  //Draws the grid for the graph.
  private void drawGraphBackground() //by D. Guzowski
  {
    colorMode(RGB);
    //Draws a black border around the graph.
    strokeWeight(2);
    stroke(0);
    fill(255, 150);
    strokeWeight(1);
    rectMode(CORNERS);
    rect(graphX*width, graphY*height, graphX*width + graphWidth*width, graphY*height + graphHeight*height);

    textSize(((width / 10 + height / 10) / 1.5)*0.2);
    fill(0);
    textAlign(CENTER);
    text(graphTitle, ((graphX*width)+((graphWidth*width)/2)), graphY*height-3);

    textSize((width + height)/150);
    textAlign(RIGHT, CENTER);

    //Displays the values on the y-axis.
    for (int i = 0; i <= noOfYIntervals; i++)
    {
      text(String.format("%.1f", map(i, 0, noOfYIntervals, minY, maxY)), graphX*width-5, map(i, 0, noOfYIntervals, graphY*height + graphHeight*height, graphY*height));
    }

    //Displays the values on the x-axis.
    for (int i = 0; i <= noOfXIntervals; i++)
    {
      pushMatrix();
      textAlign(CENTER, TOP);
      translate(map(i, 0, noOfXIntervals, graphX*width, graphX*width + graphWidth*width), graphY*height + graphHeight*height + 5);
      Date.setDateFormat(Date.STANDARD);
      text(Date.toDate(int(map(i, 0, noOfXIntervals, minX, maxX))), 0, 0);
      Date.setDateFormat(Date.DEFAULT);
      popMatrix();
    }
  }

  //Calculates the axis scale for the graph given all plots.
  private void setScale() //by D. Guzowski
  {
    if (!emptyTable)
    {
      maxX = maxY = minY = minX = 0;
      for (Table dataTable : dataTable)
      {
        if (dataTable.getRowCount() > 0)
        {
          emptyTable = false;
        } else
        {
          emptyTable = true;
        }

        if (emptyTable)
        {
          break;
        }

        if (!emptyTable)
        {
          if (maxX == 0 && maxY == 0 && minX == 0 && maxX == 0 )
          {
            TableRow row = dataTable.getRow(0);
            maxX = minX = Date.toDays(row.getString(0));
          }

          //For-loop filtering the whole dataTable, finding the max and min values for the x and y variables.
          for (int i = 0; i < dataTable.getRowCount(); i++)
          {
            TableRow row = dataTable.getRow(i);
            if (Date.toDays(row.getString(0)) > maxX)
            {
              maxX = Date.toDays(row.getString(0));
            } else if (Date.toDays(row.getString(0)) < minX)
            {
              minX = Date.toDays(row.getString(0));
            }

            if (Float.parseFloat(row.getString(1)) > maxY)
            {
              maxY = Float.parseFloat(row.getString(1));
            } else if (Float.parseFloat(row.getString(1)) < minY)
            {
              minY = Float.parseFloat(row.getString(1));
            }
          }

          //Calculating the max Y-value of the graph, rounding up to the nearest 10th.
          maxY = ceil((maxY) / 10 * 10);

          if (maxY > 1 && maxY%10!=0)
          {
            maxY += 10-(maxY%10);
          }

          //Calculating the min Y-value of the graph, rounding down to the nearest 10th.
          minY = -ceil(abs((minY)/10 * 10));
          if (abs(minY)%10!=0)
          {
            minY -= 10-(abs(minY)%10);
          }
          //Rounding max and min X-values, max is rounded up, min is rounded down.
          maxX = ceil(maxX);
          minX = floor(minX);

          noOfXIntervals = 2;
          noOfYIntervals = 2;

          //Calculating the spacing of x and y intervals.
          intervalX = (maxX-minX) / noOfXIntervals;
          intervalY = (maxY-minY) / noOfYIntervals;
        }
      }
    }
  }

  //Returns company growth numbers on the day the mouse is over on the graph
  String getValue(int index)
  {
    if (!emptyTable && (index == 1 || index == 0))
    {
      Table t = dataTable.get(index);
      float growthPercentage = (float(t.getString(t.getRowCount()-1, 1))-float(t.getString(0, 1)))/float(t.getString(0, 1))*100;
      return ((growthPercentage > 0)? "+" : "" ) + String.format("%.2f", growthPercentage) + "%";
    }
    return "";
  }

  //Returns overall growth numbers for both companies over the chosen period
  String getValue()
  {
    if (!emptyTable && mouseX > graphX*width && mouseX < graphX*width + graphWidth*width && mouseY > graphY*height && mouseY < graphY*height + graphHeight*height)
    {
      pushStyle();
      strokeWeight(0.5);
      stroke(0);
      line(mouseX, graphY*height, mouseX, graphY*height + graphHeight*height);
      popStyle();
      String growthString = "";
      for (Table table : dataTable)
      {
        for (int i = 0; i < table.getRowCount(); i++)
        {
          TableRow row = table.getRow(i);
          if (dist(map(Date.toDays(row.getString(0)), minX, maxX, graphX*width, graphX*width + graphWidth*width), 1, mouseX, 1) < 2 && mouseY > graphY*height && mouseY < graphY*height + graphHeight*height)
          {
            float growth = ((float(row.getString("Close"))-float(row.getString("Open")))/float(row.getString("Open")))*100;
            growthString += row.getString(7) + ": " + ((growth > 0)?"+":"") + String.format("%.2f", growth) + "%";
            break;
          }
        }
        if (growthString.length() > 5)
        {
          growthString += "\n";
        }
      }
      return growthString;
    }
    return "";
  }
}
