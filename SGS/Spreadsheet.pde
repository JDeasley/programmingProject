//Class by D. Guzowski, modified from a class made by O. Gallagher
//Used for showing all company tickers and names, mainly as a referencing tool and also can link to profile screen

class Spreadsheet
{
  Table table;

  float x, y;
  float px, py;
  float pw, ph;

  int position;
  int columns;
  int listSize;

  Spreadsheet(Table table, float px, float py, float pw, float ph, int listSize)
  {
    update(table);
    this.table.sort(0);
    if (this.table.getRowCount() < this.listSize)
    {
      this.listSize = this.table.getRowCount();
    } else
    {
      this.listSize = listSize;
    }
    this.px = px;
    this.py = py;
    x = px*width;
    y = py*height;
    this.pw = pw;
    this.ph = ph;
  }

  Table getTable()
  {
    return table;
  }

  //Takes in a new table to update the current spreadsheet.
  void update(Table table)
  {
    this.table = table.copy();
    position = 0;
    columns = 3; //this.table.getColumnCount();
  }

  //Draws the spreadsheet within the specified dimensions.
  void draw()
  {
    x = px * width;
    y = py * height;
    float w = width*pw / columns, h = height*ph / listSize;
    for (int row = -1; row < listSize; row++)
    {
      float ypos = map(row, -1, listSize-1, y, y + height*ph);
      for (int col = 0; col < columns; col++)
      {
        float xpos = map(col, 0, columns, x, x + width*pw);
        String text = "";
        if (row == -1)
        {
          text = col==0?"Ticker":col==1?"Company":col==2?"Sector":"";
        } else if (row < table.getRowCount())
        {
          if (position + row < table.getRowCount() && position + row > -1)
          {
            text = table.getString(position + row, col);
          }
        }
        pushStyle();
        textAlign(CENTER, CENTER);
        stroke(0);
        textSize((width/10 + height/10)/10);
        float round = sqrt(width+height)*1.5;
        if (col == 0)
        {
          if (row == -1)
          {
            fill(100, 150, 255, 100);
          } else
          {
            fill(255, 100);
          }
          rect(xpos, ypos, w*3, h-5, round, round, round, round);
        }
      
        if (col == 1)
        {
          noFill();
          rect(xpos, ypos, w, h-5);
        }
        
        if (row < table.getRowCount())
        {
          fill(0);
          text(text.replace("&#39;", "'"), xpos, ypos, w, h-5);
        }
        popStyle();
      }
    }
  }

  //Retrieves the mouse wheel event to move the position of the spreadsheet up or down.
  void getEvent(MouseEvent e)
  {
    boolean over = mouseX > x && mouseX < x + width*pw && mouseY > y && mouseY < y + ph*height;
    switch(e.getAction())
    {
    case MouseEvent.WHEEL:
      if (over)
      {
        if (e.getCount() > 0)
        {
          position += 3;
          if (position > table.getRowCount()-listSize)
          {
            position = table.getRowCount()-listSize;
          }
        } else if (e.getCount() < 0)
        {
          position -= 3;
          if (position < 0)
          {
            position = 0;
          }
        }
      }
    default:
      break;
    }
  }

  String getValue()
  {
    x = px * width;
    y = py * height;
    float w = width*pw / columns, h = height*ph / listSize;
    for (int row = 0; row < listSize+1; row++)
    {
      float ypos = map(row, 0, listSize, y, y + height*ph);
      if (mouseY > ypos && mouseY < map(row+1, 0, listSize, y, y + height*ph))
      {
        String ticker = "";
        if (row-1 < table.getRowCount() && row-1 >= 0)
        {
          if (position + row-1 < table.getRowCount())
          {
            ticker = table.getString(position + row-1, 0);
          }

          if (mousePressed)
          {
            return ticker;
          }
        }
      }
    }
    return "";
  }
}
