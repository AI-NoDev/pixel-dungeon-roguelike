import 'package:flame/components.dart';

/// Common interface for any item that the player can pick up by pressing
/// the interaction button while standing near it.
///
/// All pickups must also be PositionComponents so the game can compute
/// distance-to-player for the "nearest pickup" logic.
abstract class InteractablePickup {
  /// Label shown next to the interaction button hint.
  String get pickupLabel;

  /// True once the pickup has been consumed and should be ignored.
  bool get isConsumed;

  /// Trigger the actual pickup behaviour. The pickup is responsible for
  /// removing itself from the world if appropriate.
  void interact();

  /// Position in world space (provided by PositionComponent).
  Vector2 get position;
}
