import 'package:flame/components.dart';

/// Manages input state from joysticks.
///
/// Aim joystick has TWO states:
/// - touched but inside deadzone → auto-aim mode (player just holds finger)
/// - dragged outside deadzone → manual aim mode (player explicitly aims)
class InputSystem {
  Vector2 moveDirection = Vector2.zero();
  Vector2 aimDirection = Vector2(1, 0);

  /// True whenever finger is touching the aim joystick (auto OR manual).
  bool isShooting = false;

  /// True ONLY when player has dragged the joystick out of deadzone.
  bool isManualAim = false;

  static const double _deadzone = 0.3;

  void updateMove(Vector2 direction) {
    moveDirection = direction;
  }

  /// Right joystick update.
  /// Even if direction is below deadzone, still set isShooting=true while held.
  void updateAim(Vector2 direction) {
    isShooting = true;
    if (direction.length > _deadzone) {
      aimDirection = direction.normalized();
      isManualAim = true;
    } else {
      // Inside deadzone - keep last aim direction, mark as auto-aim mode
      isManualAim = false;
    }
  }

  void stopMove() {
    moveDirection = Vector2.zero();
  }

  void stopAim() {
    isShooting = false;
    isManualAim = false;
  }
}
