local kap = import 'lib/kapitan.libjsonnet';
local kube = import 'lib/kube.libjsonnet';
local prometheus = import 'lib/prometheus.libsonnet';
local inv = kap.inventory();
local params = inv.parameters.agent_forge_operator;
local distribution = std.get(std.get(inv.parameters, 'facts', {}), 'distribution', '');

local monitoringLabels =
  if std.member([ 'openshift4', 'oke' ], distribution) then
    {
      'openshift.io/cluster-monitoring': 'true',
    }
  else
    {
      SYNMonitoring: 'main',
    };

local monitoringNamespaceLabel =
  if !params.monitoring_enabled then
    {}
  else
    monitoringLabels;

local namespace =
  if params.monitoring_enabled && std.member(inv.applications, 'prometheus') then
    prometheus.RegisterNamespace(kube.Namespace(params.namespace)) {
      metadata+: {
        labels+: monitoringNamespaceLabel,
      },
    }
  else
    kube.Namespace(params.namespace) {
      metadata+: {
        labels+: monitoringNamespaceLabel,
      },
    };

{
  '00_namespace': namespace,
}
