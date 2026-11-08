# Skills en español

Skills para Claude Code, Codex y otros agentes, escritas en español para gente que
usa la IA en su trabajo y no quiere pelearse con la parte técnica.

Una skill es un manual que tu agente guarda y abre solo cuando lo necesita. La
instalas una vez y desde ahí la llamas escribiendo `/nombre`, o el agente la usa
solo cuando la tarea calza.

## Las skills

| Skill | Qué hace |
|---|---|
| [`guardar`](skills/guardar/SKILL.md) | Guarda y sube a GitHub el trabajo del proyecto sin que toques git. Deja fuera claves y contraseñas y te avisa si la web quedó en línea. |
| [`semana`](skills/semana/SKILL.md) | Revisión semanal de tu bóveda de Obsidian: cierra lo hecho, junta lo repetido, archiva sin borrar y te deja lo que sigue. |
| [`sync`](skills/sync/SKILL.md) | Para quien trabaja con varios agentes a la vez (por ejemplo con [Orca](https://github.com/stablyai/orca)): junta el trabajo de todos los espacios, lo sube y los pone al día. |
| [`nueva-skill`](skills/nueva-skill/SKILL.md) | «Esto lo voy a repetir»: convierte lo que acabas de hacer en una skill tuya y la prueba contigo. |

## Instalar

Necesitas [Node.js](https://nodejs.org). En la Terminal:

```bash
# todas
npx skills add matiascam02/skills -g -y

# o una sola
npx skills add matiascam02/skills@guardar -g -y
```

`-g` las deja disponibles en todos tus proyectos. Después abre una sesión nueva de
tu agente para que las vea. Para actualizarlas: `npx skills update -g -y`.

## Reglas que siguen todas

- Nunca pagan, envían, publican ni borran nada sin tu OK.
- Las contraseñas y claves no se suben ni se escriben en el chat.
- Al terminar te cuentan, corto y en tu idioma, qué hicieron.

## Quién las hace

[Matías Cam](https://matiascam.com) · [@matiasecam](https://x.com/matiasecam) en X.
Son las que uso yo y las que les dejo a las personas que capacito. Si una te sirve,
dale una estrella; si algo no funciona, abre un issue.

Licencia [MIT](LICENSE): úsalas, cámbialas y compártelas.
