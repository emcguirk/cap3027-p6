abstract class Interpolator
{
  Animation animation;
  
  // Where we at in the animation?
  float currentTime = 0;
  
  // To interpolate, or not to interpolate... that is the question
  boolean snapping = false;
  
  void SetAnimation(Animation anim)
  {
    animation = anim;
  }
  
  void SetFrameSnapping(boolean snap)
  {
    snapping = snap;
  }
  
  void UpdateTime(float time)
  {
    // TODO: Update the current time
    // Check to see if the time is out of bounds (0 / Animation_Duration)
    // If so, adjust by an appropriate amount to loop correctly
    float dur = animation.GetDuration();
    if (currentTime + time < 0)
    {
      currentTime = dur;
    }
    else if (currentTime + time > dur)
    {
      currentTime = 0;
    }
    else
    {
      currentTime += time;
    }
  }
  
  // Implement this in derived classes
  // Each of those should call UpdateTime() and pass the time parameter
  // Call that function FIRST to ensure proper synching of animations
  abstract void Update(float time);
}

class ShapeInterpolator extends Interpolator
{
  // The result of the data calculations - either snapping or interpolating
  PShape currentShape;
  
  // Changing mesh colors
  color fillColor;
  
  PShape GetShape()
  {
    return currentShape;
  }
  
  void Update(float time)
  {
    // TODO: Create a new PShape by interpolating between two existing key frames
    // using linear interpolation
    UpdateTime(time);
   // First find two key frames
   KeyFrame prev, next;
   if (time > 0)
   {
     // go forward
     // If at time zero, use last keyframe as prev
     if (currentTime == 0)
     {
       prev = animation.keyFrames.get(animation.keyFrames.size() - 1);
       next = animation.keyFrames.get(0);
     }
     else
     {
       for (int i = 0; animation.keyFrames.get(i).time > currentTime; i++)
       {
         prev = animation.keyFrames.get(i);
         next = (i+1 == animation.keyFrames.size()) ? animation.keyFrames(0) : animation.keyFrames.get(i+1);
       }
     }
   }
   else
   {
     // go backward
   }
  }
}

class PositionInterpolator extends Interpolator
{
  PVector currentPosition;
  
  void Update(float time)
  {
    // The same type of process as the ShapeInterpolator class... except
    // this only operates on a single point
  }
}
