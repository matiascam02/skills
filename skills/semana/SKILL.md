---
name: semana
description: Revisión semanal de una bóveda de Obsidian o carpeta de notas que se usa como segundo cerebro. Cierra las tareas que ya están hechas, junta lo repetido en la nota que corresponde, archiva lo viejo sin borrarlo, arregla links rotos y deja una lista corta de lo que sigue. Úsala cuando escriban /semana, "revisión semanal", "ordena mi cerebro" u "ordena la bóveda".
---

# Semana

Una revisión de 10 a 20 minutos que deja la bóveda al día. Trabaja sobre la bóveda
que la persona indique; si no dice cuál, usa la carpeta actual si tiene una carpeta
`.obsidian`, y si no, pregunta.

## 0. Reglas de la bóveda

Lee primero el `CLAUDE.md` o `AGENTS.md` de la bóveda: ahí están dónde va cada cosa
y qué es confidencial. Esas reglas mandan sobre esta skill.

## 1. Qué cambió esta semana

- Si la bóveda está en git: `git log --since="7 days ago" --name-only`, más los
  archivos modificados y nuevos de `git status`.
- Si no: los archivos `.md` modificados en los últimos 7 días.
- No toques `.obsidian/`: es la configuración de la app.

## 2. Tareas

- Marca como hecha (`- [x]`) solo la tarea que tiene prueba en las notas: un
  resultado, una fecha, un link. Si no hay prueba, déjala abierta.
- Separa lo que está bloqueado o esperando a otra persona, con a quién se espera.
- Si la bóveda tiene una nota de pendientes (por ejemplo `QUEUE.md`, `Tareas.md`),
  ese es el lugar de las tareas abiertas; lo cerrado se mueve a su tema o al archivo.

## 3. Orden

- Lo mismo escrito en dos notas: déjalo en la nota dueña del tema y en la otra pon
  un link. No crees notas de resumen nuevas.
- Lo viejo o terminado va a la carpeta de archivo de la bóveda (`archive/`,
  `Archivo/` o la que use). Mover, nunca borrar.
- Arregla los links `[[...]]` que apuntan a notas movidas o renombradas.
- Pregunta antes de mover algo importante, confidencial o que tenga más de una
  dueña posible.

## 4. Lo que sigue

Termina con una lista corta (cinco puntos como máximo) de lo que toca la próxima
semana, con fecha cuando la haya. Si la bóveda tiene una nota de inicio o de
mantenimiento, deja ahí la fecha de esta revisión; si no, no crees archivos nuevos.

## Al final

Cuenta en pocas líneas qué cerraste, qué moviste, qué links arreglaste y la lista
de lo que sigue. Si la bóveda está en git, ofrece guardar los cambios (`/guardar`
si está instalada).
