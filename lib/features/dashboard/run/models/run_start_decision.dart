import '../cubit/run_state.dart';
import 'run_settings.dart';

sealed class RunStartDecision {
  const RunStartDecision();
}

final class RunStartChecking extends RunStartDecision {
  const RunStartChecking();
}

final class RunStartBlocked extends RunStartDecision {
  const RunStartBlocked(this.status);

  final RunLocationStatus status;
}

final class RunStartReady extends RunStartDecision {
  const RunStartReady(this.settings);

  final RunSettings settings;
}
