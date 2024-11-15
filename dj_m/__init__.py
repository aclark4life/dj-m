import click
import os
import shutil
import subprocess
import sys


PROJECT_FILES = [
    "backend",
    "manage.py",
    "mongo_migrations",
    ".eslintrc",
    ".stylelintrc.json",
    "frontend/",
    "home/",
    "package.json",
    "postcss.config.js",
]

PROJECT_TEMPLATES = {
    "dj-m": "startproject_template",
    "mongodb": "https://github.com/mongodb-labs/django-mongodb-project/archive/refs/heads/5.0.x.zip",
}


@click.group()
def cli():
    pass


@click.command()
def runserver():
    subprocess.Popen(["npm", "run", "watch"])
    subprocess.run([sys.executable, "manage.py", "runserver", "0.0.0.0:8000"])


@click.command()
@click.option("-t", "--template", default=PROJECT_TEMPLATES["dj-m"])
@click.option("-d", "--delete", is_flag=True, help="Delete existing project files")
def startproject(template, delete):
    if delete:
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
        exit()
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
            template,
        ]
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

    # Execute the command
    subprocess.run(command, stdin=None, stdout=None, stderr=None)


cli.add_command(runserver)
cli.add_command(startproject)
cli.add_command(test)
