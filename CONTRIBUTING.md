# Contribuire a filiere-agroalimentari

## Come contribuire

1. Crea un branch (`feat/...` o `fix/...`)
2. Fai le modifiche
3. Apri una PR — la CI valida config e test

## Struttura

```
datasets/<slug>/    dataset.yml + sql/ + notes.md + README.md
docs/               pipeline, metodologia, dataset registry
registry/           registry.json (generato)
tests/              smoke test del repo
out/                output pipeline (gitignored)
```

## Aggiungere o modificare un dataset

1. Crea/modifica `datasets/<slug>/dataset.yml` e `sql/`.
2. Aggiorna `docs/dataset-registry.md` se cambiano mart o colonne.
3. Esegui `make check`, `make run-all`, `make test`.
4. Apri una PR con il template del repo.

## Standard

- [Repo](https://github.com/dataciviclab/lab-ops/blob/main/standards/repo.md)
- [Pipeline](https://github.com/dataciviclab/lab-ops/blob/main/standards/pipeline.md)
- [Test](https://github.com/dataciviclab/lab-ops/blob/main/standards/tests.md)
- [Pyproject](https://github.com/dataciviclab/lab-ops/blob/main/standards/pyproject.md)

## Regole

- non committare output di run (`out/`, `raw.csv`, `data/rica/`);
- non fondere basi o definizioni diverse;
- non leggere differenze tra indici come margini;
- documenta le scelte in `docs/metodologia.md`.
