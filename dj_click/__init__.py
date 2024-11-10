import click
import shutil
import subprocess
import sys
from django.core import management


@click.group()
def cli():
    pass

@click.command()
def clean():
    shutil.rmtree('backend')

@click.command()
def install():
    subprocess.check_call([sys.executable, "-m", "pip", "install", "-U", "pip"])
    subprocess.check_call([sys.executable, "-m", "pip", "install", "Django"])

@click.command()
def project():
    management.execute_from_command_line(['django-admin', 'startproject', 'backend'])

cli.add_command(clean)
cli.add_command(install)
cli.add_command(project)
