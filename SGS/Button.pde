//Class made by K.Wang and modified by J. Deasley
//Used for clicking to navigate screens

class Button extends Widget 
{
  boolean selected;

  Button(float px, float py, float widgetWidth, float widgetHeight, String label, int event) 
  {
    super(px, py, widgetWidth, widgetHeight, label, event);
    selected = false;
  }

  //draws a box with text
  void draw() 
  {
    super.draw();
    pushStyle();
    textAlign(CENTER, CENTER);
    textSize(((pwidgetWidth*width*(pwidgetWidth / (pwidgetHeight+pwidgetWidth)) + pwidgetHeight*height*(pwidgetHeight / (pwidgetHeight + pwidgetWidth))))/4);
    rectMode(CENTER);
    noStroke();
    if (selected)
    {
      fill(100, 100);
    }
    else 
    {
      fill(100, 50);
    }
    rect(x, y, widgetWidth, widgetHeight, 16, 16, 16, 16);
    fill(0);
    text(label, x, y);
    popStyle();
  }

  //returns an event when clicked on
  int getEvent(MouseEvent e) 
  {
    boolean over = mouseX > x - widgetWidth/2 && mouseX< x + widgetWidth/2 && mouseY > y - widgetHeight/2 && mouseY < y + widgetHeight/2;
    switch(e.getAction())
    {
    case MouseEvent.RELEASE:
      if (over)
      {
        selected = false;
        return event;
      }
      break;
    case MouseEvent.MOVE:
      selected = over;
      break;
    }
    return EVENT_NULL;
  }
}
