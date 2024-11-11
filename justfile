# list all available recipes
default: just-list

# ---------------------------------------- django ----------------------------------------

startapp_template := "./startapp_template"
startproject_template := "./startproject_template"

# django-admin
[group('django')]
django-admin:
    python manage.py

alias admin := django-admin
alias a := django-admin

# django-dbshell
[group('django')]
django-dbshell:
    python manage.py dbshell

alias dbshell := django-dbshell
alias dbsh := django-dbshell

# django-dumpdata
[group('django')]
django-dumpdata:
    python manage.py dumpdata | python -m json.tool

alias dump := django-dumpdata

# django-su
[group('django')]
django-su: check-venv
    DJANGO_SUPERUSER_PASSWORD=admin python manage.py createsuperuser --noinput \
        --username=admin --email=`git config user.mail`

alias su := django-su

# django-migrations
[group('django')]
django-migrations: check-venv
    python manage.py makemigrations

alias migrations := django-migrations

# django-migrate
[group('django')]
django-migrate: check-venv
    python manage.py migrate

alias migrate := django-migrate
alias m := django-migrate

# django-serve
[group('django')]
django-serve: check-venv
    npm run watch &
    python manage.py runserver

alias s := django-serve

# django-shell
[group('django')]
django-shell: check-venv
    python manage.py shell

alias shell := django-shell
alias sh := django-shell

# django-startapp
[group('django')]
django-startapp app_label:
    python manage.py startapp {{ app_label }} --template "{{ startapp_template }}"

alias startapp := django-startapp

# django-sqlmigrate
[group('django')]
django-sqlmigrate app_label migration_name:
    python manage.py sqlmigrate {{ app_label }} {{ migration_name }}

alias sqlmigrate := django-sqlmigrate

# django-project
[group('django')]
django-project:
    django-admin startproject backend . --template "{{ startproject_template }}"

# django-admin-subcommand
[group('django')]
django-admin-subcommand subcommand: check-venv
    python manage.py {{ subcommand }}

alias sub := django-admin-subcommand

# ---------------------------------------- django-extensions -------------------------------

# django-urls
[group('django-extensions')]
django-urls: check-venv
    python manage.py show_urls

alias urls := django-urls

# ---------------------------------------- django-utils -------------------------------

# django-clean
[group('django-utils')]
django-clean:
    #!/usr/bin/env python
    import os, shutil
    gitignore_path = ".gitignore"
    if not os.path.exists(gitignore_path):
        print(f"{gitignore_path} file not found!")
        exit(1)

    with open(gitignore_path, "r") as f:
        for line in f:
            # Strip whitespace and ignore empty lines or comments
            path = line.strip()
            if not path or path.startswith("#"):
                continue

            # Remove leading slash if it exists
            path = path.lstrip("/")

            # Skip paths that start with '!'
            if path.startswith("!"):
                print(f"Ignoring path: {path[1:].strip()}")
                continue

            # Skip if the path does not exist
            if not os.path.exists(path):
                print(f"{path} does not exist, skipping.")
                continue

            # Remove file or directory
            try:
                if os.path.isfile(path) or os.path.islink(path):
                    os.remove(path)
                    print(f"Removed file: {path}")
                elif os.path.isdir(path):
                    shutil.rmtree(path)
                    print(f"Removed directory: {path}")
            except Exception as e:
                print(f"Error removing {path}: {e}")

alias clean := django-clean
alias c := django-clean

# django-init
[group('django-utils')]
django-init: check-venv django-install django-project npm-init django-su

alias django := django-init
alias d := django-init

# django-install
[group('django-utils')]
django-install: check-venv pip-install

# open django
[group('django-utils')]
django-open:
    open http://0.0.0.0:8000

alias o := django-open

# ---------------------------------------- dns ----------------------------------------

# test dns
[group('dns')]
dns:
    coredns -conf Corefile

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

# git remote
[group('git')]
git-remote:
    pushd src/django-mongodb && git remote add upstream git@github.com:mongodb-labs/django-mongodb.git && popd 

alias ra := git-remote

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

# ---------------------------------------- npm ----------------------------------------

# npm run build
[group('npm')]
npm-build:
    npm run build

# npm install
[group('npm')]
npm-install:
    npm install

# npm-install and npm-build
[group('npm')]
npm-init: npm-install npm-build

alias n := npm-init
alias pack := npm-init

# ---------------------------------------- python ----------------------------------------

# save requirements to requirements.txt
[group('python')]
pip-freeze:
    pip freeze > requirements.txt

alias freeze := pip-freeze

# install requirements from requirements.txt
[group('python')]
pip-install:
    pip install -U pip
    export PIP_SRC=src && pip install -r requirements.txt

alias install := pip-install
alias i := pip-install

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

# ---------------------------------------- jira ----------------------------------------

[group('jira')]
INTPYTHON-348: check-venv
    CFLAGS="-I/opt/homebrew/Cellar/libmemcached/1.0.18_2/include" \
    LDFLAGS="-L/opt/homebrew/Cellar/libmemcached/1.0.18_2/lib" pip install pylibmc
    pip install -r src/django/tests/requirements/py3.txt
    cp src/django-mongodb/.github/workflows/mongodb_settings.py src/django/tests
    python src/django/tests/runtests.py --settings mongodb_settings --parallel 1 raw_query

[group('jira')]
PYTHON-4575: check-venv
    #!/usr/bin/env python
    import dns.resolver
    from pymongo import MongoClient
    resolver = dns.resolver.Resolver()
    resolver.nameservers = ['127.0.0.1']
    resolver.port = 1053
    dns.resolver.default_resolver = resolver
    client = MongoClient('mongodb+srv://localhost?tls=false')
    db = client.test
    print(db.list_collection_names())
