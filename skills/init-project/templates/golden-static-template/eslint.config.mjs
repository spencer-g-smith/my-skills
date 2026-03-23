import js from "@eslint/js";
import astro from "eslint-plugin-astro";
import tseslint from "typescript-eslint";

export default [
  js.configs.recommended,
  ...astro.configs.recommended,
  {
    files: ["**/*.{ts,tsx,mts,cts}"],
    ...tseslint.configs.strictTypeChecked[0],
    languageOptions: {
      parserOptions: {
        projectService: true,
        tsconfigRootDir: import.meta.dirname,
      },
    },
    rules: {
      ...tseslint.configs.strictTypeChecked[0].rules,
      "@typescript-eslint/no-explicit-any": "error",
    },
  },
  {
    files: ["src/env.d.ts", ".astro/**/*.d.ts"],
    rules: {
      "@typescript-eslint/triple-slash-reference": "off",
    },
  },
];
