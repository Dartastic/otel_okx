// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:otel_okx/otel_okx.dart';

/// Traces Okx calls with OpenTelemetry.
///
/// `otel_okx` depends on the OpenTelemetry API only, so the application
/// initializes an SDK once at startup. Wrap each Okx call in
/// [tracedOkx]; the `invoke` callback makes the real call and reports what
/// came back, which is recorded on the span.
Future<void> main() async {
  await OTel.initialize(serviceName: 'okx-example');

  // Traces a Okx call.
  final okxId = await tracedOkx<String>(
    operation: 'create',
    invoke: () async {
      // Make the Okx call here, then report what it returned.
      const id = 'okx_8f3a2c';
      return const OkxCallResult(
          value: id,
          result: OkxResult(
              instrument: 'example',
              side: 'example',
              orderType: 'standard',
              orderId: 'order_8f3a2c',
              clientOrderId: 'clientorder_8f3a2c',
              size: 0.5,
              price: 0.5,
              fee: 0.5,
              status: 'succeeded',
              statusCode: 201,
              errorCode: 'example',
              errorMessage: 'example'));
    },
  );
  OTelLog.info('tracedOkx create returned $okxId');

  // Calls that should not be traced, such as health checks, run inside
  // runWithoutOkxInstrumentationAsync.
  await runWithoutOkxInstrumentationAsync(
    () => tracedOkx<String>(
      operation: 'create',
      invoke: () async {
        const id = 'okx_8f3a2c';
        return const OkxCallResult(
            value: id,
            result: OkxResult(
                instrument: 'example',
                side: 'example',
                orderType: 'standard',
                orderId: 'order_8f3a2c',
                clientOrderId: 'clientorder_8f3a2c',
                size: 0.5,
                price: 0.5,
                fee: 0.5,
                status: 'succeeded',
                statusCode: 201,
                errorCode: 'example',
                errorMessage: 'example'));
      },
    ),
  );

  await OTel.shutdown();
}
