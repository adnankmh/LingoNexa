import 'package:flutter/material.dart';

import 'app.dart';
import 'core/app_state.dart';
import 'services/storage_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final state = AppState(StorageService());
  await state.initialize();
  runApp(LingoNexaApp(state: state));
}

