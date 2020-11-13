//Class created by O. Gallagher
//Super class for subs such as Button, SearchBox, InfoButton, etc.

class Widget
{
  String label;
  
  float x, y;
  float px, py;
  int event;
  float widgetWidth, widgetHeight;
  float pwidgetWidth, pwidgetHeight;

  Widget(float px, float py, float pwidgetWidth, float pwidgetHeight, String label, int event)
  {
    this.label = label;
    
    this.px = px;
    this.py = py;
    this.x = width*px;
    this.y = height*py;

    this.pwidgetWidth = pwidgetWidth;
    this.pwidgetHeight = pwidgetHeight;
    this.widgetWidth = width*pwidgetWidth;
    this.widgetHeight = height*pwidgetHeight;

    this.event=event;
  }
  
  String getLabel()
  {
    return label;
  }

  void draw()
  {
    this.x = width*px;
    this.y = height*py;
    this.widgetWidth = width*pwidgetWidth;
    this.widgetHeight = height*pwidgetHeight;
  }

  //Overridden by sub classes
  int getEvent(MouseEvent e)
  {
    return EVENT_NULL;
  }
  
  //Overridden by sub classes
  int getEvent(KeyEvent e)
  {
    return EVENT_NULL;
  }
}
