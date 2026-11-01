// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:otel_okx/otel_okx.dart';
import 'package:test/test.dart';

void main() {
  group('otel_okx', () {
    test('suppression toggles in zone', () async {
      expect(okxInstrumentationSuppressed(), isFalse);
      await runWithoutOkxInstrumentationAsync(() async {
        expect(okxInstrumentationSuppressed(), isTrue);
      });
      expect(okxInstrumentationSuppressed(), isFalse);
    });

    test('OkxResult fields default null', () {
      const r = OkxResult();
      expect(r.statusCode, isNull);
    });
  });
}
