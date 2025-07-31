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
  // Check if modal elements exist
  const modalBg = document.getElementById("janji-modal-bg");
  const openBtn = document.getElementById("open-janji-modal");
  const openBtnMobile = document.getElementById("open-janji-modal-mobile");

  console.log("[DEBUG] Modal elements check:", {
    modalBg: !!modalBg,
    openBtn: !!openBtn,
    openBtnMobile: !!openBtnMobile,
  });

  // Event delegation untuk modal pilihan pasien
  document.addEventListener("click", function (e) {
    console.log("[DEBUG] Click event on:", e.target.id || e.target.className);

    // Desktop button
    if (e.target && e.target.id === "open-janji-modal") {
      console.log("[DEBUG] Desktop button clicked");
      var modalBg = document.getElementById("janji-modal-bg");
      if (modalBg) {
        modalBg.classList.remove("hidden");
        console.log("[DEBUG] Modal should be visible now");
      } else {
        console.log("[ERROR] Modal background not found");
      }
    }

    // Mobile button
    if (e.target && e.target.id === "open-janji-modal-mobile") {
      console.log("[DEBUG] Mobile button clicked");
      var modalBg = document.getElementById("janji-modal-bg");
      if (modalBg) {
        modalBg.classList.remove("hidden");
        console.log("[DEBUG] Modal should be visible now");
        // Sembunyikan menu mobile jika terbuka
        var menu = document.getElementById("navbar-default");
        if (menu) menu.classList.add("hidden");
      } else {
        console.log("[ERROR] Modal background not found");
      }
    }

    // Close modal button
    if (e.target && e.target.id === "close-janji-modal") {
      console.log("[DEBUG] Close button clicked");
      var modalBg = document.getElementById("janji-modal-bg");
      if (modalBg) {
        modalBg.classList.add("hidden");
        console.log("[DEBUG] Modal should be hidden now");
      } else {
        console.log("[ERROR] Modal background not found");
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

  // Test modal functionality after page load
  setTimeout(function () {
    console.log("[DEBUG] Testing modal elements after 2 seconds:");
    const modalBg = document.getElementById("janji-modal-bg");
    const openBtn = document.getElementById("open-janji-modal");
    const openBtnMobile = document.getElementById("open-janji-modal-mobile");

    console.log("[DEBUG] Modal elements after delay:", {
      modalBg: !!modalBg,
      openBtn: !!openBtn,
      openBtnMobile: !!openBtnMobile,
    });

    if (modalBg) {
      console.log("[DEBUG] Modal background found, testing show/hide");
      // Test show modal
      modalBg.classList.remove("hidden");
      console.log("[DEBUG] Modal shown for testing");

      // Hide after 1 second
      setTimeout(function () {
        modalBg.classList.add("hidden");
        console.log("[DEBUG] Modal hidden after test");
      }, 1000);
    }
  }, 2000);

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
