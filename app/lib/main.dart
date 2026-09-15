import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'app.dart';

void main() {
  // URLs sem `#` (APP.md §5). A borda faz fallback para index.html.
  usePathUrlStrategy();
  runApp(const ProviderScope(child: PortfolioApp()));
}
