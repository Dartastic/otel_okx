# Changelog

## [0.1.0-beta.1-wip]

### Added

- Initial release.
- `tracedOkx<T>(...)` — wraps a otel_okx call in a CLIENT-kind span
  with vendor-specific attributes.
- Zone-scoped suppression via `runWithoutOkxInstrumentation()` / `Async()`.
