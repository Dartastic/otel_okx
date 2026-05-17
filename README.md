# otel_okx

Dartastic OpenTelemetry bridge for OKX (crypto exchange + Web3).

Wraps each call in a CLIENT-kind span with vendor-specific attributes following OpenTelemetry semantic conventions where applicable.

```dart
import 'package:otel_okx/otel_okx.dart';

await tracedOkx<void>(
  operation: 'someOp',
  invoke: () async {
    final r = await client.someOp();
    return OkxCallResult(value: r, result: OkxResult(statusCode: 200));
  },
);
```

Suppress instrumentation within a block:

```dart
await runWithoutOkxInstrumentationAsync(() async {
  await client.someInternalSync();
});
```
