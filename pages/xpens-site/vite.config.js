import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";

// https://vite.dev/config/
export default defineConfig({
  plugins: [vue()],
  base: "/xpens/pages/xpens-site/",
  build: { outDir: "dist" },
});
