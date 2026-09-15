import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/rest_client.dart';
import 'dio.dart';

/// Cliente gerado (ADR 0004) sobre o Dio principal.
final restClientProvider = Provider<RestClient>((ref) => RestClient(ref.watch(dioProvider)));
