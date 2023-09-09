import click
import requests
import camelot
import pandas as pd
import importlib.metadata
from bs4 import BeautifulSoup
from pathlib import Path

__version__ = importlib.metadata.version(__package__)


@click.command()
@click.option('--base', default='https://www.mwra.com/biobot')
def get_data(base):
    """ Gets Biobot data from a PDF file """
    r = requests.get(f'{base}/biobotdata.htm')
    soup = BeautifulSoup(r.text, 'html.parser')

    href = soup.find_all(
        'a', href=lambda x: x and '-data.pdf' in x
    )[0].get('href')

    pdf = 'pdf' / Path(href)

    if not pdf.exists():
        r = requests.get(f'{base}/{href}')
        with open(pdf, 'wb') as f:
            f.write(r.content)

    tables = camelot.read_pdf(f'{pdf}', pages='1-end')
    result = pd.concat([t.df.iloc[:, : 9] for t in tables])

    with open('mwra-biobot.csv', 'w') as f:
        f.write(f'# extracted from {href} by {__package__} {__version__}\n')
        result.to_csv(f, header=False, index=False)
