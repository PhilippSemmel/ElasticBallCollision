// settings
int FRAME_RATE = 120;
color BACKGROUND_COLOR = color(150);
int BALL_NUMBER = 25;
float MAX_BALL_RADIUS = 50.0F;
float MIN_BALL_RADIUS = 25.0F;
float MAX_BALL_SPEED = 10.0 * (60.0 / FRAME_RATE);
float MIN_BALL_SPEED = 2.0 * (60.0 / FRAME_RATE);
boolean RESOLVE_BALL_COLLISIONS = true;
boolean BALLS_CHANGE_COLOR_ON_COLLISION = false;
String BALL_COLOR_TYPE = "pastel"; // options: rand, water, pastel, middle, black

// objects
Ball[] balls;
CollisionResolver collisionResolver;

private class NoCollisionToResolve extends Exception{}

void setup() {
  fullScreen();
  frameRate(FRAME_RATE);
  collisionResolver = new CollisionResolver();
  balls = newBallsArray();
}

void draw() {
  background(BACKGROUND_COLOR);
  resolveCollisions();
  moveBalls();
  displayBalls();
}

void resolveCollisions() {
  resolveBallCollisions();
  resolveWallCollisions();
}

void resolveBallCollisions() {
  if (!RESOLVE_BALL_COLLISIONS) return;
  while (true) {
    try {
      resolveAllCurrentBallCollisions();
    }
    catch (NoCollisionToResolve e) {
      break;
    }
  }
}

void resolveAllCurrentBallCollisions() throws NoCollisionToResolve {
  boolean collisionResolved = false;
  for (int i = 0; i < BALL_NUMBER; i++) {
    for (int j = i + 1; j < BALL_NUMBER; j++) {
      if (!balls[i].ballCollision(balls[j])) continue;
      collisionResolved = true;
      resolveBallCollision(balls[i], balls[j]);
    }
  }
  if (!collisionResolved) throw new NoCollisionToResolve();
}

void resolveBallCollision(Ball ball1, Ball ball2) {
  ball1.resolveBallCollision(ball2);
  if (BALLS_CHANGE_COLOR_ON_COLLISION) {
    ball1.changeColor();
    ball2.changeColor();
  }
}

void resolveWallCollisions() {
  for (Ball ball : balls) {
    resolveWallCollision(ball);
  }
}

void resolveWallCollision(Ball ball) {
  if (!ball.wallCollision()) return;
  ball.resolveWallCollision();
  if (BALLS_CHANGE_COLOR_ON_COLLISION) ball.changeColor();
}

void moveBalls() {
  for (Ball b : balls) {
    b.move();
  }
}

void displayBalls() {
  for (Ball b : balls) {
    b.display();
  }
}

Ball[] newBallsArray() {
  Ball[] balls = new Ball[BALL_NUMBER];
  for (int i = 0; i < BALL_NUMBER; i++) {
    float radius = getRandRadius();
    PVector pos = getRandPos(radius, balls, i);
    balls[i] = new Ball(pos, radius);
  }
  return balls;
}

float getRandRadius() {
  return random(MIN_BALL_RADIUS, MAX_BALL_RADIUS);
}

PVector getRandPos(float radius, Ball[] balls, int initializedBalls) {
  while (true) {
    PVector pos = new PVector(getRandXPosForNewBall(radius), getRandYPosForNewBall(radius));
    if (toCloseToOtherBalls(pos, radius, balls, initializedBalls)) continue;
    return pos;
  }
}

float getRandXPosForNewBall(float radius) {
  return random(radius, width - radius);
}

float getRandYPosForNewBall(float radius) {
  return random(radius, height - radius);
}

boolean toCloseToOtherBalls(PVector pos, float radius, Ball[] balls, int initializedBalls) {
  for (int i = 0; i < initializedBalls; i++) {
    if (pos.dist(balls[i].pos) <= radius + balls[i].radius) return true;
  }
  return false;
}

boolean toColoseToOtherBall(PVector pos, float radius, Ball other) {
  return pos.dist(other.pos) <= radius + other.radius;
}
