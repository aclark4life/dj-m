## dj-m
## for django-mongodb development

# ---------------------------------------- django ----------------------------------------

# django-mongodb-templates
[group('django')]
django-mongodb-templates:
    -git clone git@github.com:aclark4life/django-mongodb-app src/django-mongodb-app
    git clone git@github.com:aclark4life/django-mongodb-project src/django-mongodb-project

# ---------------------------------------- git ----------------------------------------

# git checkout .
[group('git')]
git-checkout:
    pushd src/django && git checkout . && popd
    pushd src/django-mongodb && git checkout . && popd
    pushd src/pymongo && git checkout . && popd
alias co := git-checkout

# git fetch
[group('git')]
git-fetch:
    pushd src/django-mongodb && git fetch upstream && popd
    pushd src/django-mongodb-app && git fetch upstream && popd
    pushd src/django-mongodb-project && git fetch upstream && popd
    pushd src/django && git fetch upstream && popd
    pushd src/pymongo && git fetch upstream && popd
alias f := git-fetch

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
