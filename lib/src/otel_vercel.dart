// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry_api/dartastic_opentelemetry_api.dart';

import 'otel_vercel_suppression.dart';

class VercelResult {
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

class VercelCallResult<T> {
  const VercelCallResult({required this.value, this.result});
  final T value;
  final VercelResult? result;
}

Future<T> tracedVercel<T>({
  required String operation,
  required Future<VercelCallResult<T>> Function() invoke,
  Tracer? tracer,
}) async {
  if (vercelInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTel.tracerProvider().getTracer('otel_vercel');
  final span = t.startSpan('vercel $operation', kind: SpanKind.client);
  try {
    span.setStringAttribute('rpc.system', 'vercel');
    span.setStringAttribute('rpc.method', operation);
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.team != null) {
        span.setStringAttribute('vercel.team', res.team!);
      }
      if (res.surface != null) {
        span.setStringAttribute('vercel.surface', res.surface!);
      }
      if (res.projectId != null) {
        span.setStringAttribute('vercel.project.id', res.projectId!);
      }
      if (res.projectName != null) {
        span.setStringAttribute('vercel.project.name', res.projectName!);
      }
      if (res.framework != null) {
        span.setStringAttribute('vercel.framework', res.framework!);
      }
      if (res.deploymentId != null) {
        span.setStringAttribute('vercel.deployment.id', res.deploymentId!);
      }
      if (res.deploymentTarget != null) {
        span.setStringAttribute(
            'vercel.deployment.target', res.deploymentTarget!);
      }
      if (res.deploymentState != null) {
        span.setStringAttribute(
            'vercel.deployment.state', res.deploymentState!);
      }
      if (res.buildId != null) {
        span.setStringAttribute('vercel.build.id', res.buildId!);
      }
      if (res.buildSource != null) {
        span.setStringAttribute('vercel.build.source', res.buildSource!);
      }
      if (res.gitProvider != null) {
        span.setStringAttribute('vercel.git.provider', res.gitProvider!);
      }
      if (res.gitBranch != null) {
        span.setStringAttribute('vercel.git.branch', res.gitBranch!);
      }
      if (res.gitCommit != null) {
        span.setStringAttribute('vercel.git.commit', res.gitCommit!);
      }
      if (res.region != null) {
        span.setStringAttribute('vercel.region', res.region!);
      }
      if (res.runtime != null) {
        span.setStringAttribute('vercel.runtime', res.runtime!);
      }
      if (res.functionDurationMs != null) {
        span.setIntAttribute(
            'vercel.function.duration_ms', res.functionDurationMs!);
      }
      if (res.functionInvocations != null) {
        span.setIntAttribute(
            'vercel.function.invocations', res.functionInvocations!);
      }
      if (res.functionMemoryMb != null) {
        span.setIntAttribute(
            'vercel.function.memory_mb', res.functionMemoryMb!);
      }
      if (res.coldStart != null) {
        span.setBoolAttribute('vercel.function.cold_start', res.coldStart!);
      }
      if (res.edgeConfigId != null) {
        span.setStringAttribute('vercel.edge_config.id', res.edgeConfigId!);
      }
      if (res.blobPathname != null) {
        span.setStringAttribute('vercel.blob.pathname', res.blobPathname!);
      }
      if (res.blobSizeBytes != null) {
        span.setIntAttribute('vercel.blob.size_bytes', res.blobSizeBytes!);
      }
      if (res.kvKey != null) {
        span.setStringAttribute('vercel.kv.key', res.kvKey!);
      }
      if (res.kvBytes != null) {
        span.setIntAttribute('vercel.kv.bytes', res.kvBytes!);
      }
      if (res.aliasHostname != null) {
        span.setStringAttribute('vercel.alias.hostname', res.aliasHostname!);
      }
      if (res.statusCode != null) {
        span.setIntAttribute('http.response.status_code', res.statusCode!);
      }
      if (res.errorCode != null) {
        span.setStringAttribute('vercel.error.code', res.errorCode!);
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400) ||
          res.deploymentState == 'ERROR' ||
          res.deploymentState == 'CANCELED';
      if (fail) {
        span.setStringAttribute(
            ErrorResource.errorType.key, res.errorCode ?? 'vercel.error');
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
