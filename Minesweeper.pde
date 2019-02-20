import de.bezier.guido.*;

public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public final static int NUM_BOMBS = 2;
private int NUM_LEFT = NUM_ROWS * NUM_COLS - NUM_BOMBS;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    
    for(int row = 0; row < NUM_ROWS; row++)
      for(int col = 0; col < NUM_COLS; col++)
          buttons[row][col] = new MSButton(row, col);
    
    setBombs();
}
public void setBombs() {
    for(int num = 0; num < NUM_BOMBS; num++) {
        final int row = (int)(Math.random()*20);
        final int col = (int)(Math.random()*20);
        if ( !bombs.contains(buttons[row][col]) ) { bombs.add(buttons[row][col]); }
            System.out.println(row + ", " + col);
    }
}

public void draw ()
{
    background( 0 );
    if( isWon() ) 
            displayWinningMessage();
}
public boolean isWon()
{
    if ( NUM_LEFT > 0 )
        return false;
    return true;
}
public void displayLosingMessage()
{
     println("lose");
}
public void displayWinningMessage()
{
    for ( int row = 0; row < NUM_ROWS; row++ )
        for ( int col = 0; col < NUM_COLS; col++ ) 
            if ( bombs.contains( buttons[row][col] ) && buttons[row][col].isMarked() == false )
                buttons[row][col].setMarked(true);
    println("win");
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
        clicked = true;
        if ( mouseButton == RIGHT && marked == false ) {
            marked = true; }
        else if ( mouseButton == RIGHT && marked == true ) { 
            marked = clicked = false; }
        else if ( bombs.contains( this ) && marked == false ) { 
            displayLosingMessage(); }
        else if ( countBombs( r, c ) > 0 ) { 
            setLabel( ""+countBombs( r, c ) ); 
            NUM_LEFT--; }
        else if ( countBombs( r, c ) == 0 ) { 
            for ( int row = r-1; row <= r+1; row++ )
                for ( int col = c-1; col <= c+1; col++ ) {
                    if(isValid(row, col) && !buttons[row][col].isClicked()) {
                        buttons[row][col].mousePressed(); 
                    } 
                }
            NUM_LEFT--;
        }
        System.out.println(NUM_LEFT);
       
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel){label = newLabel;}
    public void setMarked(boolean mark){marked = mark;}
    public boolean isValid(int r, int c)
    {
        for ( int row = 0; row < NUM_ROWS; row++ )
            for ( int col = 0; col < NUM_COLS; col++ )
              if ( r == row )
                if ( c == col )
                  return true;
        return false;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        for ( int r = row-1; r <= row+1; r++ )
            for ( int c = col-1; c <= col+1; c++ )
                if ( isValid(r, c) == true && bombs.contains( buttons[r][c] ))
                    numBombs++;
        if ( bombs.contains( buttons[row][col] )) numBombs--;
        return numBombs;
    }
}
