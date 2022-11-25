from ansible.module_utils.basic import AnsibleModule

def main():
    module = AnsibleModule()
    module.exit_json(msg="OK!")
