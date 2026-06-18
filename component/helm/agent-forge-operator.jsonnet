local kap = import 'lib/kapitan.libjsonnet';
local inv = kap.inventory();
local params = inv.parameters.agent_forge_operator;

local prometheusEnabledLabels =
  if std.member(inv.applications, 'prometheus') then
    {
      'monitoring.syn.tools/enabled': 'true',
    }
  else
    {};

local component = {
  image: params.images.operator,
  metrics: {
    serviceMonitor: {
      enabled: params.monitoring_enabled,
      additionalLabels: {
        prometheus: 'main',
      } + prometheusEnabledLabels,
    },
    prometheusRule: {
      enabled: params.monitoring_enabled,
      additionalLabels: {
        prometheus: 'main',
        role: 'alert-rules',
      } + prometheusEnabledLabels,
    },
  },
};

{
  'values-component': component,
  'values-overrides': params.helm_values,
}
