int r = 50;
int v = 5;
int C = 50;
Ball[] balls = new Ball[C];

class Ball {
  PVector position, velocity;
  int x, y;
  color rgb;

  Ball(int x, int y) {
    this.x = x;
    this.y = y;
    position = new PVector(x, y);
    velocity = new PVector(int(random(-v, v)), int(random(-v, v)));
  }

  void display() {
    fill(rgb, 100);
    ellipse(position.x, position.y, 2 * r, 2 * r);
  }

  void update() {
    if (velocity.x == 0 || velocity.y == 0) {
      velocity = new PVector(int(random(-v, v)), int(random(-v, v)));
    }
    position.add(velocity);
    if (position.x < r || position.x > width - r) {
      velocity.x *= -1;
    }
    if (position.y < r || position.y > height - r) {
      velocity.y *= -1;
    }
    position.x = constrain(position.x, r, width - r);
    position.y = constrain(position.y, r, height - r);
  }

  boolean checkCollision(Ball other) {
    float distance = dist(position.x, position.y, other.position.x, other.position.y);
    return distance < 2 * r;
  }

  void handleCollision(Ball other) {
    PVector collisionNormal = PVector.sub(other.position, position).normalize();

    // 충돌한 두 공을 분리
    float overlap = 2 * r - dist(position.x, position.y, other.position.x, other.position.y);
    PVector separation = PVector.mult(collisionNormal, overlap * 0.5);
    position.sub(separation);
    other.position.add(separation);

    // 충돌한 두 공의 속도 교환
    PVector temp = velocity;
    velocity = other.velocity;
    other.velocity = temp;
  }
}

void setup() {
  fullScreen();
  for (int i = 0; i < balls.length; i++) {
    Ball ball = new Ball(int(random(r, width - r)), int(random(r, height - r)));
    ball.rgb = color(int(random(100, 255)), int(random(100, 255)), int(random(100, 255)));
    balls[i] = ball;
  }
}

void draw() {
  background(255);
  for (Ball ball : balls) {
    ball.display();
    ball.update();
  }
  for (int i = 0; i < balls.length; i++) {
    for (int j = i + 1; j < balls.length; j++) {
      Ball ballA = balls[i];
      Ball ballB = balls[j];
      if (ballA.checkCollision(ballB)) {
        ballA.handleCollision(ballB);
      }
      float distance = dist(ballA.position.x, ballA.position.y, ballB.position.x, ballB.position.y);
      if (distance < 2 * r) {
        PVector separation = PVector.sub(ballB.position, ballA.position).normalize().mult((2 * r - distance) * 0.5);
        ballA.position.sub(separation);
        ballB.position.add(separation);
      }
    }
  }
}
