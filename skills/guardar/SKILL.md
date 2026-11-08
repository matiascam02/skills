---
name: guardar
description: Guarda y sube a GitHub el trabajo del proyecto actual sin que la persona toque git. Revisa los cambios, deja fuera contraseñas y claves, hace el commit con un mensaje claro, lo sube y avisa si el despliegue terminó bien. Úsala cuando escriban /guardar, "guarda todo", "súbelo", "sube los cambios" o al cerrar una sesión de trabajo.
---

# Guardar

La persona no usa git. Haz todo el trabajo y al final cuéntale en dos líneas, en su
idioma, qué se guardó y dónde quedó. Pregunta solo cuando una decisión cambia el
resultado (ver "Cuándo parar").

## 1. Mira antes de guardar

1. `git status` y `git diff --stat` en la carpeta del proyecto. Si no es un repo de
   git, dilo y ofrece crearlo; no lo crees sin un sí.
2. Deja fuera, y menciónalo al final:
   - secretos: `.env*`, `*.pem`, `*.key`, archivos con tokens o contraseñas;
   - basura local: `.DS_Store`, `node_modules/`, carpetas de build, cachés del editor;
   - archivos de más de 10 MB, salvo que el proyecto ya guarde archivos así.
3. Agrega lo demás por nombre de archivo, nunca con un `git add -A` a ciegas.
4. Revisa lo agregado en busca de claves (`sk-`, `ghp_`, `password=`, llaves
   privadas). Si aparece una, sácala del commit y avisa.

## 2. Guarda

- Un commit con un mensaje que diga qué cambió, en el formato del proyecto (por
  defecto `tipo: resumen`, por ejemplo `feat: formulario de contacto en la home`).
- Si el proyecto tiene un CLAUDE.md o AGENTS.md, sigue sus reglas de commits.

## 3. Sube

- En la rama principal (`main` o `master`): trae primero lo nuevo del remoto
  (`git pull --ff-only`) y después `git push`.
- En otra rama: súbela (`git push -u origin HEAD`) y, si el repo trabaja con pull
  requests, abre uno con `gh pr create --fill`. No lo fusiones sin que la persona
  lo pida.

## 4. Revisa el despliegue

Si el proyecto se publica solo al subir (Vercel, Railway, Netlify), espera el
resultado con `gh api repos/{dueño}/{repo}/commits/HEAD/status` o
`gh pr checks`, y di si quedó en línea o si falló, con el link.

## Cuándo parar

Para y pregunta, sin dejar nada a medias, cuando:
- hay un conflicto con lo que está en GitHub y la solución no es obvia;
- un secreto ya está en el historial que se iba a subir;
- GitHub rechaza la subida por permisos o por una rama protegida.

Nunca: forzar una subida (`--force`), borrar ramas o archivos, `reset --hard`, ni
reescribir commits que ya se subieron.

## Al final

Dos líneas: qué se guardó (el mensaje del commit), dónde quedó (rama o link del
pull request) y si el despliegue terminó bien. Más lo que quedó fuera y por qué,
si hubo algo.
