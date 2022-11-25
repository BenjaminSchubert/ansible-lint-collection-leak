# Ansible Collection - benschubert.ansible_lint_repro

Reproduction for a bug in ansible-lint operability with ansible-compat

When a collection depends on another one, `ansible-lint` won't be able to find
it's dependency unless it's installed globally, or overriden with a
`ANSIBLE_COLLECTIONS_PATH`.

This is despite `ansible-lint` running `ansible-galaxy` to install the current
collection.

We can therefore assume that the check is not isolated and the environment leaks
into it. In addition to that, collections not installed globally are ignored.


## Reproducing

The easiest way of reproducing is by using the provided `docker-compose.yml`
setup. It contains three different containers:

- **ansible** which has the full `ansible` package installed, with all the
bundled collections
- **ansible-core-and-collection** which contains `ansible-core` only, but has
the required collections installed via ansible-galaxy for the user.
- **ansible-core-only** which only contains `ansible-core`.

You can run the three setup like:

```bash
docker-compose build  # ensure the images are up to date
docker-compose up
```

Which will give the following output:

```
ansible-core-and-collection_1  |
ansible-core-and-collection_1  | Passed with production profile: 0 failure(s), 0 warning(s) on 8 files.
ansible-lint-repro_ansible-core-and-collection_1 exited with code 0
ansible_1                      |
ansible_1                      | Passed with production profile: 0 failure(s), 0 warning(s) on 8 files.
ansible-lint-repro_ansible_1 exited with code 0
ansible-core-only_1            | WARNING  Unable to resolve FQCN for module kubernetes.core.helm
ansible-core-only_1            |
ansible-core-only_1            | Passed with production profile: 0 failure(s), 0 warning(s) on 8 files.
ansible-core-only_1            | WARNING  Unable to resolve FQCN for module kubernetes.core.helm
ansible-lint-repro_ansible-core-only_1 exited with code 1
```

In which we can see, only the `ansible-core-only` image has a warning and fails
to resolve the FQCN from `kubernetes.core.helm`
