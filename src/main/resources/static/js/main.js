// Main JavaScript - Common functionality
document.addEventListener("DOMContentLoaded", function () {
  console.log("[MAIN] DOM Content Loaded - Main script initializing...");

  // Check if modal elements exist
  const modalBg = document.getElementById("janji-modal-bg");
  const openBtn = document.getElementById("open-janji-modal");
  const openBtnMobile = document.getElementById("open-janji-modal-mobile");

  console.log("[MAIN] Modal elements check:", {
    modalBg: !!modalBg,
    openBtn: !!openBtn,
    openBtnMobile: !!openBtnMobile,
  });

  // Additional debug for janji modal
  if (modalBg) {
    console.log("[MAIN] Modal background element:", modalBg);
    console.log(
      "[MAIN] Modal hidden class:",
      modalBg.classList.contains("hidden")
    );
  }

  if (openBtn) {
    console.log("[MAIN] Desktop button element:", openBtn);
    console.log("[MAIN] Desktop button text:", openBtn.textContent);
  }

  if (openBtnMobile) {
    console.log("[MAIN] Mobile button element:", openBtnMobile);
    console.log("[MAIN] Mobile button text:", openBtnMobile.textContent);
  }

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
    console.log("[MAIN] Global click event detected");
    console.log("[MAIN] Click target:", e.target);
    console.log("[MAIN] Target ID:", e.target.id);
    console.log("[MAIN] Target class:", e.target.className);

    // Skip if event was already handled by other scripts
    if (e.defaultPrevented) {
      console.log("[MAIN] Event already handled, skipping...");
      return;
    }

    // Skip if event is from schedule cards (handled by clean.js)
    if (
      e.target.closest("#doctor-schedule-cards-mobile") ||
      e.target.closest(".popover-btn-mobile")
    ) {
      console.log("[MAIN] Event from schedule cards, skipping...");
      return;
    }

    // Desktop button - check button itself or any child element
    if (
      e.target &&
      (e.target.id === "open-janji-modal" ||
        e.target.closest("#open-janji-modal"))
    ) {
      console.log("[MAIN] Opening janji modal (desktop)...");
      var modalBg = document.getElementById("janji-modal-bg");
      console.log("[MAIN] Modal element found:", !!modalBg);
      if (modalBg) {
        modalBg.classList.remove("hidden");
        document.body.classList.add("modal-open");
        console.log("[MAIN] Modal opened successfully");
      }
    }

    // Mobile button - check button itself or any child element
    if (
      e.target &&
      (e.target.id === "open-janji-modal-mobile" ||
        e.target.closest("#open-janji-modal-mobile"))
    ) {
      console.log("[MAIN] Opening janji modal (mobile)...");
      var modalBg = document.getElementById("janji-modal-bg");
      console.log("[MAIN] Modal element found:", !!modalBg);
      if (modalBg) {
        modalBg.classList.remove("hidden");
        document.body.classList.add("modal-open");
        console.log("[MAIN] Modal opened successfully");
        // Sembunyikan menu mobile jika terbuka
        var menu = document.getElementById("navbar-default");
        if (menu) menu.classList.add("hidden");
      }
    }

    // Close modal button - check button itself or any child element
    if (
      e.target &&
      (e.target.id === "close-janji-modal" ||
        e.target.closest("#close-janji-modal"))
    ) {
      console.log("[MAIN] Closing janji modal...");
      var modalBg = document.getElementById("janji-modal-bg");
      console.log("[MAIN] Modal element found:", !!modalBg);
      if (modalBg) {
        modalBg.classList.add("hidden");
        document.body.classList.remove("modal-open");
        console.log("[MAIN] Modal closed successfully");
      }
    }

    // Close modal when clicking outside
    var modalBg = document.getElementById("janji-modal-bg");
    if (modalBg && e.target === modalBg) {
      console.log("[MAIN] Closing janji modal (outside click)...");
      modalBg.classList.add("hidden");
      document.body.classList.remove("modal-open");
      console.log("[MAIN] Modal closed successfully (outside click)");
    }
  });

  // Close modal with Escape key
  document.addEventListener("keydown", function (e) {
    if (e.key === "Escape") {
      var modalBg = document.getElementById("janji-modal-bg");
      if (modalBg && !modalBg.classList.contains("hidden")) {
        modalBg.classList.add("hidden");
        document.body.classList.remove("modal-open");
      }
    }
  });

  // --- LOADING INDICATOR ---
  const loadingIndicator = document.getElementById("loading-indicator");
  if (loadingIndicator) {
    // Hide loading indicator after page load
    window.addEventListener("load", function () {
      loadingIndicator.style.display = "none";
    });

    // Hide after 3 seconds as fallback
    setTimeout(function () {
      if (loadingIndicator) {
        loadingIndicator.style.display = "none";
      }
    }, 3000);
  }

  // --- BACK TO TOP BUTTON ---
  const backToTopBtn = document.getElementById("back-to-top");
  if (backToTopBtn) {
    // Show/hide button based on scroll position
    window.addEventListener("scroll", function () {
      if (window.pageYOffset > 300) {
        backToTopBtn.classList.remove("hidden");
      } else {
        backToTopBtn.classList.add("hidden");
      }
    });

    // Smooth scroll to top
    backToTopBtn.addEventListener("click", function (e) {
      e.preventDefault();
      window.scrollTo({
        top: 0,
        behavior: "smooth",
      });
    });
  }

  // --- LAZY LOADING ---
  const observerOptions = {
    root: null,
    rootMargin: "50px",
    threshold: 0.1,
  };

  const observer = new IntersectionObserver(function (entries) {
    entries.forEach(function (entry) {
      if (entry.isIntersecting) {
        entry.target.classList.add("animate-fade-in");
        observer.unobserve(entry.target);
      }
    });
  }, observerOptions);

  // Observe elements for lazy loading
  const lazyElements = document.querySelectorAll(".lazy-load");
  lazyElements.forEach(function (element) {
    observer.observe(element);
  });
});
