---
name: nueva-skill
description: Convierte en una skill algo que la persona acaba de hacer con el agente y va a repetir, con los pasos que funcionaron y lo aprendido en el camino, y la prueba una vez con ella. Úsala cuando escriban /nueva-skill, "conviértelo en skill", "esto lo voy a repetir", "guarda esto como skill" o "haz una skill para esto".
---

# Nueva skill

La persona acaba de hacer algo contigo y lo quiere repetir sin volver a
explicarlo. Tu trabajo es escribir el manual que tú mismo leerías la próxima vez.

## 1. Entiende qué se repite

De la conversación, saca:
- **qué se logra** (el resultado, no los clics);
- **cuándo se usa**: las frases con que la persona lo pediría;
- **los pasos que funcionaron**, en orden, y los que fallaron con su corrección;
- **qué cambia cada vez** (un archivo, una fecha, un cliente) y qué es siempre igual;
- **qué nunca se hace sin permiso**: pagar, enviar, publicar, borrar.

Si falta algo de eso, pregunta en una sola tanda, con opciones concretas.

## 2. Escríbela

- Nombre corto en minúsculas con guiones (`facturas-del-mes`). Confírmalo con la
  persona.
- Carpeta: `~/.claude/skills/<nombre>/SKILL.md` para Claude Code. Si la persona
  también usa Codex u otros agentes, `~/.agents/skills/<nombre>/SKILL.md` (o
  `npx skills init <nombre>` dentro de esa carpeta).
- Encabezado:

  ```markdown
  ---
  name: <nombre>
  description: Qué hace en una frase. Úsala cuando <frases con que la piden>.
  ---
  ```

  La descripción es lo único que el agente lee para decidir si la usa: que diga
  qué hace y cuándo, con las palabras de la persona.
- Cuerpo: los pasos como instrucciones directas, lo que cambia cada vez como
  "pregunta X si no lo dijo", los errores conocidos con su solución y una sección
  de qué nunca hacer sin permiso. Corto: lo que no ayuda a hacer la tarea, sobra.
- Nada de contraseñas, claves ni datos privados dentro de la skill. Si la tarea
  necesita una clave, la skill dice dónde está guardada, no cuál es.
- Si hay un paso mecánico que se repite igual (renombrar archivos, armar un
  reporte), puede ir como script junto al SKILL.md.

## 3. Pruébala

Abre una sesión nueva (o pide a la persona que lo haga), pide la tarea con sus
palabras y comprueba que el agente encuentra y sigue la skill. Corrige lo que se
trabe y dile a la persona qué cambiaste.

## Al final

Dile el nombre, cómo llamarla (`/<nombre>`) y dónde quedó guardada. Recuérdale
que la puede mejorar diciendo "actualiza la skill <nombre>" cuando algo cambie.
