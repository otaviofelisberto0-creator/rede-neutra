# Rede Neutra — página GitHub

Aplicação estática preparada a partir do último HTML enviado. A página **Base** é somente auxiliar do analista; as análises usam o par JSON publicado na **última GitHub Release válida**.

## Publicação inicial

1. Crie ou abra o repositório no GitHub.
2. Envie `index.html`, `.nojekyll` e a pasta `.github` para a branch publicada.
3. Em **Settings → Pages**, publique a branch (normalmente `main`, pasta `/root`).
4. Abra o endereço do GitHub Pages. Em `usuario.github.io/repositorio`, o proprietário e o repositório são identificados automaticamente.

Em domínio próprio, preencha no `<head>` de `index.html`:

```html
<meta name="github-owner" content="PROPRIETARIO">
<meta name="github-repo" content="REPOSITORIO">
```

## Rotina mensal do analista

1. Na página **BASE**, clique em **CARREGAR RSUL**.
2. Quando habilitado em verde, clique em **CONVERTER PARA JSON**.
3. Quando habilitado em verde, clique em **BAIXAR JSON**.
4. Repita para **REGIÃO LESTE**.
5. Quando os dois downloads da mesma competência terminarem, o único botão **GITHUB** da página ficará verde.
6. Clique em **GITHUB**. Ele abre `https://github.com/` em uma nova guia.
7. No repositório, abra **Releases → Draft a new release**.
8. Crie uma release publicada, não rascunho e não pré-release, e anexe exatamente:
   - `RSUL-AA-MM.json`
   - `RLESTE-AA-MM.json`
9. Não adicione esses JSONs ao histórico Git. Eles devem permanecer como assets da Release.
10. Reabra a aplicação ou clique em **RECARREGAR DADOS DO GITHUB**.

A aplicação escolhe, na última release publicada, o par mais recente que tenha a mesma competência nos dois nomes. Se um arquivo estiver ausente, com nome incorreto ou schema inválido, nenhum dos dois é ativado.

## Saída compacta

O navegador lê o arquivo em fluxo e usa um Web Worker. Antes do JSON, aplica os critérios do painel e agrega registros idênticos na coluna `QT`. A saída mantém apenas:

- `DT_AGENDA`
- `NM_REGIONAL`
- `NM_CLUSTER`
- `NM_SUBCLUSTER`
- `UF`
- `CID`
- `QT`

As linhas são armazenadas como matrizes, não como objetos repetitivos, para reduzir tamanho e uso de memória. Depois do download, o Blob, o arquivo selecionado e o Worker são descartados.

## Validação automática

O workflow `.github/workflows/validar-release.yml` verifica, a cada publicação de Release, se existe um par `RSUL-AA-MM.json` + `RLESTE-AA-MM.json` da mesma competência.

## Publicação opcional pela linha de comando

Com o GitHub CLI autenticado, os scripts `publicar-release.ps1` (Windows) e `publicar-release.sh` (Linux/macOS) criam ou atualizam a Release a partir de uma pasta que contenha o par JSON.
