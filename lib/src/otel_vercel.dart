// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry_api/dartastic_opentelemetry_api.dart';

import 'otel_vercel_suppression.dart';

class VercelResult {
  /// Creates a result.
  const VercelResult({
    this.team,
    this.surface,
    this.projectId,
    this.projectName,
    this.framework,
    this.deploymentId,
    this.deploymentTarget,
    this.deploymentState,
    this.buildId,
    this.buildSource,
    this.gitProvider,
    this.gitBranch,
    this.gitCommit,
    this.region,
    this.runtime,
    this.functionDurationMs,
    this.functionInvocations,
    this.functionMemoryMb,
    this.coldStart,
    this.edgeConfigId,
    this.blobPathname,
    this.blobSizeBytes,
    this.kvKey,
    this.kvBytes,
    this.aliasHostname,
    this.statusCode,
    this.errorCode,
    this.errorMessage,
  });

  final String? team;
  final String? surface;
  final String? projectId;
  final String? projectName;
  final String? framework;
  final String? deploymentId;
  final String? deploymentTarget;
  final String? deploymentState;
  final String? buildId;
  final String? buildSource;
  final String? gitProvider;
  final String? gitBranch;
  final String? gitCommit;
  final String? region;
  final String? runtime;
  final int? functionDurationMs;
  final int? functionInvocations;
  final int? functionMemoryMb;
  final bool? coldStart;
  final String? edgeConfigId;
  final String? blobPathname;
  final int? blobSizeBytes;
  final String? kvKey;
  final int? kvBytes;
  final String? aliasHostname;
  final int? statusCode;
  final String? errorCode;
  final String? errorMessage;
}

/// What a traced call returned: the value for the caller plus fields
/// recorded on the span.
class VercelCallResult<T> {
  /// Creates a call result.
  const VercelCallResult({required this.value, this.result});

  /// The value returned to the caller.
  final T value;
  final VercelResult? result;
}

Future<T> tracedVercel<T>({
  required String operation,
  required Future<VercelCallResult<T>> Function() invoke,
  APITracer? tracer,
}) async {
  if (vercelInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTelAPI.tracerProvider().getTracer('otel_vercel');
  final span = t.startSpan('vercel $operation', kind: SpanKind.client);
  try {
    span.addAttributes(
        OTelAPI.attributes([OTelAPI.attributeString('rpc.system', 'vercel')]));
    span.addAttributes(
        OTelAPI.attributes([OTelAPI.attributeString('rpc.method', operation)]));
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.team != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('vercel.team', res.team!)]));
      }
      if (res.surface != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('vercel.surface', res.surface!)]));
      }
      if (res.projectId != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('vercel.project.id', res.projectId!)]));
      }
      if (res.projectName != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('vercel.project.name', res.projectName!)
        ]));
      }
      if (res.framework != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('vercel.framework', res.framework!)]));
      }
      if (res.deploymentId != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('vercel.deployment.id', res.deploymentId!)
        ]));
      }
      if (res.deploymentTarget != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              'vercel.deployment.target', res.deploymentTarget!)
        ]));
      }
      if (res.deploymentState != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              'vercel.deployment.state', res.deploymentState!)
        ]));
      }
      if (res.buildId != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('vercel.build.id', res.buildId!)]));
      }
      if (res.buildSource != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('vercel.build.source', res.buildSource!)
        ]));
      }
      if (res.gitProvider != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('vercel.git.provider', res.gitProvider!)
        ]));
      }
      if (res.gitBranch != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('vercel.git.branch', res.gitBranch!)]));
      }
      if (res.gitCommit != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('vercel.git.commit', res.gitCommit!)]));
      }
      if (res.region != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('vercel.region', res.region!)]));
      }
      if (res.runtime != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('vercel.runtime', res.runtime!)]));
      }
      if (res.functionDurationMs != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt(
              'vercel.function.duration_ms', res.functionDurationMs!)
        ]));
      }
      if (res.functionInvocations != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt(
              'vercel.function.invocations', res.functionInvocations!)
        ]));
      }
      if (res.functionMemoryMb != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt(
              'vercel.function.memory_mb', res.functionMemoryMb!)
        ]));
      }
      if (res.coldStart != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeBool('vercel.function.cold_start', res.coldStart!)
        ]));
      }
      if (res.edgeConfigId != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('vercel.edge_config.id', res.edgeConfigId!)
        ]));
      }
      if (res.blobPathname != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('vercel.blob.pathname', res.blobPathname!)
        ]));
      }
      if (res.blobSizeBytes != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('vercel.blob.size_bytes', res.blobSizeBytes!)
        ]));
      }
      if (res.kvKey != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('vercel.kv.key', res.kvKey!)]));
      }
      if (res.kvBytes != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeInt('vercel.kv.bytes', res.kvBytes!)]));
      }
      if (res.aliasHostname != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('vercel.alias.hostname', res.aliasHostname!)
        ]));
      }
      if (res.statusCode != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('http.response.status_code', res.statusCode!)
        ]));
      }
      if (res.errorCode != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('vercel.error.code', res.errorCode!)]));
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400) ||
          res.deploymentState == 'ERROR' ||
          res.deploymentState == 'CANCELED';
      if (fail) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              ErrorAttributes.errorType.key, res.errorCode ?? 'vercel.error')
        ]));
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
