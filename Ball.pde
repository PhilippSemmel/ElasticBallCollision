class Ball {
  PVector pos;
  PVector velocity;
  float radius;
  float mass;
  color color_;
  
  public Ball(PVector pos, float radius) {
    this.pos = pos;
    this.velocity = getRandVelocity();
    this.radius = radius;
    mass = PI * (float) sq(radius);
    this.color_ = getRandomColor();
  }
  
  public Ball(PVector pos, PVector velocity, float radius) {
    this.pos = pos;
    this.velocity = velocity;
    this.radius = radius;
    mass = PI * (float) sq(radius);
    this.color_ = getRandomColor();
  }
  
  public boolean ballCollision(Ball other) {
    return touchesBall(other) && distanceDecreasesToBall(other);
  }
  
  private boolean touchesBall(Ball other) {
    return pos.dist(other.pos) <= radius + other.radius;
  }
  
  private boolean distanceDecreasesToBall(Ball other) {
    float currentDist = pos.dist(other.pos);
    float newDist = getNewDistToBall(other);
    return newDist < currentDist;
  }
  
  private float getNewDistToBall(Ball other) {
    PVector newPos = PVector.add(pos, velocity);
    PVector newPosOther = PVector.add(other.pos, other.velocity);
    return newPos.dist(newPosOther);
  }
  
  public void resolveBallCollision(Ball other) {
    collisionResolver.setBalls(this, other);
    collisionResolver.resolve();
  } //<>//

  public void resolveWallCollision() {
    collisionResolver.setBalls(this);
    collisionResolver.resolve();
  }

  public void move() {
    pos.add(velocity);
  }

  public void display() {
    fill(color_);
    noStroke();
    circle(pos.x, pos.y, radius * 2);
  }
  
  public void changeColor() {
    color_ = getRandomColor();
  }
  
  public boolean wallCollision() {
    return topBorderCollision() || bottomBorderCollision() || leftBorderCollision() || rightBorderCollision();
  }

  private boolean topBorderCollision() {
    return pos.x <= radius;
  }

  private boolean bottomBorderCollision() {
    return pos.x >= width - radius;
  }

  private boolean leftBorderCollision() {
    return pos.y <= radius;
  }

  private boolean rightBorderCollision() {
    return pos.y >= height - radius;
  }
  
  private PVector getRandVelocity() {
    return PVector.random2D().mult(random(MIN_BALL_SPEED, MAX_BALL_SPEED));
  }
  
  private color getRandomColor() {
    switch(BALL_COLOR_TYPE) {
      case "rand": return getRandColor();
      case "water": return getRandWaterColor();
      case "pastel": return getRandPastelColor();
      case "middle": return getRandMiddleColor();
      default: return color(0, 0, 0);
    }
  }
  
  private color getRandColor() {
    return color(random(255), random(255), random(255));
  }
  
  private color getRandWaterColor() {
    return color(0, random(25, 50), random(50, 255));
  }
  
  private color getRandPastelColor() {
    return color(random(100) + 155, random(100) + 155, random(100) + 155);
  }
  
  private color getRandMiddleColor() {
    return color(random(50, 180), random(50, 180), random(50, 180));
  }
}
