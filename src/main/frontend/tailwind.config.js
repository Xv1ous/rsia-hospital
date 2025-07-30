/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "../resources/templates/**/*.html", // Spring Boot Thymeleaf templates
    "../resources/templates/**/*.xml", // Thymeleaf XML files
    "../resources/static/js/**/*.js", // Static JS files
    "./main.css", // Main CSS file
    "!./node_modules/**", // Exclude node_modules
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          DEFAULT: "#E6521F",
          light: "#FF8000",
          dark: "#B33A15",
        },
        secondary: {
          DEFAULT: "#17695b",
          light: "#1a8a78",
          dark: "#0f4a3f",
        },
      },
      animation: {
        "fade-in": "fadeIn 0.3s ease-out",
        "scale-in": "scaleIn 0.3s ease-out",
        "bounce-slow": "bounce 2s infinite",
      },
      keyframes: {
        fadeIn: {
          "0%": { opacity: "0" },
          "100%": { opacity: "1" },
        },
        scaleIn: {
          "0%": { opacity: "0", transform: "scale(0.9) translateY(-20px)" },
          "100%": { opacity: "1", transform: "scale(1) translateY(0)" },
        },
      },
    },
  },
  plugins: [require("daisyui"), require("flowbite/plugin")],
  // Production optimizations
  future: {
    hoverOnlyWhenSupported: true,
  },
};
