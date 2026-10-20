# Contributing

Guida rapida per contribuire al repo **filiere-agroalimentari**.

Le policy comuni dell'organizzazione non vengono duplicate qui: per quelle, il
posto giusto è [`.github`](https://github.com/dataciviclab/.github). Questo
documento resta pratico e locale.

## Setup minimo

Prerequisiti:

- accesso al repo privato;
- Python 3.12 e il toolkit del Lab nel proprio ambiente;
- lavorare dalla root del progetto.

Il repo contiene configurazione dataset (`datasets/`), SQL, script, test e
documentazione. Il motore della pipeline sta nel repo `toolkit`.

```bash
python -m venv .venv
. .venv/bin/activate
pip install -e ".[dev,pipeline]"
```

In alternativa, nel workspace del Lab si usa l'unica `.venv` alla radice e si
installa il repo in editable.

## Contract test

```bash
python -m pytest tests/
```

I test verificano la struttura del repo e il contratto minimo dei dataset, non
il motore del toolkit.

## Smoke locale

```bash
make check     # preflight dei dataset.yml
make run-all   # RAW → CLEAN → MART per tutti i dataset
```

Il dataset RICA usa `type: script`; il `Makefile` esporta
`TOOLKIT_ALLOW_SCRIPT_SOURCE=1`, quindi non serve passarlo a mano.

Per un singolo dataset:

```bash
toolkit run --config datasets/<slug>/dataset.yml
toolkit inspect -c datasets/<slug>/dataset.yml -y <anno>
```

## Dove scrivere cosa

- **Discussions** della repo: domande, interpretazioni, proposte.
- **Issues** della repo: bug, task e blocchi operativi.
- Non aprire issue grandi di lifecycle: usa poche issue piccole legate a un
  blocco reale o al prossimo passo concreto.

## Regole rapide

- non committare output di run sotto `out/`;
- aggiorna `docs/decisions.md` quando cambi una scelta che cambia il significato
  del dato;
- aggiorna `docs/data_dictionary.md` quando cambia il significato di un campo;
- usa path root-relative e POSIX;
- non introdurre join impliciti tra classificazioni diverse (ECOICOP, NACE, OTE);
- non leggere differenze tra indici come margini.

## Struttura

```
datasets/<slug>/
├── dataset.yml       contratto pipeline
├── sql/
│   ├── clean.sql     RAW → CLEAN
│   └── mart_*.sql    CLEAN → MART (1 file = 1 tabella)
├── notes.md          quirk e decisioni locali
└── README.md         domanda e perimetro

support/<slug>/       anagrafiche condivise (quando servono)
analysis/             query e primi output (non pipeline)
docs/                 fonti, decisioni, dizionario, contratto
tests/                contract test
registry/             artifact registry
```

## Link

- [Discussioni](https://github.com/dataciviclab/dataciviclab/discussions)
- [Toolkit docs](https://github.com/dataciviclab/toolkit/tree/main/docs)
- [Standard Lab](https://github.com/dataciviclab/lab-ops)
- [ADR-001](https://github.com/dataciviclab/.github/blob/main/docs/adr/001-workflow-architecture.md)
