# Contribuire a filiere-agroalimentari

Questo repo raccoglie i dataset della **filiera agroalimentare italiana**:
prezzi alla produzione e input, redditi e aiuti delle aziende agricole, prezzi
al consumo. È un repo multi-dataset del DataCivicLab.

## Comandi

```bash
pip install -e ".[dev,pipeline]"
make check        # valida i dataset.yml (preflight)
make run-all      # esegue tutti i dataset (RAW → CLEAN → MART)
python -m pytest tests/
```

Il dataset RICA usa `type: script`; il `Makefile` esporta
`TOOLKIT_ALLOW_SCRIPT_SOURCE=1`.

## Standard

- **Repo**: `infra/lab-ops/standards/repo.md`
- **Pipeline**: `infra/lab-ops/standards/pipeline.md`
- **Test**: `infra/lab-ops/standards/tests.md`
- **Workflow**: `infra/lab-ops/standards/workflows.md`
- **Pyproject**: `infra/lab-ops/standards/pyproject.md`

## Struttura

```
datasets/<slug>/     dataset.yml + sql/ + notes.md + README.md
support/<slug>/      anagrafiche condivise
analysis/            query e output analitici (non pipeline)
docs/                fonti, decisioni, dizionario, contratto
registry/            artifact registry
tests/               contract test
```

## Regole

- non committare output di run (`out/`);
- non fondere serie con basi o definizioni diverse;
- non leggere differenze tra indici come margini;
- documenta le scelte in `docs/decisions.md`;
- aggiorna il dizionario quando cambia il significato di un campo.

## Link

- [Discussioni](https://github.com/dataciviclab/dataciviclab/discussions)
- [Toolkit](https://github.com/dataciviclab/toolkit)
- [Standard Lab](https://github.com/dataciviclab/lab-ops)
- [ADR-001](https://github.com/dataciviclab/.github/blob/main/docs/adr/001-workflow-architecture.md)
