//Used to show a company's adjusted close as well as all other data over a chosen timeframe

class ProfileGraph extends Graph //class by D. Guzowski
{
  float graphX, graphY, graphWidth, graphHeight;
  float maxX, maxY, minX, minY, intervalX, intervalY;
  int noOfXIntervals, noOfYIntervals;
  String graphTitle;
  Table dataTable;
  boolean emptyTable;

  //Creates a graph that plots a given y-variable against the Date from a table that was previously sorted by date.
  ProfileGraph(Table tab, String yVar, float xProp, float yProp, float w, float h) //by D. Guzowski
  {
    if (xProp < 0 || xProp > 1 || yProp < 0 || yProp > 1 || w < 0 || w > 1 || h < 0 || h > 1)
    {
      throw new IllegalArgumentException("All values must be between 0 - 1");
    }
    graphX = xProp;
    graphY = yProp;
    graphWidth = w;
    graphHeight = h;
    graphTitle = yVar;
    dataTable = tab;
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
      pushStyle();
      fill(255);
      noStroke();
      beginShape();
      vertex(graphX*width, graphY*height); //Top-Left point

      for (int i = 0; i < dataTable.getRowCount(); i += (dataTable.getRowCount()<500)? 1 : int(dataTable.getRowCount()/500))
      {
        TableRow row = dataTable.getRow(i);
        vertex(map(Date.toDays(row.getString(0)), minX, maxX, graphX*width, graphX*width + graphWidth*width), map(Float.parseFloat(row.getString(1)), minY, maxY, graphY*height + graphHeight*height, graphY*height));
      }

      vertex(graphX*width + graphWidth*width, graphY*height); //Top-Right point
      endShape(CLOSE);
      popStyle();

      //Draws a black border around the graph.
      strokeWeight(2);
      stroke(0);
      noFill();
      strokeWeight(1);
      rectMode(CORNERS);
      rect(graphX*width, graphY*height, graphX*width + graphWidth*width, graphY*height + graphHeight*height);

      //Displaying info from the graph based on the mouse position.
      showValue();
      popStyle();
    } else
    {
      pushStyle();
      textSize(((width / 10 + height / 10) / 1.5)*0.2);
      fill(0);
      textAlign(CENTER);
      text(graphTitle, ((graphX*width)+((graphWidth*width)/2)), graphY*height-3);
      fill(255);
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
    drawGradient(graphX*width, graphY*height, graphWidth*width, graphHeight*height, color(0, 0, 150), color(220, 240, 255), 1);

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
    for (int i = 0; i <= noOfXIntervals; i++) //by D. Guzowski
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

  //Shows values of data when the mouse hovers over.
  private void showValue() //by D. Guzowski
  {
    if (mouseY > graphY*height && mouseY < graphY*height + graphHeight*height && mouseX > graphX*width && mouseX < graphX*width + graphWidth*width)
    {
      pushStyle();
      strokeWeight(0.5);
      stroke(0);
      line(mouseX, graphY*height, mouseX, graphY*height + graphHeight*height);
      popStyle();
    }
  }

  //Calculates the axis scale for the graph given all plots.
  private void setScale() //by D. Guzowski
  {
    if (dataTable.getRowCount() > 0)
    {
      emptyTable = false;
    } else
    {
      emptyTable = true;
    }

    if (!emptyTable)
    {
      maxX = maxY = minY = minX = 0;

      if (maxX == 0 && maxY == 0 && minX == 0 && maxX == 0 )
      {
        TableRow row = dataTable.getRow(0);
        maxX = minX = Date.toDays(row.getString(0));
      }

      //For-loop filtering the whole table, finding the max and min values for the x and y variables.
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

  //Returns the stored data at a given index when the mouseX is near the point.
  String getValue(int index) //by D. Guzowski
  {
    if (!emptyTable)
    {
      if (index >= 0 && index < dataTable.getColumnCount())
      {
        for (int i = 0; i < dataTable.getRowCount(); i += (dataTable.getRowCount()<500)? 1 : int(dataTable.getRowCount()/500))
        {
          TableRow row = dataTable.getRow(i);
          if (dist(map(Date.toDays(row.getString(0)), minX, maxX, graphX*width, graphX*width + graphWidth*width), 1, mouseX, 1) < ((dataTable.getRowCount() > 250)? 2.5 :(dataTable.getRowCount() > 100)? 7.5 :(dataTable.getRowCount() > 50)? 15 :(dataTable.getRowCount() > 30)? 25 : 50) && mouseY > graphY*height && mouseY < graphY*height + graphHeight*height)
          {
            pushStyle();
            strokeWeight(3);
            stroke(0);
            point(map(Date.toDays(row.getString(0)), minX, maxX, graphX*width, graphX*width + graphWidth*width), map(Float.parseFloat(row.getString(1)), minY, maxY, graphY*height + graphHeight*height, graphY*height));
            popStyle();
            if (index == 0)
            {
              return Date.weekDay(row.getString(index)) + ", " + row.getString(index);
            } else
            {
              return row.getString(index);
            }
          }
        }
      }
    }
    return "";
  }
}
