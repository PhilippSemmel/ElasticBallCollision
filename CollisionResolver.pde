class CollisionResolver {
  Ball ball1;
  Ball ball2;

  public void setBalls(Ball ball) {
    ball1 = ball;
    ball2 = null;
  }

  public void setBalls(Ball ball1, Ball ball2) {
    this.ball1 = ball1;
    this.ball2 = ball2;
  }

  public void resolve() {
    if (wallCollisionToResolve()) {
      resolveWallCollision();
    } else {
      resolveBallCollision();
    }
  }

  private boolean wallCollisionToResolve() {
    return ball2 == null;
  }

  private void resolveBallCollision() {
    PVector[] unitVectors = getUnitVectors();
    float[] velocityComponents = getVelocityComponents(unitVectors);
    velocityComponents = calcNewVelocityComponents(velocityComponents);
    PVector[] velocityComponentsVectors = getNewVelocityCompoentsVectors(unitVectors, velocityComponents);
    setNewBallVelocities(velocityComponentsVectors);
  }

  private PVector[] getUnitVectors() {
    PVector unitNormal = PVector.sub(ball2.pos, ball1.pos).normalize();
    PVector unitTangent = new PVector(-unitNormal.y, unitNormal.x);
    return new PVector[] {unitNormal, unitTangent};
  }

  private float[] getVelocityComponents(PVector[] unitVectors) {
    return new float [] {
      ball1.velocity.dot(unitVectors[0]),
      ball1.velocity.dot(unitVectors[1]),
      ball2.velocity.dot(unitVectors[0]),
      ball2.velocity.dot(unitVectors[1])
    };
  } //<>//

  private float[] calcNewVelocityComponents(float[] velocityComponents) {
    return new float[] {
      calcNewVelocityComponent(velocityComponents[0], velocityComponents[2], ball1.mass, ball2.mass),
      velocityComponents[1],
      calcNewVelocityComponent(velocityComponents[2], velocityComponents[0], ball2.mass, ball1.mass),
      velocityComponents[3]
    };
  }

  private float calcNewVelocityComponent(float v1, float v2, float m1, float m2) {
    return ((v1 * (m1 - m2)) + (2 * m2 * v2)) / (m1 + m2);
  }

  private PVector[] getNewVelocityCompoentsVectors(PVector[] unitVectors, float[] velocityComponents) {
    PVector[] vectors = new PVector[4];
    for (int i = 0; i < 4; i++) {
      vectors[i] = PVector.mult(unitVectors[i % 2], velocityComponents[i]);
    }
    return vectors;
  }

  private void setNewBallVelocities(PVector[] velocityComponentsVectors) {
    ball1.velocity = PVector.add(velocityComponentsVectors[0], velocityComponentsVectors[1]);
    ball2.velocity = PVector.add(velocityComponentsVectors[2], velocityComponentsVectors[3]);
  }

  private void resolveWallCollision() {
    if (ball1.topBorderCollision()) {
      ball1.pos.x = ball1.radius;
      ball1.velocity.x *= -1.0;
    } else if (ball1.bottomBorderCollision()) {
      ball1.pos.x = width - ball1.radius;
      ball1.velocity.x *= -1.0;
    } else if (ball1.leftBorderCollision()) {
      ball1.pos.y = ball1.radius;
      ball1.velocity.y *= -1.0;
    } else if (ball1.rightBorderCollision()) {
      ball1.pos.y = height - ball1.radius;
      ball1.velocity.y *= -1.0;
    }
  }
}
