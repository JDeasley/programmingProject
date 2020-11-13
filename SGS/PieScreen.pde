//Class made by J. Deasley and modified by O. Gallagher & D. Guzowski
//Shows a pie chart of what companies sold the highest volume of stocks on a user-chosen day in percentage form

class PieScreen extends Screen 
{

  PieChart pieChart;

  String date;
  DateWidget dateWidget;

  PieScreen(DataManager dataManager) 
  {
    screenColor = color(100, 150, 255);
    dateWidget = new DateWidget(0.075, 0.365, 0.1, 0.01, "", EVENT_NULL);
    
    widgets.add(new Button(0.1, 0.1, BUTTON_WIDTH*2, BUTTON_HEIGHT*2, "Home", EVENT_HOME));
    widgets.add(dateWidget);
    widgets.add(new Button(0.35, 0.425, BUTTON_WIDTH*2, BUTTON_HEIGHT*2, "Update", EVENT_DATE));
    widgets.add(new InfoButton(0.925, 0.9, 0.05, 0.05, "Interact with the graph to observe traded stock on a date.", EVENT_NULL));
    
    date="2018-06-14";
    pieChart = new PieChart(dataManager.piechart(date), 0.725, 0.625, 0.5); //modified by D. Guzowski
  }

  void draw() 
  {
    //Display date, slightly faded in the background
    pushStyle();
    fill(200, 100);
    textSize((width+height)/12);
    textAlign(RIGHT, TOP);
    text(date, width, height*(0.01));
    popStyle();
    
    pieChart.draw();
    
    //Display data at point on pie chart where mouse is hovering
    pushStyle();
    String val = pieChart.getValue();
    pushStyle();
    rectMode(CORNER);
    fill(255, 200);
    stroke(51);
    strokeWeight(0.5);
    rect(width*0.0535, height*0.575, (width+height)/4, (width+height)/8.5, 10);
    popStyle();
    
    textSize((width+height)/100);
    fill(0);
    if (val.length() > 0) 
    {
      pushStyle();
      noStroke();
      String[] temp = split(val, "\n");
      String tempStr = temp[1];
      rectMode(CENTER);
      fill(color(red(get(mouseX, mouseY)) - 75, green(get(mouseX, mouseY)) - 75, blue(get(mouseX, mouseY)) - 75, 200));
      rect(mouseX, mouseY - (width + height)/150, textWidth(tempStr) + 10, (width+height)/100 + 5, 5);
      fill(255);
      textAlign(CENTER, BOTTOM);
      text(tempStr, mouseX, mouseY);
      textAlign(LEFT, TOP);
      textSize((width+height)/75);
      fill(0);
      text(val.replace("&#39;", "'"), width*0.06, height*0.575 + (width+height)/100);
      popStyle();
    }
    for (Widget widget : widgets) 
    {
      widget.draw();
    }
    popStyle();
  }

  //Used for queries from the dateWidget to display on the pieChart
  void setDate(String newDate)
  {
    date = newDate;
    thread("updatePie");
  }

  @Override
  int getEvent(KeyEvent e)
  {
    switch(e.getAction())
    {
    case KeyEvent.PRESS:
      switch(key)
      {
      case BACKSPACE:
        return EVENT_HOME;
      case ENTER:
        setDate(dateWidget.getDate());
        break;
      }
    }
    return EVENT_NULL;
  }

  @Override
  int getEvent(MouseEvent e) 
  {
    for (Widget widget : widgets) 
    {
      int event = widget.getEvent(e);
      if (event == EVENT_DATE)
      {
        setDate(dateWidget.getDate());
      } else if (event > EVENT_NULL) 
      {
        return event;
      }
    }
    return EVENT_NULL;
  }
}
