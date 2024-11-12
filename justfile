## dj-click
## for django-mongodb development

# list all available recipes
default: just-list

# ---------------------------------------- django ----------------------------------------

# django-dbshell
[group('django')]
django-dbshell:
    python manage.py dbshell
alias dbshell := django-dbshell
alias dbsh := django-dbshell

# django-install
[group('django')]
django-install: check-venv pip-install
alias install := django-install
alias i := django-install

# django-migrate
[group('django')]
django-migrate: check-venv
    python manage.py migrate
alias migrate := django-migrate
alias m := django-migrate

# django-migrations
[group('django')]
django-migrations: check-venv
    python manage.py makemigrations
alias migrations := django-migrations

# django-shell
[group('django')]
django-shell: check-venv
    python manage.py shell
alias shell := django-shell
alias sh := django-shell

# django-sqlmigrate
[group('django')]
django-sqlmigrate app_label migration_name:
    python manage.py sqlmigrate {{ app_label }} {{ migration_name }}
alias sqlmigrate := django-sqlmigrate

# django-su
[group('django')]
django-su: check-venv
    DJANGO_SUPERUSER_PASSWORD=admin python manage.py createsuperuser --noinput \
        --username=admin --email=`git config user.mail`
alias su := django-su

# django-open
[group('django')]
django-open:
    open http://0.0.0.0:8000
alias o := django-open

# ---------------------------------------- git ----------------------------------------

# git checkout .
[group('git')]
git-checkout:
    pushd src/django && git checkout . && popd
    pushd src/django-mongodb && git checkout . && popd
    pushd src/pymongo && git checkout . && popd
alias gco := git-checkout

# git commit with last commit message
[group('git')]
git-commit-last:
    git log -1 --pretty=%B | git commit -a -F -
    git push
alias last := git-commit-last

# git commit and push
[group('git')]
git-commit-push:
    git commit -a -m "Add/update just-django recipes."
    git push
alias cp := git-commit-push

# git commit, edit commit message, and push
[group('git')]
git-commit-edit-push:
    git commit -a
    git push
alias ce := git-commit-edit-push

# git log
[group('git')]
git-log:
    git log --oneline
alias log := git-log

# git pull
[group('git')]
git-pull:
    #!/bin/bash
    pushd src/django && git pull && popd
    pushd src/django-mongodb && git pull && popd
    pushd src/pymongo && git pull && popd
alias gp := git-pull

# git remote add
[group('git')]
git-remote-add:
    pushd src/django-mongodb && git remote add upstream git@github.com:mongodb-labs/django-mongodb.git && popd 
alias gra := git-remote-add

# git fetch
[group('git')]
git-fetch:
    pushd src/django-mongodb && git fetch upstream && popd 
    pushd src/django && git fetch upstream && popd 
alias gf := git-fetch

# ---------------------------------------- just ----------------------------------------

# list all available recipes
[group('just')]
just-list:
    @just -l
alias l := just-list

# edit the justfile
[group('just')]
just-edit:
    @just -e
alias e := just-edit

# ---------------------------------------- python ----------------------------------------

[group('python')]
pip-install:
    pip install -U pip
    pip install -e .
    dj install

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
