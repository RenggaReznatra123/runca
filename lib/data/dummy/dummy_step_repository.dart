import 'package:runca/repository/step_repository.dart';

/// Simulasi langkah treadmill: sekitar 2,5 langkah per detik.
class DummyStepRepository implements StepRepository {
  @override
  Stream<int> watchSteps() {
    return Stream<int>.periodic(const Duration(milliseconds: 400), (_) => 1);
  }
}
