import js from "@eslint/js";
import tseslint from "typescript-eslint";
import reactPlugin from "eslint-plugin-react";
import hooksPlugin from "eslint-plugin-react-hooks";
import routerPlugin from "@tanstack/eslint-plugin-router";

export default tseslint.config(
  {
    ignores: [
      "dist",
      "node_modules",
      ".vinxi",
      ".output",
      ".vercel",
      ".nitro",
      "eslint.config.mjs",
      "vite.config.ts",
      "src/routeTree.gen.ts",
    ],
  },
  js.configs.recommended,
  ...tseslint.configs.strictTypeChecked,
  ...tseslint.configs.stylisticTypeChecked,
  {
    files: ["src/**/*.{ts,tsx}"],
    languageOptions: {
      parserOptions: {
        project: "./tsconfig.json",
        tsconfigRootDir: import.meta.dirname,
      },
    },
    plugins: {
      react: reactPlugin,
      "react-hooks": hooksPlugin,
      "@tanstack/router": routerPlugin,
    },
    rules: {
      ...reactPlugin.configs.recommended.rules,
      ...hooksPlugin.configs.recommended.rules,
      "react/react-in-jsx-scope": "off",
      "@typescript-eslint/restrict-template-expressions": [
        "error",
        { allowNumber: true, allowBoolean: false, allowNullish: false },
      ],
      "@typescript-eslint/no-floating-promises": "off",
      "no-restricted-exports": [
        "error",
        { restrictDefaultExports: { direct: true } },
      ],
    },
    settings: {
      react: {
        version: "detect",
      },
    },
  },
  {
    files: ["src/routes/**/*.tsx"],
    rules: {
      "no-restricted-exports": "off",
    },
  },
);
