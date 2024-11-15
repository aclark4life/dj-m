## dj-m
## for django-mongodb development

# list all available recipes
default: just-list

# ---------------------------------------- django ----------------------------------------

# django-install
[group('django')]
django-install: check-venv pip-install django-mongodb-templates
alias install := django-install
alias i := django-install

# django-open
[group('django')]
django-open:
    open http://0.0.0.0:8000
alias o := django-open

# django-mongodb-templates
[group('django')]
django-mongodb-templates:
    git clone git@github.com:aclark4life/django-mongodb-app src/django-mongodb-app
    git clone git@github.com:aclark4life/django-mongodb-project src/django-mongodb-project

# ---------------------------------------- git ----------------------------------------

# git checkout .
[group('git')]
git-checkout:
    pushd src/django && git checkout . && popd
    pushd src/django-mongodb && git checkout . && popd
    pushd src/pymongo && git checkout . && popd
alias co := git-checkout

# git commit and push
[group('git')]
git-commit-push:
    git commit -a -m "Add/update dj-m recipes."
    git push
alias cp := git-commit-push

# git commit, edit commit message, and push
[group('git')]
git-commit-edit-push:
    git commit -a
    git push
alias ce := git-commit-edit-push

# git fetch
[group('git')]
git-fetch:
    pushd src/django-mongodb && git fetch upstream && popd
    pushd src/django-mongodb-app && git fetch upstream && popd
    pushd src/django-mongodb-project && git fetch upstream && popd
    pushd src/django && git fetch upstream && popd
    pushd src/pymongo && git fetch upstream && popd
alias f := git-fetch

# git log
[group('git')]
git-log:
    git log --oneline
alias lo := git-log

# git pull
[group('git')]
git-pull:
    #!/bin/bash
    pushd src/django && git pull && popd
    pushd src/django-mongodb && git pull && popd
    pushd src/django-mongodb-app && git pull && popd
    pushd src/django-mongodb-project && git pull && popd
    pushd src/pymongo && git pull && popd
alias p := git-pull

# git remote add
[group('git')]
git-remote-add:
    -pushd src/django-mongodb && git remote add upstream git@github.com:mongodb-labs/django-mongodb && popd
    -pushd src/django-mongodb-app && git remote add upstream git@github.com:mongodb-labs/django-mongodb-app && popd
    -pushd src/django-mongodb-project && git remote add upstream git@github.com:mongodb-labs/django-mongodb-project && popd
    -pushd src/django && git remote add upstream git@github.com:mongodb-forks/django && popd
    pushd src/pymongo && git remote add upstream git@github.com:mongodb/mongo-python-driver && popd
alias a := git-remote-add

# ---------------------------------------- just ----------------------------------------

# list all available recipes
[group('just')]
just-list:
    @just -l
alias l := just-list

# edit the justfile
[group('just')]
just-edit:
    nvim dj_m/__init__.py
alias e := just-edit

# ---------------------------------------- python ----------------------------------------

[group('python')]
pip-install:
    pip install -U pip
    pip install -e .
    export PIP_SRC=src && pip install -r requirements.txt

# ensure virtual environment is active
[group('python')]
check-venv:
    #!/bin/bash
    PYTHON_PATH=$(which python)
    if [[ $PYTHON_PATH == *".venv/bin/python" ]]; then
      echo "Virtual environment is active."
    else
      echo "Virtual environment is not active."
      exit 1
    fi
