import click
import requests
import camelot
import pandas as pd
import importlib.metadata
from bs4 import BeautifulSoup
from pathlib import Path

__version__ = importlib.metadata.version(__package__)


@click.command()
@click.option('--base', default='https://www.mwra.com')
@click.option('--name/--no-name', default=False)
def get_data(base, name):
    """ Gets Biobot data from a PDF file """
    href = get_href(base)
    if name:
        click.echo(href)
        return 0

    pdf = Path('pdf/' + Path(href).name)

    if not pdf.exists():
        pdf.parent.mkdir(exist_ok=True)
        r = requests.get(f'{base}/{href}')
        with open(pdf, 'wb') as f:
            f.write(r.content)

    tables = camelot.read_pdf(f'{pdf}', pages='1-end')

    # As of 2024-07-19, camelot extracts the data on the last page
    # as a newline-separated string instead of separate columns;
    # the conditional in this loop handles this for now.
    dataframes = []
    for t in tables:
        if t.shape[1] != 2:
            dataframes.append(t.df)
        else:
            dataframes.append(
                pd.concat(
                    [
                        t.df[0],
                        t.df[1].str.split('\n', expand=True)
                    ],
                    axis='columns',
                    ignore_index=True
                )
            )
    result = pd.concat([d.iloc[:, : 9] for d in dataframes])

    with open('mwra-biobot.csv', 'w') as f:
        f.write(f'# extracted from {href} by {__package__} {__version__}\n')
        result.to_csv(f, header=False, index=False)


def get_href(base):
    """ Gets PDF filename """
    r = requests.get(f'{base}/biobot/biobotdata.htm')
    soup = BeautifulSoup(r.text, 'html.parser')

    return soup.find_all(
        'a', href=lambda x: x and x.startswith('/media/file/') and '-data' in x
    )[0].get('href')
