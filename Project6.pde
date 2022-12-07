// VertexAnimation Project - Student Version //<>//
import java.io.*;
import java.util.*;

/*========== Monsters ==========*/
Animation monsterAnim;
ShapeInterpolator monsterForward = new ShapeInterpolator();
ShapeInterpolator monsterReverse = new ShapeInterpolator();
ShapeInterpolator monsterSnap = new ShapeInterpolator();

/*========== Sphere ==========*/
Animation sphereAnim; // Load from file
Animation spherePos; // Create manually
ShapeInterpolator sphereForward = new ShapeInterpolator();
PositionInterpolator spherePosition = new PositionInterpolator();

// TODO: Create animations for interpolators
ArrayList<PositionInterpolator> cubes = new ArrayList<PositionInterpolator>();

ArrayList<Animation> cubeAnims = new ArrayList<Animation>();

OrbitCamera oCamera;

void setup()
{
  pixelDensity(2);
  size(1200, 800, P3D);
 
  /*====== Load Animations ======*/
  monsterAnim = ReadAnimationFromFile("monster.txt");
  sphereAnim = ReadAnimationFromFile("sphere.txt");

  monsterForward.SetAnimation(monsterAnim);
  monsterReverse.SetAnimation(monsterAnim);
  monsterSnap.SetAnimation(monsterAnim);  
  monsterSnap.SetFrameSnapping(true);

  sphereForward.SetAnimation(sphereAnim);

  /*====== Create Animations For Cubes ======*/
  // When initializing animations, to offset them
  // you can "initialize" them by calling Update()
  // with a time value update. Each is 0.1 seconds
  // ahead of the previous one
  
  /*====== Create Animations For Spheroid ======*/
  Animation spherePos = new Animation();
  // Create and set keyframes
  spherePosition.SetAnimation(spherePos);
  
  oCamera = new OrbitCamera();
  
  /*===== Create animation for cubes =====*/
  for (int i = 0; i < 11; i++)
  {
    Animation cube = new Animation();
    for (int j = 0; j < 4; j++)
    {
      KeyFrame kf = new KeyFrame();
      float x = -100 + i * 20;
      float y = 0;
      float z;
      if (j%2 == 0) z = 0;
      else if (j == 1) z = -95;
      else z = 95;
      PVector pos = new PVector(x, y, z);
      kf.points.add(pos);
      kf.time = j * 0.5;
      cube.keyFrames.add(kf);
    }
    cubeAnims.add(cube);
  }
  
  for (Animation a : cubeAnims)
  {
    println(a.keyFrames.get(0).points.get(0).x, a.keyFrames.get(0).points.get(0).y, a.keyFrames.get(0).points.get(0).z);
  }
}

void draw()
{
  lights();
  background(0);
  perspective(radians(90f), width/(float)height, 0.1, 1000);
  DrawGrid();

  float playbackSpeed = 0.005f;

  oCamera.Update();

  /*====== Draw Forward Monster ======*/
  pushMatrix();
  translate(-40, 0, 0);
  monsterForward.fillColor = color(128, 200, 54);
  monsterForward.Update(playbackSpeed);
  shape(monsterForward.currentShape);
  popMatrix();
  
  ///*====== Draw Reverse Monster ======*/
  pushMatrix();
  translate(40, 0, 0);
  monsterReverse.fillColor = color(220, 80, 45);
  monsterReverse.Update(-playbackSpeed);
  shape(monsterReverse.currentShape);
  popMatrix();
  
  ///*====== Draw Snapped Monster ======*/
  pushMatrix();
  translate(0, 0, -60);
  monsterSnap.fillColor = color(160, 120, 85);
  monsterSnap.Update(playbackSpeed);
  shape(monsterSnap.currentShape);
  popMatrix();
  
  ///*====== Draw Spheroid ======*/
  spherePosition.Update(playbackSpeed);
  sphereForward.fillColor = color(39, 110, 190);
  sphereForward.Update(playbackSpeed);
  PVector pos = spherePosition.currentPosition;
  pushMatrix();
  //translate(pos.x, pos.y, pos.z);
  shape(sphereForward.currentShape);
  popMatrix();
  
  /*====== TODO: Update and draw cubes ======*/
  // For each interpolator, update/draw
  
  perspective();
}

void mouseWheel(MouseEvent event)
{
  float e = event.getCount();
  oCamera.Zoom(e);
  // Zoom the camera
  // SomeCameraClass.zoom(e);
}

void mouseDragged() {
  float deltaX = (mouseX - pmouseX) * 0.15f;
  float deltaY = (mouseY - pmouseY) * 0.15f;
  
  oCamera.phi += deltaX;
  
  float newTheta = oCamera.theta + deltaY;
  if (newTheta < 0) {
    oCamera.theta = 0;
  } else if (newTheta > 179f) {
    oCamera.theta = 179;
  } else {
    oCamera.theta = newTheta;
  }
}
// Create and return an animation object
Animation ReadAnimationFromFile(String fileName)
{
  Animation animation = new Animation();

  // The BufferedReader class will let you read in the file data
  String line;
  String values[];
  try
  {
    BufferedReader reader = createReader(fileName);
    int numKeyFrames = parseInt(reader.readLine());
    int numVerts = parseInt(reader.readLine());
    for (int i = 0; i < numKeyFrames; i++)
    {
      KeyFrame kf = new KeyFrame();
      float frameTime = parseFloat(reader.readLine());
      kf.time = frameTime;
      for (int j = 0; j < numVerts; j++)
      {
        line = reader.readLine();
        values = line.split(" ");
        PVector v = new PVector(parseFloat(values[0]), parseFloat(values[1]), parseFloat(values[2]));
        kf.points.add(v);
      }
      animation.keyFrames.add(kf);
    }
  }
  catch (FileNotFoundException ex)
  {
    println("File not found: " + fileName);
  }
  catch (IOException ex)
  {
    ex.printStackTrace();
  }
 
  return animation;
}

void DrawGrid()
{
  // TODO: Draw the grid
  // Dimensions: 200x200 (-100 to +100 on X and Z)
  stroke(255);
  for (int i = -100; i <= 100; i+= 10)
  {
    line(i, 0, -100, i, 0, 100);
    
    line(-100, 0, i, 100, 0, i);
  }
  stroke(255, 0, 0);
  line(-100, 0, 0, 100, 0, 0);
  stroke(0, 255, 0);
  line(0, 0, -100, 0, 0, 100);
}
