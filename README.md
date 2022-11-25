# Ansible Collection - benschubert.ansible_lint_repro

Reproduction for a bug in ansible-lint operability with ansible-compat

Whenever a collection provides plugins and also uses them in roles locally,
`ansible-lint` complains that it can't resolve the FQCN of those plugins.

This is despite `ansible-lint` installing the collection beforehand.

## Reproducing

```
git clone -b bschubert/modules-fqdn https://github.com/BenjaminSchubert/ansible_lint_repro
cd ansible_lint_repro
ansible-lint
```

The expected output would then be:

```
WARNING  Unable to resolve FQCN for module benschubert.ansible_lint_repro.test_module
WARNING  Unable to resolve FQCN for module test_module

Passed with production profile: 0 failure(s), 0 warning(s) on 7 files.
```


Those two warnings are unexpected as far as I can tell
