default:
    echo 'Hello, world!'

# ---------------------------------------- git ----------------------------------------

# git checkout .
[group('git')]
git-checkout:
    pushd src/django && git checkout . && popd
    pushd src/django-mongodb && git checkout . && popd
    pushd src/pymongo && git checkout . && popd

alias gco := git-checkout
