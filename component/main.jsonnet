local kap = import 'lib/kapitan.libjsonnet';
local kube = import 'lib/kube.libjsonnet';
local inv = kap.inventory();
local params = inv.parameters.agent_forge_operator;

{
  '00_namespace': kube.Namespace(params.namespace),
}
