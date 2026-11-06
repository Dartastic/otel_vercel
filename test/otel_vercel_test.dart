// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry/testing.dart';
import 'package:otel_vercel/otel_vercel.dart';
import 'package:test/test.dart';

void main() {
  late TestHarness harness;
  late InMemorySpanExporter spans;

  setUpAll(() async {
    harness = await maybeInitializeOtelForTest(
      serviceName: 'otel_vercel-test',
    );
    spans = harness.spans;
  });

  setUp(() => harness.clear());

  Map<String, Object> attrsOf(Span s) =>
      {for (final a in s.attributes.toList()) a.key: a.value};

  test('deployments.create records target + framework + git', () async {
    await tracedVercel<String>(
      operation: 'deployments.create',
      invoke: () async => const VercelCallResult(
        value: 'ok',
        result: VercelResult(
          surface: 'deployments',
          projectName: 'web',
          framework: 'next',
          deploymentTarget: 'production',
          deploymentState: 'READY',
          buildSource: 'git',
          gitProvider: 'github',
          gitBranch: 'main',
          region: 'iad1',
        ),
      ),
    );
    final a = attrsOf(spans.findSpanByName('vercel deployments.create')!);
    expect(a['vercel.framework'], 'next');
    expect(a['vercel.deployment.target'], 'production');
    expect(a['vercel.git.provider'], 'github');
    expect(a['vercel.region'], 'iad1');
  });

  test('ERROR deployment state sets span error', () async {
    await tracedVercel<String>(
      operation: 'deployments.create',
      invoke: () async => const VercelCallResult(
        value: 'ok',
        result: VercelResult(
          surface: 'deployments',
          deploymentState: 'ERROR',
        ),
      ),
    );
    expect(
      spans.findSpanByName('vercel deployments.create')!.status,
      SpanStatusCode.Error,
    );
  });

  test('function.invoke records cold start + duration', () async {
    await tracedVercel<String>(
      operation: 'function.invoke',
      invoke: () async => const VercelCallResult(
        value: 'ok',
        result: VercelResult(
          surface: 'functions',
          runtime: 'nodejs20.x',
          functionDurationMs: 123,
          functionMemoryMb: 1024,
          coldStart: true,
        ),
      ),
    );
    final a = attrsOf(spans.findSpanByName('vercel function.invoke')!);
    expect(a['vercel.function.duration_ms'], 123);
    expect(a['vercel.function.cold_start'], true);
    expect(a['vercel.runtime'], 'nodejs20.x');
  });

  test('rate_limit error sets span error', () async {
    await tracedVercel<String>(
      operation: 'deployments.list',
      invoke: () async => const VercelCallResult(
        value: 'ok',
        result: VercelResult(
          errorCode: 'rate_limit',
          statusCode: 429,
        ),
      ),
    );
    expect(
      spans.findSpanByName('vercel deployments.list')!.status,
      SpanStatusCode.Error,
    );
  });

  test('suppression skips spans', () async {
    await runWithoutVercelInstrumentationAsync(() async {
      await tracedVercel<String>(
        operation: 'projects.get',
        invoke: () async => const VercelCallResult(value: 'v'),
      );
    });
    expect(spans.findSpansStartingWith('vercel '), isEmpty);
  });
}
