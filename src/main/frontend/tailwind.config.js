/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "../resources/templates/**/*.html", // Spring Boot Thymeleaf templates
    "./**/*.js", // Any JS files in frontend
    "./node_modules/flowbite/**/*.js", // Flowbite components
  ],
  theme: {
    extend: {},
  },
  plugins: [require("daisyui"), require("flowbite/plugin")],
};
