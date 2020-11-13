//Class made by J. Deasley
//Gives a brief description of what the screen shows and how it can be used
class InfoButton extends Widget 
{
  boolean selected;
  String label;
  int resizeValue;
  PFont iFont;

  InfoButton(float px, float py, float widgetWidth, float widgetHeight, String label, int event) 
  {
    super(px, py, widgetWidth, widgetHeight, label, event);
    selected = false;
    this.label = label;
    iFont = loadFont("BookAntiqua-BoldItalic-48.vlw");
  }

  //draws a box with text
  void draw() 
  {
    super.draw();
    pushStyle();
    if(selected)
    {
      fill(50);
      noStroke();
      rectMode(LEFT);
      rect(-1, y-widgetWidth/2, width+1, y+widgetWidth/2);
      fill(255);
      textSize(((pwidgetWidth*width*(pwidgetWidth/(pwidgetHeight + pwidgetWidth)) + pwidgetHeight*height*(pwidgetHeight/(pwidgetHeight + pwidgetWidth))))/2.5);
      textAlign(CENTER, CENTER);
      text(label, width/2, y);
    }
    noStroke();
    fill(selected?205:50);
    circle(px*width, py*height, widgetWidth < widgetHeight? widgetHeight : widgetWidth);
    fill(selected? 50 : 205);
    textAlign(CENTER,CENTER);
    textFont(iFont);
    textSize(width > height? widgetHeight*1.5 : widgetWidth*1.5);
    text("i", px*width,py*height);
    popStyle();
  }

  //returns an event when clicked on
  int getEvent(MouseEvent e) 
  {
    boolean over = dist(mouseX, mouseY, px*width, py*height) < widgetWidth/2;
    switch(e.getAction())
    {
    case MouseEvent.RELEASE:
      if (over)
      {
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
