import de.bezier.guido.*;

public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public final static int NUM_BOMBS = 40;
public final static int TEXT_SIZE = 12;
private boolean firstClick = true;
private boolean endGame = false;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined
public PFont myFont;

void setup ()
{
    myFont = createFont("Monospaced.bold", TEXT_SIZE);
    size(400, 400);
    textFont(myFont);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    
    for(int row = 0; row < NUM_ROWS; row++)
      for(int col = 0; col < NUM_COLS; col++)
          buttons[row][col] = new MSButton(row, col);
    
    //setBombs();
}
public void setBombs() {
    for(int num = 0; num < NUM_BOMBS; num++) {
        final int row = (int)(Math.random()*NUM_ROWS);
        final int col = (int)(Math.random()*NUM_COLS);
        if ( !bombs.contains(buttons[row][col]) ) { bombs.add(buttons[row][col]); }
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
    for(int row = 0; row < NUM_ROWS; row++)
        for(int col = 0; col < NUM_COLS; col++)
            if ( !bombs.contains(buttons[row][col]) && !buttons[row][col].isClicked() )
                return false;
    endGame = true;
    return true;
}
public void displayLosingMessage()
{
    String lose = "  YOU ARE A LOSER!  ";
    
    for(int row = 0; row < NUM_ROWS; row++)
        for(int col = 0; col < NUM_COLS; col++){
            buttons[row][col].setLabel(" ");
            if ( !bombs.contains( buttons[row][col] ) )
                buttons[row][col].setDark( true ); 
            else 
                buttons[row][col].setClicked( true );
        }
    
    for(int col = 0; col < NUM_COLS; col++) {
        buttons[9][col].setDark( true );
        buttons[9][col].setEndColor(true);
        buttons[9][col].setLabel( lose.substring(col, col+1) ); 
    }
}
public void displayWinningMessage()
{
    //for ( int row = 0; row < NUM_ROWS; row++ )
    //    for ( int col = 0; col < NUM_COLS; col++ ) 
    //        if ( bombs.contains( buttons[row][col] ) && buttons[row][col].isMarked() == false )
    //            buttons[row][col].setMarked(true);
    String win = "CONGRATS ON WINNING!";
    
    for(int row = 0; row < NUM_ROWS; row++)
        for(int col = 0; col < NUM_COLS; col++){
            buttons[row][col].setLabel(" ");
            buttons[row][col].setDark( true ); 
        }
    
    for(int col = 0; col < NUM_COLS; col++) {
        buttons[0][col].setColor(true);
        buttons[19][col].setColor(true); 
        buttons[9][col].setEndColor(true);
        buttons[9][col].setLabel( win.substring(col, col+1) ); 
    }
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked, dark, coloring, endColor;
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
        marked = clicked = dark = endColor = coloring = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked(){return marked;}
    public boolean isClicked(){return clicked;}
    public void setEndColor(boolean yeh){endColor = yeh;}
    // called by manager
    
    public void mousePressed () 
    {
        if ( !endGame ) {
            if ( firstClick ) {
                setBombs();
                firstClick = false;
            }
            clicked = true;
            if ( mouseButton == RIGHT && marked == false ) {
                clicked = false;
                if ( clicked != true )
                    marked = true; 
            }
            else if ( mouseButton == RIGHT && marked == true ) { 
                marked = clicked = false; }
            else if ( bombs.contains( this ) && marked == false ) { 
                displayLosingMessage(); 
                endGame = true;
            }
            else if ( countBombs( r, c ) > 0 ) 
                setLabel( ""+countBombs( r, c ) ); 
            else if ( countBombs( r, c ) == 0 ) { 
                for ( int row = r-1; row <= r+1; row++ )
                    for ( int col = c-1; col <= c+1; col++ ) {
                        if(isValid(row, col) && !buttons[row][col].isClicked()) {
                            buttons[row][col].mousePressed(); 
                        } 
                    }
            }
        }
    }

    public void draw () 
    {   
        if ( coloring ) 
            fill((int)x, 66, 255); 
        else if ( dark )
            fill(0);
        else if ( marked )
            fill(255, 190, 66);
        else if( clicked && bombs.contains(this) ) 
            fill(255, (int)x-100, 66);
        else if( clicked )
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height, 3);
        fill(0);
        if ( endColor )
            if ( isWon() )
                fill((int)x, 66, 255); 
            else 
                fill(255, (int)x-100, 66);
        else if( countBombs( r, c ) == 1 )
            fill(0, 0, 255);
        else if ( countBombs( r, c ) == 2 )
            fill(0, 127, 46);
        else if ( countBombs( r, c ) == 3 )
            fill(255, 0, 0);
        else if ( countBombs( r, c ) == 4 )
            fill(1, 4, 84);
        else if ( countBombs( r, c ) == 5 )
            fill(84, 0, 0);
        else if ( countBombs( r, c ) == 6 )
            fill(178, 255, 251);
        else if ( countBombs( r, c ) == 7 )
            fill(0);
        else if ( countBombs( r, c ) == 8 )
            fill(91);
        else
            fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel){label = newLabel;}
    public void setMarked(boolean mark){marked = mark;}
    public void setClicked(boolean click){clicked = click;}
    public void setDark(boolean darken){dark = darken;}
    public void setColor(boolean colors){coloring = colors;}
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
