import 'package:flame/components.dart';

/// Manages input state from joysticks
class InputSystem {
  Vector2 moveDirection = Vector2.zero();
  Vector2 aimDirection = Vector2(1, 0);
  bool isShooting = false;

  void updateMove(Vector2 direction) {
    moveDirection = direction;
  }

  void updateAim(Vector2 direction) {
    if (direction.length > 0.1) {
      aimDirection = direction.normalized();
      isShooting = true;
    } else {
      isShooting = false;
    }
  }

  void stopMove() {
    moveDirection = Vector2.zero();
  }

  void stopAim() {
    isShooting = false;
  }
}
