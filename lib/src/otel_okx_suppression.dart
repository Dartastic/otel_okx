// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'dart:async';

const _key = #dartastic_otel_libs_okx_suppress;

bool okxInstrumentationSuppressed() => Zone.current[_key] == true;

T runWithoutOkxInstrumentation<T>(T Function() body) =>
    runZoned(body, zoneValues: {_key: true});

Future<T> runWithoutOkxInstrumentationAsync<T>(Future<T> Function() body) =>
    runZoned(body, zoneValues: {_key: true});
