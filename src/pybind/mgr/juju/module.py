from mgr_module import MgrModule, Option, CLIWriteCommand
import orchestrator
import zaza
import zaza.model


class Module(MgrModule, orchestrator.Orchestrator):

    MODULE_OPTIONS = [
        Option(name="controller_url", type="str"),
        Option(name="controller_uuid", type="str"),
        Option(name="user", type="str"),
        Option(name="password", type="str"),
        # content of the Juju CA cert
        Option(name="ca_cert", type="str"),
    ]

    def __init__(self, *args, **kwargs):
        super(Module, self).__init__(*args, **kwargs)
        self.status_message = ""
        self.model = None

    def available(self):
        """ Check if Ansible Runner service is working
        """
        available = False
        msg = ""

        if self.model:
            # available = self.ar_client.is_operative()
            # if not available:
            #     msg = "No response from Ansible Runner Service"
        else:
            msg = "Not possible to connect to Juju model."

        # Add more details to the detected problem
        if self.status_message:
            msg = "{}:\n{}".format(msg, self.status_message)

        return (available, msg)

    def serve(self):
        try:
            self.model = zaza.model.Model()
            zaza.run(model.connect(
                endpoint=self.get_module_option('controller_url', ''),
                uuid=self.get_module_option('controller_uuid', ''),
                username=self.get_module_option('user', ''),
                password=self.get_module_option('user', ''),
                cacert=self.get_module_option('ca_cert', ''),
            ))
        except Exception: # Something?
            pass