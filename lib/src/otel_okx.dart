// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry_api/dartastic_opentelemetry_api.dart';

import 'otel_okx_suppression.dart';

class OkxResult {
  const OkxResult({
    this.instrument,
    this.side,
    this.orderType,
    this.orderId,
    this.clientOrderId,
    this.size,
    this.price,
    this.fee,
    this.status,
    this.statusCode,
    this.errorCode,
    this.errorMessage,
  });

  final String? instrument;
  final String? side;
  final String? orderType;
  final String? orderId;
  final String? clientOrderId;
  final double? size;
  final double? price;
  final double? fee;
  final String? status;
  final int? statusCode;
  final String? errorCode;
  final String? errorMessage;
}

class OkxCallResult<T> {
  const OkxCallResult({required this.value, this.result});
  final T value;
  final OkxResult? result;
}

Future<T> tracedOkx<T>({
  required String operation,
  required Future<OkxCallResult<T>> Function() invoke,
  Tracer? tracer,
}) async {
  if (okxInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTel.tracerProvider().getTracer('otel_okx');
  final span = t.startSpan('okx $operation', kind: SpanKind.client);
  try {
    span.setStringAttribute('rpc.system', 'okx');
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.instrument != null) {
        span.setStringAttribute('okx.instrument', res.instrument!);
      }
      if (res.side != null) {
        span.setStringAttribute('okx.side', res.side!);
      }
      if (res.orderType != null) {
        span.setStringAttribute('okx.order.type', res.orderType!);
      }
      if (res.orderId != null) {
        span.setStringAttribute('okx.order.id', res.orderId!);
      }
      if (res.clientOrderId != null) {
        span.setStringAttribute('okx.client_order.id', res.clientOrderId!);
      }
      if (res.size != null) {
        span.setDoubleAttribute('okx.size', res.size!);
      }
      if (res.price != null) {
        span.setDoubleAttribute('okx.price', res.price!);
      }
      if (res.fee != null) {
        span.setDoubleAttribute('okx.fee', res.fee!);
      }
      if (res.status != null) {
        span.setStringAttribute('okx.status', res.status!);
      }
      if (res.statusCode != null) {
        span.setIntAttribute('http.response.status_code', res.statusCode!);
      }
      if (res.errorCode != null) {
        span.setStringAttribute('okx.error.code', res.errorCode!);
      }
      final fail =
          res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400);
      if (fail) {
        span.setStringAttribute(
          ErrorResource.errorType.key,
          res.errorCode ?? 'okx.error',
        );
        span.setStatus(SpanStatusCode.Error, res.errorMessage);
      }
    }
    return r.value;
  } catch (e, st) {
    span.recordException(e, stackTrace: st);
    span.setStatus(SpanStatusCode.Error, e.toString());
    rethrow;
  } finally {
    span.end();
  }
}
