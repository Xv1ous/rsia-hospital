// Main JavaScript - Common functionality
document.addEventListener("DOMContentLoaded", function () {
  console.log("[DEBUG] Main.js loaded");

  // --- NAVBAR FUNCTIONALITY ---
  function toggleMobileMenu() {
    var menu = document.getElementById("navbar-default");
    if (menu) menu.classList.toggle("hidden");
  }

  // Make function globally available
  window.toggleMobileMenu = toggleMobileMenu;

  // --- MODAL FUNCTIONALITY ---
  // Event delegation untuk modal pilihan pasien
  document.addEventListener("click", function (e) {
    // Desktop button
    if (e.target && e.target.id === "open-janji-modal") {
      var modalBg = document.getElementById("janji-modal-bg");
      if (modalBg) {
        modalBg.classList.remove("hidden");
      }
    }

    // Mobile button
    if (e.target && e.target.id === "open-janji-modal-mobile") {
      var modalBg = document.getElementById("janji-modal-bg");
      if (modalBg) {
        modalBg.classList.remove("hidden");
        // Sembunyikan menu mobile jika terbuka
        var menu = document.getElementById("navbar-default");
        if (menu) menu.classList.add("hidden");
      }
    }

    // Close modal button
    if (e.target && e.target.id === "close-janji-modal") {
      var modalBg = document.getElementById("janji-modal-bg");
      if (modalBg) {
        modalBg.classList.add("hidden");
      }
    }

    // Pasien lama button
    if (e.target && e.target.id === "pasien-lama-btn") {
      alert("Fitur untuk pasien lama belum tersedia.");
    }

    // Close modal when clicking outside
    var modalBg = document.getElementById("janji-modal-bg");
    if (modalBg && e.target === modalBg) {
      modalBg.classList.add("hidden");
    }
  });

  // Close modal with Escape key
  document.addEventListener("keydown", function (e) {
    if (e.key === "Escape") {
      var modalBg = document.getElementById("janji-modal-bg");
      if (modalBg && !modalBg.classList.contains("hidden")) {
        modalBg.classList.add("hidden");
      }
    }
  });

  // --- SERVICES SEARCH FUNCTIONALITY ---
  const searchInput = document.getElementById("service-search");
  if (searchInput) {
    const cards = document.querySelectorAll("#services-grid > div");
    searchInput.addEventListener("input", function () {
      const query = this.value.toLowerCase();
      cards.forEach((card) => {
        const text = card.textContent.toLowerCase();
        card.style.display = text.includes(query) ? "" : "none";
      });
    });
  }

  // --- GALLERY LIGHTBOX FUNCTIONALITY ---
  const images = document.querySelectorAll(".gallery-img");
  if (images.length > 0) {
    console.log("Found gallery images:", images.length);
    const modal = document.getElementById("lightbox-modal");
    const modalImg = document.getElementById("lightbox-img");
    const closeBtn = document.getElementById("lightbox-close");

    images.forEach((img) => {
      img.addEventListener("click", function () {
        console.log("Image clicked:", img.src);
        modalImg.src = img.getAttribute("data-img") || img.src;
        modal.classList.remove("hidden");
      });
    });

    if (closeBtn) {
      closeBtn.addEventListener("click", function () {
        modal.classList.add("hidden");
        modalImg.src = "";
      });
    }

    if (modal) {
      modal.addEventListener("click", function (e) {
        if (e.target === modal) {
          modal.classList.add("hidden");
          modalImg.src = "";
        }
      });
    }
  }
});
