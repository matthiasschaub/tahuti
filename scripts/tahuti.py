"""Backup and restore Tahuti expenses."""

import os
import json
from pathlib import Path
import click

from .utils import BaseUrlSession
from requests.exceptions import HTTPError


@click.group()
def cli():
    pass


@cli.command("backup")
@click.option("--url", type=str, required=True, help="Base URL of your ship.")
@click.option("--gid", type=str, required=True, help="Existing group ID.")
@click.option(
    "--file",
    type=click.Path(
        exists=False,
        dir_okay=False,
        file_okay=True,
        path_type=Path,
    ),
    required=True,
    help="Output JSON file.",
)
@click.option(
    "--access-code",
    type=str,
    required=False,
    help="Access code of your ship."
)
def backup(url, gid: str, file: Path, access_code: None | str):
    """Backup expenses of a group."""
    if access_code is None:
        try:
            access_code = os.environ.get("TAHUTI_ACCESS_CODE")
        except KeyError:
            click.echo(
                "Please provide the access code to your ship as option or as an "
                "environment variable (`TAHUTI_ACCESS_CODE`)"
            )
            return
    session = auth(url, access_code)
    endpoint = f"/apps/tahuti/api/groups/{gid}/expenses"
    # PUT /expenses
    click.echo("Backup exenses")
    response = session.get(endpoint)
    response.raise_for_status()
    data = response.json()
    with open(file, "w") as f:
        json.dump(data, f)
    click.echo("Done")


@cli.command("restore")
@click.option("--url", type=str, required=True, help="Base URL of your ship.")
@click.option("--gid", type=str, required=True, help="New group ID.")
@click.option(
    "--file",
    type=click.Path(
        exists=True,
        dir_okay=False,
        file_okay=True,
        path_type=Path,
    ),
    required=True,
    help="Input JSON file.",
)
@click.option("--access-code", type=str, required=False, help="Access code of your ship.")
def restore(url, gid: str, file: Path, access_code: None | str):
    """Restore expenses of a group."""
    if access_code is None:
        try:
            access_code = os.environ.get("TAHUTI_ACCESS_CODE")
        except KeyError:
            click.echo(
                "Please provide the access code to your ship as option or as an "
                "environment variable (`TAHUTI_ACCESS_CODE`)"
            )
            return
    session = auth(url, access_code)
    endpoint = f"/apps/tahuti/api/groups/{gid}/expenses"
    with open(file, "r") as f:
        data = json.load(f)
    # PUT /expenses
    with click.progressbar(
        data,
        label="Restore expenses",
    ) as bar:
        for expense in bar:
            expense["gid"] = gid
            expense["amount"] = str(expense["amount"])
            response = session.put(endpoint, json=expense)
            response.raise_for_status()
    click.echo("Done")


def auth(url, password):
    click.echo("Authenticate")
    data = {"password": password}
    with BaseUrlSession(url) as session:
        response = session.post("/~/login", data=data)  # perform the login
        try:
            response.raise_for_status()
        except HTTPError:
            click.echo("Authetication failed")
            # TODO: ABORT
        return session


if __name__ == "__main__":
    cli()
