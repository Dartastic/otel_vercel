// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:otel_vercel/otel_vercel.dart';

/// Traces Vercel calls with OpenTelemetry.
///
/// `otel_vercel` depends on the OpenTelemetry API only, so the application
/// initializes an SDK once at startup. Wrap each Vercel call in
/// [tracedVercel]; the `invoke` callback makes the real call and reports what
/// came back, which is recorded on the span.
Future<void> main() async {
  await OTel.initialize(serviceName: 'vercel-example');

  // Traces a Vercel call.
  final vercelId = await tracedVercel<String>(
    operation: 'create',
    invoke: () async {
      // Make the Vercel call here, then report what it returned.
      const id = 'vercel_8f3a2c';
      return const VercelCallResult(
          value: id,
          result: VercelResult(
              team: 'example',
              surface: 'example',
              projectId: 'project_8f3a2c',
              projectName: 'example',
              framework: 'example',
              deploymentId: 'deployment_8f3a2c',
              deploymentTarget: 'example',
              deploymentState: 'active',
              buildId: 'build_8f3a2c',
              buildSource: 'example',
              gitProvider: 'example',
              gitBranch: 'example',
              gitCommit: 'example',
              region: 'us-east-1',
              runtime: 'example',
              functionDurationMs: 120,
              functionInvocations: 1,
              functionMemoryMb: 1,
              coldStart: true,
              edgeConfigId: 'edgeconfig_8f3a2c',
              blobPathname: '/v1/orders',
              blobSizeBytes: 512,
              kvKey: 'orders/2026/inv-1042.pdf',
              kvBytes: 512,
              aliasHostname: 'api.example.com',
              statusCode: 201,
              errorCode: 'example',
              errorMessage: 'example'));
    },
  );
  OTelLog.info('tracedVercel create returned $vercelId');

  // Calls that should not be traced, such as health checks, run inside
  // runWithoutVercelInstrumentationAsync.
  await runWithoutVercelInstrumentationAsync(
    () => tracedVercel<String>(
      operation: 'create',
      invoke: () async {
        const id = 'vercel_8f3a2c';
        return const VercelCallResult(
            value: id,
            result: VercelResult(
                team: 'example',
                surface: 'example',
                projectId: 'project_8f3a2c',
                projectName: 'example',
                framework: 'example',
                deploymentId: 'deployment_8f3a2c',
                deploymentTarget: 'example',
                deploymentState: 'active',
                buildId: 'build_8f3a2c',
                buildSource: 'example',
                gitProvider: 'example',
                gitBranch: 'example',
                gitCommit: 'example',
                region: 'us-east-1',
                runtime: 'example',
                functionDurationMs: 120,
                functionInvocations: 1,
                functionMemoryMb: 1,
                coldStart: true,
                edgeConfigId: 'edgeconfig_8f3a2c',
                blobPathname: '/v1/orders',
                blobSizeBytes: 512,
                kvKey: 'orders/2026/inv-1042.pdf',
                kvBytes: 512,
                aliasHostname: 'api.example.com',
                statusCode: 201,
                errorCode: 'example',
                errorMessage: 'example'));
      },
    ),
  );

  await OTel.shutdown();
}
