//This was coded in java using Processing 3.
//This is a project to recreate the well known Super Mario game.

//////////////////////////////////Initilaises Constants & Variables/////////////////////////////////////////
Sprite s;
import ddf.minim.*;         //Import the full minim library.
Minim minim;
AudioPlayer Player, Jump;
PImage world1, mario;
PImage [] goomba;           //Array of images to make up Goomba sprite
int count = 0;              //Initialsises counter for the scenes in-game
int direction = 0;          //Determines the users' direction in-game
int mario_x=10;             //User Starting x-axis position
int p = 180;                //Lowest jump height for Mario
boolean hit = false;
int y=180;                  //Mario height to on map
float frame=0;              //Starting frame for Mario Sprite
int frame1=6;               //Last frame for Goomba Sprite
int cframe=0;               //Starting frame for Mario Sprite
float g=1400;               //Gravity for Mario jump
float k=0.2;                //Mario spring constant
float m=0.25;               //Mario mass
float dt=0.01;              //Time step
float vy=-500;              //Initial jump speed for Mario.
float bx, by, bw, bh;       //Initialises parameters for Goomba Sprite.
float t=0;                  //Initial time
int d = 0;                  //Jump activator
boolean walk, r, l;         //Initialsises users' movement variables
float speed=3.5;            //Speed of Mario Sprite
int speed1=1;               //Speed of Goomba Sprite

//////////////////////Preloads The Essential Audio & Image Files///Builds Screen Size///////////////////////
void setup()
{
  size(393, 222, P2D);                       //Builds a screen
  world1 = loadImage("cover.png");
  minim = new Minim(this);                   //Declares the minim sound
  Player = minim.loadFile("Credits.mp3");    //Load music to Player audioplayer
  Player.loop();                             //Music loops forever
  Jump = minim.loadFile("Mario Jump.mp3");   //Load music to Jump audioplayer
  loadAssets();                              //Load Goomba sprite frames
  s = new Sprite();
  mario = loadImage("small.png");
  textureMode(NORMAL);                       //Show Mario Sprite Colours
  blendMode(BLEND);
  noStroke();                                //No border around the Mario Sprite
  frameRate(60);
  smooth();
}

//////////////////////////////////////////Draws World & Sprites/////////////////////////////////////////////
void draw()
{
  background(world1);
  float left =frame/6;                               //Divides Mario Sprite into 6 even segments
  float right=(frame+1)/6;
  if (direction == 1)                                //Switches the direction the Mario sprite s moving in
  {
    float temp=left;
    left=right;
    right=temp;
  }
  if (mario_x >= 393 && count == 0)                  //Allow Mario to loop to the other side of the scene when they run off the screen
  {
    mario_x = -14;
  }
  if (mario_x <= -15 && count == 0)                  //Allow Mario to loop to the other side of the scene when they run off the screen
  {
    mario_x = 392;
  }
  for(int j = 1; j <= 7; j++)
  {
    if (mario_x >= 393 && count == j)                //Runs presets for scene 2.
    {
      world1 = loadImage("World" + (j+1) + ".png");  //Loads the next image for the background for the next scene
      background(world1);                            //Changes the background to the next scene
      mario_x = -14;                                 //Resets Mario's x-axis position
      count++;                                       //Counter increments by 1. Counter keeps track of what scene is current
      bx = -50;                                      //Forces the Goomba to be off the the screen
    }
  }
  if (mario_x >= 393 && count == 8)                  //Runs presets for scene 9.
  {
    world1 = loadImage("World9.png");
    background(world1);
    mario_x = 205;                                   //Mario x-axis moved to just in front of castle
    Player.pause();
    Player = minim.loadFile("Victory.mp3");
    Player.play();
    count++;
    speed = 1;                                       //Mario's sprite speed is reduced for added immersion
    speed1 = 0;                                      //Goomba's sprite stops moving
  }
  if(count == 9 && mario_x >= 264)                   //Transition to start screen
  {
    delay(5000);                                     //Pasue for 5 seconds
    world1 = loadImage("cover.png");
    background(world1);
    mario_x = 10;                                    //Mario x-axis reset
    Player.pause();
    Player = minim.loadFile("Credits.mp3");
    Player.loop();
    speed = 3.5;                                     //Mario speed reset
    speed1 = 1;                                      //Goomba speed rest
    count = 0;                                       //Counter reset
  }
  if (mario_x >= (bx-30) && mario_x <= (bx-10) && (y+9) <= by && (y+9) >= (by-5) && count != 0) //When Mario collides with the Goomba
  {
    hit = true;                                      //Mario is hit
    Player.pause();
    Jump = minim.loadFile("Dies.mp3");
    Jump.play();
    speed1=5;                                        //Goomba speed increased for added immersion
  }
  if (hit)                                           //If Mario is hit
  {
    mario = loadImage("die.png");
    p = 5000;                                        //New lowest height for mario to jump
    image(mario, mario_x, y);
    d = 1;                                           //Forces Mario to jump
    count=0;                                         //Resets count to stop the goomba rom interacting with Mario
  }
  if (y >= 1000 && y <= 1010)                        //When Mario has fallen between 1000-1010
  {
    world1 = loadImage("GameOver.png");
    background(world1);
    Jump = minim.loadFile("GameOver.mp3");
    Jump.play();
    hit = false;                                     //Hit is disabled
  }
  if (y >= 5000)                                     //When Mario has fallen greater or equal to 5000
  {
    world1 = loadImage("cover.png");
    background(world1);
    Player = minim.loadFile("Credits.mp3");
    Player.loop();
    d=0;                                             //Mario jump is disabled
    y=180;                                           //Mario height reset
    p=180;                                           //Lowest jump height reset
    mario = loadImage("small.png");
  }
  pushMatrix();                                      //Pushes the current transformation matrix onto the matrix stack. 
  if (d == 0)                                        //If jump is diasbled
  {
    vy = -500;                                       //Reset the initial jump speed for Mario
    t = 0;                                           //Reset time
    dt=0.01;
  }
  if (d == 1)                                        //Jump actives
  {
    vy=vy+(g-((k/m)*vy))*dt;                         //Equation to get the instantanious speed of Mario throughout the jump.
    y=(int)(y+vy*dt);                                //Equation to get the instantanious height of Mario throughout the jump.
    t=t+dt;                                          //Time updates
    translate(mario_x, y);                           //Remaps Mario's new position in the jump
    if (y < 0)                                       //If Mario jumps higher than the screen top
    {
      d = 0;                                         //Jump is disabled
      vy = -vy;                                      //Jump vector direction is changed by 180 degress
    }
    if (y > p)                                       //If Mario height is greater than the lowest height allowed
    {
      vy = 0;                                        //Current jump speed reset
      d = 0;                                         //Jump disabled
      frame = 0;                                     //When mario lands frame resets to look like the Sprite is standing
    }
  } else translate(mario_x, 180);                    //When not jumping move Mario along the ground
  beginShape();                                      //Begin drawing the Mario sprite box to the screen
  texture(mario);                                    //Texture the shape to the Mario sprite
  if(!hit)                                           //If not hit draw Mario sprite
  {
    vertex( 0, 0, left, 0);
    vertex(20, 0, right, 0);
    vertex(20, 20, right, 1);
    vertex( 0, 20, left, 1);
  }
  endShape(CLOSE);                                   //Stop drawing Mario sprite box
  popMatrix();                                       //Pops the current transformation matrix off the matrix stack.
  if(walk)                                           //If Goomba walk is true
  {
    s.update();                                      //Update Goombe sprite frame
    s.display();                                     //Display the updated Goomba sprite frame
  }
  if(bx < -15)                                       //If Goomba sprite walks to the end of the screen 
  {
    walk = false;
    bx = 430;                                        //Reset Goomba x-axis position
  }
  if (r && !hit)                                     //Mario will move if right key is pressed and Mario is not hit
   {
     direction = 0;                                  //Mario moves right
     mario_x+=speed;                                 //Mario moves
     frame++;                                        //Mario frame increments
     frame %= 5;                                     //Mario frame will not go above frame 5 but instead resets to 0
   }
   if (l && !hit)                                    //Mario will move if left key is pressed and Mario is not hit
   {
     direction = 1;                                  //Mario moves left
     mario_x-=speed;
     frame++;
     frame %= 5;
   }
   int q = (int)random(10000);                       //A random number is generated between 0-9999
   if (q > 800 && q < 900)                           //If the number is between 800-900
   {
     walk = true;                                    //Goomba degins to walk
   }
}

////////////////////////////////////////////Keyborad Inputs/////////////////////////////////////////////////
void keyPressed()                                       //Listens for when a key is pressed
{
  if (keyPressed == true)
  {
    if (keyCode == ENTER)                               //If the ENTER key is pressed
    {
      Player.pause();
      world1 = loadImage("World1.png");
      background(world1);
      Player = minim.loadFile("World.mp3");
      Player.loop();
      count = 1;
      mario_x = 0;                                      //Mario x-axis position is reset
      speed = 3.5;                                      //Mario sprite speed reset
      speed1 = 1;                                       //Goomba sprite speed reset
      frame = 0;                                        //Mario sprite frame reset
      y=180;                                            //Mario height reset
      Jump.pause();
      mario = loadImage("small.png");
      hit = false;                                      //Mario hit disabled
      p = 180;                                          //Mario lowest jump height reset
      d = 0;                                            //Mario jump disabled
      bx = -50;                                         //Goomba x-axis reset
    }
    if (keyCode == UP && !hit)
    {
      d = 1;                                            //Mario jump activated
      Jump = minim.loadFile("Mario Jump.mp3");
      if (y > 179 && y < 185)                           //If Mario height is between 179-185, the ground
      {
        Jump.play();
        Jump.rewind();
        frame = 3;                                      //Set Mario sprite to frame 3 to look like they are jumping
      }
    }
    if (keyCode == BACKSPACE)
    {
      exit();                                           //Close the game if BACKSPACE key is pressed
    }
    switch (keyCode)
    {
      case 37:
        l = true;                                       //Activates the left movement of Mario sprite
        break;
      case 39:
        r = true;                                       //Activates the right movement of Mario sprite
        break;
    }
  }
}

////////////////////////////////////////////Keyborad Inputs/////////////////////////////////////////////////
void keyReleased()             //Listens for when a key is released
{
  if (y < 180)
  {
    frame = 3;                 //When Mario jumps, set Mario sprite to frame 3
  }
  else
  {
    frame = 0;                 //When Mario lands from the jump, reset Mario sprite to frame 0
  }
  switch (keyCode)
    {
      case 37:
        l = false;             //Deactivates the left movement of Mario sprite
        break;
      case 39:
        r = false;             //Deactivates the right movement of Mario sprite
        break;
    }
}

///////////////////////////////////////Loads All Goomba Sprite Frames///////////////////////////////////////
void loadAssets()                                         //Function to load Goomba sprite frames
{
    goomba = new PImage[frame1];
    for(int i = 0; i < frame1; i++)                       //For loop runs to take in the Goomba sprite frames
    {
      goomba[i] =  loadImage("g" + (i+1) + ".png");
    }
}

/////////////////////////////////////////Animates The Goombe Sprite/////////////////////////////////////////
class Sprite                                       //Class to animate Goomba sprite
{
   Sprite()
   {
      bx = 430;                                    //Initialises the initial x-axis of the Goomba sprite
      by = 192;                                    //Initialises the Goomba height
      bw = 47;                                     //Width of the Goomba sprite image
      bh = 33;                                     //Height of the Goomba sprite image
   }
   void update()
   {
      bx -= speed1*(count+1)*0.5;                  //Calculation of Goomba sprite speed
   }
   void display()
   {
     tint(225);                                    //Transparency
     image(goomba[cframe], bx-bw/2,by-bh/2);       //Image displayed from image array
     cframe++;                                     //Increments the Goomba sprite frame
     cframe%=6;                                    //Reset Goomba sprite frame when it reaches the last frame
   }
}
