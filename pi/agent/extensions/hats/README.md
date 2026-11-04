# Hats

Switchable session personas for Pi.

## Use

- `/hat` — pick a hat.
- `/hat teacher` — focus on explanations and learning.
- `/hat copilot` — focus on completing the task.
- `/hat off` — remove the hat instructions.

Changes apply to the next agent run without calling the model. The selection is
saved in the session and restored when resuming, reloading, or navigating branches.
New sessions start with `off`.

## Customize

Add or edit `.md` files in `definitions/`, then run `/reload`.
For example, `reviewer.md` adds `/hat reviewer`.

Files contain plain instructions.

## Development

Use Node 24. From the shared extensions directory (`pi/agent/extensions`):

```bash
npm ci
npm run check  # Typecheck and tests for all extensions
```

Pi loads the extension directly; no build step is needed.
