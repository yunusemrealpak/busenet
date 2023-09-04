import 'package:busenet/busenet.dart';

final class EmptyEntity extends BaseEntity<EmptyEntity> {
  @override
  EmptyEntity fromJson(data) {
    return EmptyEntity();
  }
}
