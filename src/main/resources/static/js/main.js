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
      console.log("[DEBUG] Desktop button clicked");
      var modalBg = document.getElementById("janji-modal-bg");
      if (modalBg) {
        modalBg.classList.remove("hidden");
      }
    }

    // Mobile button
    if (e.target && e.target.id === "open-janji-modal-mobile") {
      console.log("[DEBUG] Mobile button clicked");
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
      console.log("[DEBUG] Close button clicked");
      var modalBg = document.getElementById("janji-modal-bg");
      if (modalBg) {
        modalBg.classList.add("hidden");
      }
    }

    // Pasien lama button
    if (e.target && e.target.id === "pasien-lama-btn") {
      console.log("[DEBUG] Pasien lama button clicked");
      alert("Fitur untuk pasien lama belum tersedia.");
    }

    // Close modal when clicking outside
    var modalBg = document.getElementById("janji-modal-bg");
    if (modalBg && e.target === modalBg) {
      console.log("[DEBUG] Modal background clicked");
      modalBg.classList.add("hidden");
    }
  });

  // Close modal with Escape key
  document.addEventListener("keydown", function (e) {
    if (e.key === "Escape") {
      var modalBg = document.getElementById("janji-modal-bg");
      if (modalBg && !modalBg.classList.contains("hidden")) {
        console.log("[DEBUG] Escape key pressed");
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

  // Debug: check if elements exist
  setTimeout(function () {
    console.log("[DEBUG] Elements check after 1s:", {
      openBtn: !!document.getElementById("open-janji-modal"),
      modalBg: !!document.getElementById("janji-modal-bg"),
      closeBtn: !!document.getElementById("close-janji-modal"),
      pasienLamaBtn: !!document.getElementById("pasien-lama-btn"),
      openBtnMobile: !!document.getElementById("open-janji-modal-mobile"),
      serviceSearch: !!document.getElementById("service-search"),
      galleryImages: document.querySelectorAll(".gallery-img").length,
    });
  }, 1000);
});
