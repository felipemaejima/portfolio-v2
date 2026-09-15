/** `Meu Projeto Ágil!` → `meu-projeto-agil`. Vazio vira `item`. */
export function slugify(text: string): string {
  const slug = text
    .normalize('NFD')
    .replace(/[̀-ͯ]/g, '')
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '');
  return slug || 'item';
}

/** Primeiro slug livre: `base`, `base-2`, `base-3`… */
export async function uniqueSlug(
  base: string,
  exists: (slug: string) => Promise<boolean>,
): Promise<string> {
  let candidate = base;
  for (let n = 2; await exists(candidate); n++) candidate = `${base}-${n}`;
  return candidate;
}
