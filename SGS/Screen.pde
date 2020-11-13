//Class created by K. Wang
//Abstract class used for all other screen classes to enable ease of indexing

abstract class Screen 
{
  ArrayList<Widget> widgets;
  ArrayList<Graph> graphs;
  color screenColor = color(255);

  Screen() 
  {
    widgets = new ArrayList<Widget>();
    graphs = new ArrayList<Graph>();
  }

  abstract void draw();

  int getEvent(MouseEvent e) 
  {
    for (Widget widget : widgets) 
    {
      int event = widget.getEvent(e);
      if (event > EVENT_NULL) 
      {
        return event;
      }
    }
    return EVENT_NULL;
  }

  int getEvent(KeyEvent e) 
  {
    for (Widget widget : widgets) 
    {
      int event = widget.getEvent(e);
      return event;
    }
    return EVENT_NULL;
  }
}
