import click
import os
import shutil
import subprocess
import sys


PROJECT_TEMPLATES = {
    "dj-m": "startproject_template",
    "mongodb": os.path.join("src", "django-mongodb-project"),
}


@click.group()
def cli():
    pass


@click.command()
def createsuperuser():
    try:
        user_email = subprocess.check_output(["git", "config", "user.email"], text=True).strip()
        print(f"User email: {user_email}")
    except subprocess.CalledProcessError:
        print("Error: Unable to retrieve the user email from git config.")
    os.chdir("mongo_project")
    os.environ["DJANGO_SUPERUSER_PASSWORD"] = "admin"
    subprocess.run([sys.executable, "manage.py", "createsuperuser", "--noinput", "--username=admin", f"--email={user_email}"])


@click.command()
def runserver():
    mongodb = subprocess.Popen(["mongo-launch", "single"])
    os.chdir("mongo_project")
    subprocess.run(["npm", "install"])
    subprocess.Popen(["npm", "run", "watch"])
    subprocess.run([sys.executable, "manage.py", "runserver", "0.0.0.0:8000"])
    mongodb.terminate()

@click.command()
@click.option("-t", "--template", default="dj-m")
@click.option("-d", "--delete", is_flag=True, help="Delete existing project files")
def startproject(template, delete):
    if delete:
        if os.path.isdir("mongo_project"):
            shutil.rmtree("mongo_project")  # Remove directory
            print(f"Removed directory: mongo_project")
        else:
            print(f"Skipping: mongo_project does not exist")
        exit()
    try:
        from django.core import management
    except ModuleNotFoundError:
        exit("Django is not installed. Run `pip install django` to install Django.")

    cwd = os.getcwd()
    os.makedirs("mongo_project", exist_ok=True)
    os.chdir("mongo_project")
    click.echo(
        subprocess.run(
            [
                "django-admin",
                "startproject",
                "backend",
                ".",
                "--template",
                os.path.join(cwd, PROJECT_TEMPLATES[template]),
            ]
        )
    )


@click.command()
@click.argument("modules", nargs=-1)
@click.option("-k", "--keyword", help="Filter tests by keyword")
@click.option(
    "-l", "--list-tests", default=False, is_flag=True, help="List available tests"
)
def test(modules, keyword, list_tests):
    """
    Run tests for specified modules with an optional keyword filter.
    """
    if list_tests:
        click.echo(subprocess.run(["ls", os.path.join("src", "django", "tests")]))
        click.echo(
            subprocess.run(["ls", os.path.join("src", "django-mongodb", "tests")])
        )
        exit()

    shutil.copyfile(
        "src/django-mongodb/.github/workflows/mongodb_settings.py",
        "src/django/tests/mongodb_settings.py",
    )

    command = ["src/django/tests/runtests.py"]
    command.extend(["--settings", "mongodb_settings"])
    command.extend(["--parallel", "1"])
    command.extend(["--verbosity", "3"])
    command.extend(["--debug-sql"])

    # Add modules to the command
    command.extend(modules)

    # Add keyword filter if provided
    if keyword:
        command.extend(["-k", keyword])

    click.echo(f"Running command: {' '.join(command)}")

    # Start MongoDB
    mongodb = subprocess.Popen(["mongo-launch", "single"])

    # Execute the test command
    subprocess.run(command, stdin=None, stdout=None, stderr=None)

    # Terminate MongoDB
    mongodb.terminate()


cli.add_command(createsuperuser)
cli.add_command(runserver)
cli.add_command(startproject)
cli.add_command(test)
