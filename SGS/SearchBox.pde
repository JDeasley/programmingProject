//Class made by J. Deasley
//Used for text entry, e.g. searching tickers, copany names, etc.

class SearchBox extends Widget
{
  String originalLabel;

  int maxLength;
  boolean focus, isTicker;

//Searchbox used for text entry to search tickers and return a profile screen for that ticker's company
  SearchBox(float px, float py, float widgetWidth, float widgetHeight, String label, int maxLength, int event, boolean isTicker) 
  {
    super(px, py, widgetWidth, widgetHeight, label, event);
    originalLabel = label;
    this.maxLength = maxLength;
    focus = false;
    this.isTicker = isTicker;
  }
  
  String getLabel()
  {
    if(label == originalLabel) return "";
    else return label;
  }

  void draw() 
  {
    super.draw();
    pushStyle();
    textAlign(CENTER, CENTER);
    rectMode(CENTER);
    if(pwidgetWidth < 0.4)
    {
      textSize(((pwidgetWidth*width*(pwidgetWidth/(pwidgetHeight + pwidgetWidth)) + pwidgetHeight*height*(pwidgetHeight/(pwidgetHeight + pwidgetWidth))))/8);
    }
    else
    {
      textSize(((pwidgetWidth*width*(pwidgetWidth/(pwidgetHeight + pwidgetWidth))+pwidgetHeight*height*(pwidgetHeight/(pwidgetHeight + pwidgetWidth))))/15);
    }
    noFill();
    stroke(100, 75);
    rect(x, y, widgetWidth, widgetHeight, 8, 8, 8, 8);
    fill(0);
    text(label, x, y);
    popStyle();
  }
  
  //Adds and removes letters typed on the keyboard when the search box is focused
  void append(char character)
  {
    if (character==BACKSPACE)
    {
      if (!label.equals("")) label = label.substring(0, label.length()-1);
    }
    else if (isTicker && label.length() < maxLength && character != CODED)
    {
      label = label + str(character);
      label = label.toUpperCase();
    }
    else if(!isTicker && label.length() < maxLength && (character == ' ' || character != CODED || character == '.'))
    {
      label = label + str(character);
    }
    if(label.length() == 0) label = "";
  }

  int getEvent(MouseEvent e) 
  {
    boolean over = mouseX > x-widgetWidth/2 && mouseX < x+widgetWidth/2 && mouseY > y-widgetHeight/2 && mouseY < y+widgetHeight/2;

    switch(e.getAction())
    {
    case MouseEvent.RELEASE:
      if (over)
      {
        focus = true;
        if(label == originalLabel) label = "";
      } else
      {
        focus = false;
        if(label == "") label = originalLabel;
      }
      break;
    }

    return EVENT_NULL;
  }

  //getting key events so you can type in the search box and filter by ticker etc.
  int getEvent(KeyEvent e)
  {
    switch(e.getAction())
    {
    case KeyEvent.PRESS:
      if(focus) 
      {
       if(Character.isLetter(key) || keyCode == BACKSPACE || (key == ' ' && !isTicker)) 
       {
          append(key);
        }
        else if(keyCode == ENTER || keyCode == RETURN) 
        {
         if(hasInput()) {
           //filter by ticker
           query=label;
           //label=originalLabel;
           focus=false;
           return EVENT_ENTER;
         }
        }
      }
      break;
    
    }
    return EVENT_NULL;
  }
  
  boolean hasInput()
  {
    if(label == "") return false;
    else return true;
  }
  
  String getTerm()
  {
    return label;
  }
  
  boolean isFocused()
  {
    return focus;
  }
}
