import click
import os
import shutil
import subprocess
import sys


PROJECT_FILES = ["backend", "manage.py", "mongo_migrations"]

DEV_DEPENDENCIES = [
    "-e git+https://github.com/aclark4life/django@mongodb-5.0.x#egg=django",
    "-e git+https://github.com/aclark4life/mongo-python-driver@PYTHON-4575#egg=pymongo",
    "-e git+https://github.com/aclark4life/django-mongodb@INTPYTHON-348#egg=django-mongodb",
]


@click.group()
def cli():
    pass


@click.command()
def clean():
    for item in PROJECT_FILES:
        try:
            if os.path.isfile(item):
                os.remove(item)  # Remove file
                print(f"Removed file: {item}")
            elif os.path.isdir(item):
                shutil.rmtree(item)  # Remove directory
                print(f"Removed directory: {item}")
            else:
                print(f"Skipping: {item} (not a file or directory)")
        except Exception as e:
            print(f"Error removing {item}: {e}")


@click.command()
def install():
    subprocess.run([sys.executable, "-m", "pip", "install", "-U", "pip"])
    with open("requirements.txt", "w") as f:
        for dependency in DEV_DEPENDENCIES:
            f.write(f"{dependency}\n")
    subprocess.run(
        [sys.executable, "-m", "pip", "install", "-r", "requirements.txt"],
        env={"PIP_SRC": "src"},
    )


@click.command()
def runserver():
    subprocess.run([sys.executable, "manage.py", "runserver", "0.0.0.0:8000"])


@click.command()
def startproject():
    try:
        from django.core import management
    except ModuleNotFoundError:
        exit("Django is not installed. Run `pip install django` to install Django.")
    management.execute_from_command_line(
        [
            "django-admin",
            "startproject",
            "backend",
            ".",
            "--template",
            "https://github.com/mongodb-labs/django-mongodb-project/archive/refs/heads/5.0.x.zip",
        ]
    )


cli.add_command(clean)
cli.add_command(install)
cli.add_command(runserver)
cli.add_command(startproject)
