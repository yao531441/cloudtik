import logging
from typing import Any, Dict
from cloudtik.providers._private.aws.config import  create_aws_workspace, \
    delete_workspace_aws, check_aws_workspace_resource, update_aws_workspace_firewalls


from cloudtik.core.workspace_provider import WorkspaceProvider

logger = logging.getLogger(__name__)


class AWSWorkspaceProvider(WorkspaceProvider):
    def __init__(self, provider_config, workspace_name):
        WorkspaceProvider.__init__(self, provider_config, workspace_name)

    def create_workspace(self, cluster_config):
        create_aws_workspace(cluster_config)

    def delete_workspace(self, cluster_config):
        delete_workspace_aws(cluster_config)

    def update_workspace_firewalls(self, cluster_config):
        update_aws_workspace_firewalls(cluster_config)

    def check_workspace_resource(self, cluster_config):
        return check_aws_workspace_resource(cluster_config)

    @staticmethod
    def validate_config(
            provider_config: Dict[str, Any]):
        pass

    @staticmethod
    def bootstrap_workspace_config(cluster_config):
        return cluster_config
