import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/generated/app_localizations.dart';
import 'failure_text.dart';

/// Loading / erro (com retry) / dado, padronizado para toda lista e detalhe.
class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({
    required this.value,
    required this.data,
    this.onRetry,
    this.compact = false,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback? onRetry;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return value.when(
      skipLoadingOnRefresh: true,
      data: data,
      loading: () => Padding(
        padding: EdgeInsets.all(compact ? 12 : 32),
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) {
        final l10n = AppLocalizations.of(context);
        return Padding(
          padding: EdgeInsets.all(compact ? 12 : 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(failureText(l10n, error), textAlign: TextAlign.center),
              if (kDebugMode) ...[
                const SizedBox(height: 8),
                // Só em debug: a causa técnica (ex.: DioException connection error), para diagnosticar no aparelho.
                Text(
                  '$error',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
              if (onRetry != null) ...[
                const SizedBox(height: 12),
                OutlinedButton(onPressed: onRetry, child: Text(l10n.retry)),
              ],
            ],
          ),
        );
      },
    );
  }
}
