local kap = import 'lib/kapitan.libjsonnet';
local inv = kap.inventory();
local params = inv.parameters.agent_forge_operator;
local argocd = import 'lib/argocd.libjsonnet';

local app = argocd.App('agent-forge-operator', params.namespace);

local appPath =
  local project = std.get(std.get(app, 'spec', {}), 'project', 'syn');
  if project == 'syn' then 'apps' else 'apps-%s' % project;

{
  ['%s/agent-forge-operator' % appPath]: app,
}
