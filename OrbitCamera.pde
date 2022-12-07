class OrbitCamera {

  PVector cameraPosition;
  Integer target;
  PVector lookAtTarget;

  float radius;
  float theta;
  float phi;

  ArrayList<PVector> targets;

  OrbitCamera() {
    cameraPosition = new PVector(0f, -190f, 200f);
    targets = new ArrayList<>();
    lookAtTarget = new PVector(0f, 0f, 0f);

    radius = 125;
    phi = 118f;
    theta = 125f;
  }

  void Update() {
    camera(
      findX(), findY(), findZ(),
      lookAtTarget.x, lookAtTarget.y, lookAtTarget.z,
      0, 1, 0
      );
  }

  void AddLookAtTarget(PVector target) {
    targets.add(target);
  }

  void CycleTarget() {
    if (target == null && targets.size() == 0) {
      return;
    } else if (target == null && targets.size() > 0) {
      target = 0;
      lookAtTarget = targets.get(0);
      return;
    } else {
      target = (target + 1 == targets.size())
        ? 0
        : target + 1;
      lookAtTarget = targets.get(target);
    }
  }

  void Zoom(float f) {
    float newR = radius + 15*f;
    if (newR < 10) {
      radius = 10;
    } else if (newR > 200) {
      radius = 200;
    } else {
      radius = newR;
    }
  }

  float findX() {
    return radius * cos(radians(phi)) * sin(radians(theta));
  }

  float findY() {
    return radius * cos(radians(theta));
  }

  float findZ() {
    return radius * sin(radians(theta)) * sin(radians(phi));
  }
}
