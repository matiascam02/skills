---
name: sync
description: 'Guarda e integra todo el trabajo de un repo de git y de todos sus espacios de trabajo (worktrees) para que nada quede olvidado en una rama. Hace commit de lo pendiente, lo junta con la rama principal (o abre pull requests), lo sube y pone al día los demás espacios. Úsala cuando escriban /sync, "sync", "junta los worktrees", "guarda y sube todo", "fusiona con main" o al cerrar una sesión de trabajo con varios agentes. Argumentos opcionales: una ruta o nombre de repo, "all" (todos los repos con trabajo pendiente), "merge" (también fusiona los pull requests abiertos), "clean" (también borra los espacios ya fusionados).'
---

# Sync

La versión para quien trabaja con varios agentes a la vez, cada uno en su propio
espacio (worktree), por ejemplo con Orca. Para un solo proyecto basta `guardar`.

La persona no usa git. Haz todo el trabajo y al final cuéntale el resultado en su
idioma. Pregunta solo cuando una decisión cambia el resultado y no la puedes tomar
con seguridad (ver "Cuándo parar").

## Argumentos

- ninguno: el repo de la carpeta actual, con todos sus worktrees.
- `<ruta>` o `<nombre>`: ese repo (busca los nombres en `~/dev/*` y, si usa Orca,
  en `orca repo list`).
- `all`: todos los repos con trabajo pendiente. Junta las raíces de `orca worktree
  list` (si usa Orca) y de los repos de git directamente bajo `~/dev`; procesa solo
  los que tienen archivos modificados o ramas adelantadas.
- `merge`: en modo pull request, también fusiona los PR que esta pasada abrió o
  encontró (ver paso 3).
- `clean`: al final, borra los worktrees ya fusionados (ver paso 6).

## 1. Inventario (solo lectura)

Corre `scripts/inventory.sh <ruta-del-repo>` (está junto a este archivo). Muestra la
rama principal, el modo de integración y, por worktree, la rama, los archivos
modificados y sin seguimiento, cuánto va adelante o atrás y si hay un merge o
rebase a medias.

Modo:
- `direct`: junta las ramas en la principal en local y sube. Para repos personales
  y de notas.
- `pr`: sube la rama y abre un pull request. Se deduce cuando la historia de la
  rama principal está hecha de PR (código compartido, cualquier cosa que se
  despliega).
- Para forzar un modo, agrega una línea `<raíz-del-repo> <direct|pr>` en
  `~/.config/sync/repos.conf` (o en la ruta de `SYNC_REPOS_CONF`). Si la
  deducción parece equivocada para un repo, agrega la línea y dilo.

Lee también el `CLAUDE.md` o `AGENTS.md` del repo: formato de commits, líneas de
atribución, archivos que deben quedar privados y qué herramienta maneja los
worktrees (los de Orca se borran con `orca worktree rm`, nunca con
`git worktree remove`).

## 2. Commit de lo pendiente en cada worktree

En cada worktree con archivos modificados o nuevos (la carpeta principal incluida):

1. Mira el diff y la lista de archivos nuevos antes de agregar. Deja fuera, y
   avisa:
   - secretos: `.env*`, `*.pem`, `*.key`, archivos con tokens o contraseñas, lo
     que una regla de ignore o el repo marquen como privado;
   - basura local: `.DS_Store`, `.obsidian/workspace*.json`, cachés del editor,
     `node_modules/`, carpetas de build;
   - binarios de más de 10 MB, salvo que el repo ya guarde archivos así.
2. Agrega el resto por nombre de archivo (no `git add -A` a ciegas) y revisa lo
   agregado en busca de claves (`sk-`, `ghp_`, llaves privadas, `password=`). Si
   aparece una, sácala y avisa.
3. Commit con un mensaje que describa el cambio, en el formato del repo (por
   defecto `tipo: resumen`). Un commit por worktree está bien.

Que un archivo no tenga seguimiento no significa que sobre: nunca borres archivos
para dejar el árbol limpio.

## 3. Integra

**Modo direct**
1. En la carpeta principal: `git fetch` y pon al día la rama principal con el
   remoto (`git merge --ff-only <remoto>/<principal>`, o un merge normal si los dos
   avanzaron).
2. Junta cada rama de worktree que esté adelante: `git merge <rama>`.
3. `git push <remoto> <principal>`.

**Modo pr**
1. Por cada rama con commits que no están en la principal: `git push -u <remoto>
   HEAD` desde su worktree.
2. `gh pr list --head <rama>`; si no hay PR, `gh pr create --fill`. Da el link.
3. Fusiona solo con el argumento `merge` o si la persona ya lo pidió en esta
   conversación: exige que los checks pasen (`gh pr checks`) y luego
   `gh pr merge --squash`. Nunca te saltes revisiones obligatorias ni checks
   fallidos.
4. Carpeta principal: si está limpia, `git pull --ff-only`.

**Conflictos**
- Markdown, notas, listas de tareas, documentación: resuélvelos conservando los
  dos lados; si el mismo dato difiere, gana la versión con fecha más nueva.
- Código: resuélvelo solo si el resultado correcto es obvio (agregados
  independientes, listas de imports, lockfiles regenerados con el gestor del
  repo). Si no, `git merge --abort` y explica los archivos y las dos versiones.

## 4. Pon al día los demás worktrees

En cada worktree que no es el principal (ya limpio tras el paso 2):
`git merge <principal>` (modo direct) o `git merge <remoto>/<principal>` tras un
fetch (modo pr, solo en ramas cuyo PR se fusionó o sin commits propios). Mismas
reglas de conflictos. Salta, y avisa, un worktree con un merge o rebase a medias.

## 5. Verifica

Vuelve a correr el inventario. Lo esperado: nada modificado salvo lo que dejaste
fuera a propósito, la rama principal igual al remoto y cada worktree igual o
adelante de la principal.

## 6. Limpia (solo con `clean`)

Borra un worktree solo si se cumple todo: su rama está fusionada en la principal
(o su PR se fusionó), no tiene archivos sin guardar más allá de basura local, no
hay un merge a medias y ningún agente trabaja ahí (`orca worktree ps` si usa
Orca). Usa la herramienta dueña (`orca worktree rm --worktree path:<ruta>` o
`git worktree remove`). Nunca borres ramas ni la carpeta principal. Sin `clean`,
lista los worktrees fusionados como candidatos.

## Cuándo parar

Para y pregunta (después de abortar cualquier merge a medias) cuando:
- un conflicto de código no tiene una solución obvia;
- un secreto ya está en el historial que se iba a subir;
- GitHub rechaza la subida por algo que no sea ir atrasado (rama protegida,
  permisos);
- los checks de un PR fallan o hace falta una revisión y la persona pidió
  fusionar;
- un worktree está en HEAD separado o en un merge o rebase desconocido.

Nunca: forzar una subida, `reset --hard`, rebase de ramas compartidas, borrar
ramas, ni reescribir commits que ya se subieron, ni hacer commits en un repo que
no es el pedido.

## Al final

Corto, en el idioma de la persona y sin jerga de git más allá de lo que necesita
para actuar. Por repo: commits hechos (hash y una línea), qué se juntó o qué PR se
abrieron o fusionaron (links), si la subida funcionó, qué worktrees se pusieron al
día, qué quedó fuera y por qué, y lo que necesita su decisión.
