// Clean Schedule Script - No modular system, direct implementation
console.log("[CLEAN] Clean schedule script loaded");

// Global variables
let currentPage = 1;
let currentMobilePage = 1;
let isInitialized = false;

// Wait for DOM to be ready
document.addEventListener("DOMContentLoaded", function () {
  console.log("[CLEAN] DOM loaded, initializing clean schedule...");

  // Prevent multiple initializations
  if (isInitialized) {
    console.log("[CLEAN] Already initialized, skipping...");
    return;
  }

  // Initialize after a longer delay to ensure all elements are ready
  setTimeout(() => {
    console.log("[CLEAN] Starting clean initialization...");
    console.log("[CLEAN] Document ready state:", document.readyState);
    console.log("[CLEAN] Window scheduleData:", window.scheduleData);

    // Get elements
    const table = document.getElementById("doctor-schedule-table-desktop");
    const cards = document.getElementById("doctor-schedule-cards-mobile");
    const paginationControls = document.getElementById("pagination-controls");
    const mobilePaginationControls = document.getElementById(
      "pagination-controls-mobile"
    );

    console.log("[CLEAN] Elements found:", {
      table: !!table,
      cards: !!cards,
      paginationControls: !!paginationControls,
      mobilePaginationControls: !!mobilePaginationControls,
    });

    console.log("[CLEAN] Cards element details:", cards);
    if (cards) {
      console.log("[CLEAN] Cards children count:", cards.children.length);
      console.log("[CLEAN] Cards innerHTML length:", cards.innerHTML.length);

      // Check for popover buttons
      const popoverButtons = cards.querySelectorAll(".popover-btn-mobile");
      console.log("[CLEAN] Popover buttons found:", popoverButtons.length);
      console.log("[CLEAN] Popover buttons:", popoverButtons);
    }

    // Initialize pagination based on screen size
    if (table && paginationControls) {
      // Only initialize desktop pagination on large screens
      if (window.innerWidth >= 1024) {
        // lg breakpoint
        initializeDesktopPagination(table, paginationControls);
      }
    }

    if (cards && mobilePaginationControls) {
      // Only initialize mobile pagination on small screens
      if (window.innerWidth < 1024) {
        // below lg breakpoint
        initializeMobilePagination(cards, mobilePaginationControls);
      }
    }

    // Initialize modal (always initialize, regardless of screen size)
    if (cards) {
      console.log("[CLEAN] Initializing mobile modal...");
      initializeMobileModal(cards);
    } else {
      console.log("[CLEAN] Cards element not found, cannot initialize modal");
    }

    // Initialize desktop popover functionality
    if (table) {
      console.log("[CLEAN] Initializing desktop popover...");
      initializeDesktopPopover(table);
    } else {
      console.log(
        "[CLEAN] Table element not found, cannot initialize desktop popover"
      );
    }

    // Initialize filter functionality
    initializeFilters();

    // Apply initial filters to show all data
    setTimeout(() => {
      console.log("[CLEAN] Applying initial filters...");
      applyFilters();
    }, 200);

    console.log("[CLEAN] Clean initialization complete");
    isInitialized = true;
  }, 100);

  // Handle window resize
  window.addEventListener("resize", function () {
    console.log("[CLEAN] Window resized, checking pagination...");

    const table = document.getElementById("doctor-schedule-table-desktop");
    const cards = document.getElementById("doctor-schedule-cards-mobile");
    const paginationControls = document.getElementById("pagination-controls");
    const mobilePaginationControls = document.getElementById(
      "pagination-controls-mobile"
    );

    if (window.innerWidth >= 1024) {
      // Large screen - show desktop pagination, hide mobile
      if (table && paginationControls) {
        paginationControls.style.display = "block";
        initializeDesktopPagination(table, paginationControls);
      }
      if (mobilePaginationControls) {
        mobilePaginationControls.style.display = "none";
      }
    } else {
      // Small screen - show mobile pagination, hide desktop
      if (cards && mobilePaginationControls) {
        mobilePaginationControls.style.display = "block";
        initializeMobilePagination(cards, mobilePaginationControls);
      }
      if (paginationControls) {
        paginationControls.style.display = "none";
      }
    }
  });
});

// Desktop popover initialization
function initializeDesktopPopover(table) {
  console.log("[CLEAN] Initializing desktop popover...");

  // Add click event to table with stopPropagation to prevent conflicts
  table.addEventListener("click", function (e) {
    console.log("[CLEAN] Table clicked, target:", e.target);
    console.log(
      "[CLEAN] Closest popover-btn:",
      e.target.closest(".popover-btn")
    );

    // Stop event propagation immediately to prevent main.js from handling it
    e.stopPropagation();

    if (e.target.closest(".popover-btn")) {
      console.log("[CLEAN] Opening desktop popover...");
      e.preventDefault();

      // Get the button that was clicked
      const button = e.target.closest(".popover-btn");
      const popoverContent = button.nextElementSibling;

      // Close all other popovers first
      const allPopovers = table.querySelectorAll(".popover-content");
      allPopovers.forEach((popover) => {
        if (popover !== popoverContent) {
          popover.classList.add("hidden");
        }
      });

      // Toggle current popover
      if (
        popoverContent &&
        popoverContent.classList.contains("popover-content")
      ) {
        popoverContent.classList.toggle("hidden");
      }
    }
  });

  // Close popovers when clicking outside
  document.addEventListener("click", function (e) {
    if (
      !e.target.closest(".popover-btn") &&
      !e.target.closest(".popover-content")
    ) {
      const allPopovers = table.querySelectorAll(".popover-content");
      allPopovers.forEach((popover) => {
        popover.classList.add("hidden");
      });
    }
  });

  // Close popover with close button
  table.addEventListener("click", function (e) {
    if (e.target.closest(".close-popover")) {
      console.log("[CLEAN] Closing desktop popover...");
      e.preventDefault();
      e.stopPropagation();

      const popoverContent = e.target.closest(".popover-content");
      if (popoverContent) {
        popoverContent.classList.add("hidden");
      }
    }
  });

  // Close popover with Escape key
  document.addEventListener("keydown", function (e) {
    if (e.key === "Escape") {
      const allPopovers = table.querySelectorAll(".popover-content");
      allPopovers.forEach((popover) => {
        popover.classList.add("hidden");
      });
    }
  });
}

// Filter functionality
function initializeFilters() {
  console.log("[CLEAN] Initializing filters...");

  const specializationSelect = document.getElementById("specialization-select");
  const doctorSearch = document.getElementById("doctor-search");
  const resetFiltersBtn = document.getElementById("reset-filters-btn");
  const searchResultsCounter = document.getElementById(
    "search-results-counter"
  );
  const resultsCount = document.getElementById("results-count");

  console.log("[CLEAN] Filter elements found:", {
    specializationSelect: !!specializationSelect,
    doctorSearch: !!doctorSearch,
    resetFiltersBtn: !!resetFiltersBtn,
    searchResultsCounter: !!searchResultsCounter,
    resultsCount: !!resultsCount,
  });

  // Specialization filter
  if (specializationSelect) {
    specializationSelect.addEventListener("change", function () {
      console.log("[CLEAN] Specialization filter changed:", this.value);
      applyFilters();
    });
  }

  // Doctor search
  if (doctorSearch) {
    let searchTimeout;
    doctorSearch.addEventListener("input", function () {
      console.log("[CLEAN] Doctor search input:", this.value);

      // Clear previous timeout
      clearTimeout(searchTimeout);

      // Add loading state
      const searchIcon = document.getElementById("search-icon");
      const searchLoading = document.getElementById("search-loading");
      if (searchIcon && searchLoading) {
        searchIcon.classList.add("hidden");
        searchLoading.classList.remove("hidden");
      }

      // Debounce search
      searchTimeout = setTimeout(() => {
        applyFilters();

        // Remove loading state
        if (searchIcon && searchLoading) {
          searchIcon.classList.remove("hidden");
          searchLoading.classList.add("hidden");
        }
      }, 300);
    });

    // Ctrl+F shortcut
    document.addEventListener("keydown", function (e) {
      if ((e.ctrlKey || e.metaKey) && e.key === "f") {
        e.preventDefault();
        if (doctorSearch) {
          doctorSearch.focus();
          doctorSearch.select();
        }
      }
    });
  }

  // Reset filters
  if (resetFiltersBtn) {
    resetFiltersBtn.addEventListener("click", function () {
      console.log("[CLEAN] Resetting filters...");

      if (specializationSelect) {
        specializationSelect.value = "semua";
      }

      if (doctorSearch) {
        doctorSearch.value = "";
      }

      applyFilters();
    });
  }
}

// Helper function to normalize specialization strings
function normalizeSpecialization(spec) {
  if (!spec) return "";
  return spec.toLowerCase().trim().replace(/\s+/g, "-").replace(/[&]/g, "");
}

// Apply filters function
function applyFilters() {
  console.log("[CLEAN] Applying filters...");

  const specializationSelect = document.getElementById("specialization-select");
  const doctorSearch = document.getElementById("doctor-search");
  const searchResultsCounter = document.getElementById(
    "search-results-counter"
  );
  const resultsCount = document.getElementById("results-count");

  const selectedSpecialization = specializationSelect
    ? specializationSelect.value
    : "semua";
  const searchTerm = doctorSearch
    ? doctorSearch.value.toLowerCase().trim()
    : "";

  console.log("[CLEAN] Filter values:", {
    specialization: selectedSpecialization,
    searchTerm: searchTerm,
  });

  // Filter desktop table
  const table = document.getElementById("doctor-schedule-table-desktop");
  if (table) {
    const rows = table.querySelectorAll("tr.doctor-row");
    let visibleCount = 0;

    console.log("[CLEAN] Total desktop rows found:", rows.length);

    rows.forEach((row, index) => {
      const doctorName = row.getAttribute("data-name") || "";
      const doctorSpecialization = row.getAttribute("data-spec") || "";
      const doctorSpecializationSlug = row.getAttribute("data-slug") || "";

      // Normalize specialization for comparison
      const normalizedDoctorSpec =
        normalizeSpecialization(doctorSpecialization);
      const normalizedSelectedSpec = normalizeSpecialization(
        selectedSpecialization
      );

      console.log(`[CLEAN] Row ${index}:`, {
        name: doctorName,
        spec: doctorSpecialization,
        slug: doctorSpecializationSlug,
        normalizedSpec: normalizedDoctorSpec,
        selectedSpec: selectedSpecialization,
        normalizedSelectedSpec: normalizedSelectedSpec,
        searchTerm: searchTerm,
      });

      const matchesSpecialization =
        selectedSpecialization === "semua" ||
        doctorSpecializationSlug === selectedSpecialization ||
        normalizedDoctorSpec === normalizedSelectedSpec;

      const matchesSearch =
        searchTerm === "" ||
        doctorName.toLowerCase().includes(searchTerm) ||
        doctorSpecialization.toLowerCase().includes(searchTerm);

      console.log(`[CLEAN] Row ${index} matches:`, {
        specialization: matchesSpecialization,
        search: matchesSearch,
      });

      if (matchesSpecialization && matchesSearch) {
        row.style.display = "table-row";
        visibleCount++;
        console.log(`[CLEAN] Row ${index} SHOWN`);
      } else {
        row.style.display = "none";
        console.log(`[CLEAN] Row ${index} HIDDEN`);
      }
    });

    console.log("[CLEAN] Desktop visible rows:", visibleCount);

    // Reset pagination to first page when filtering
    currentPage = 1;
    if (window.innerWidth >= 1024) {
      const paginationControls = document.getElementById("pagination-controls");
      if (paginationControls) {
        // Check if we have any filters active
        const hasActiveFilters =
          selectedSpecialization !== "semua" || searchTerm !== "";

        if (hasActiveFilters) {
          // When filters are active, pagination should work with filtered results
          const visibleRows = table.querySelectorAll(
            "tr.doctor-row[style*='table-row']"
          );
          console.log("[CLEAN] Visible rows after filter:", visibleRows.length);

          if (visibleRows.length > 7) {
            // Need pagination for filtered results
            initializeFilteredDesktopPagination(
              table,
              paginationControls,
              visibleRows
            );
          } else {
            paginationControls.style.display = "none";
            console.log("[CLEAN] No pagination needed for filtered results");
          }
        } else {
          // No filters active, use normal pagination
          initializeDesktopPagination(table, paginationControls);
        }
      }
    }
  }

  // Filter mobile cards
  const cards = document.getElementById("doctor-schedule-cards-mobile");
  if (cards) {
    const cardElements = cards.children;
    let visibleCount = 0;

    console.log("[CLEAN] Total mobile cards found:", cardElements.length);

    Array.from(cardElements).forEach((card, index) => {
      const doctorName = card.getAttribute("data-name") || "";
      const doctorSpecialization = card.getAttribute("data-spec") || "";
      const doctorSpecializationSlug = card.getAttribute("data-slug") || "";

      // Normalize specialization for comparison
      const normalizedDoctorSpec =
        normalizeSpecialization(doctorSpecialization);
      const normalizedSelectedSpec = normalizeSpecialization(
        selectedSpecialization
      );

      console.log(`[CLEAN] Card ${index}:`, {
        name: doctorName,
        spec: doctorSpecialization,
        slug: doctorSpecializationSlug,
        normalizedSpec: normalizedDoctorSpec,
        selectedSpec: selectedSpecialization,
        normalizedSelectedSpec: normalizedSelectedSpec,
        searchTerm: searchTerm,
      });

      const matchesSpecialization =
        selectedSpecialization === "semua" ||
        doctorSpecializationSlug === selectedSpecialization ||
        normalizedDoctorSpec === normalizedSelectedSpec;

      const matchesSearch =
        searchTerm === "" ||
        doctorName.toLowerCase().includes(searchTerm) ||
        doctorSpecialization.toLowerCase().includes(searchTerm);

      console.log(`[CLEAN] Card ${index} matches:`, {
        specialization: matchesSpecialization,
        search: matchesSearch,
      });

      if (matchesSpecialization && matchesSearch) {
        card.style.display = "block";
        visibleCount++;
        console.log(`[CLEAN] Card ${index} SHOWN`);
      } else {
        card.style.display = "none";
        console.log(`[CLEAN] Card ${index} HIDDEN`);
      }
    });

    console.log("[CLEAN] Mobile visible cards:", visibleCount);

    // Reset pagination to first page when filtering
    currentMobilePage = 1;
    if (window.innerWidth < 1024) {
      const mobilePaginationControls = document.getElementById(
        "pagination-controls-mobile"
      );
      if (mobilePaginationControls) {
        // Only update pagination if there are visible cards
        const visibleCards = Array.from(cardElements).filter(
          (card) => card.style.display !== "none"
        );
        console.log("[CLEAN] Visible cards after filter:", visibleCards.length);
        if (visibleCards.length > 0) {
          initializeMobilePagination(cards, mobilePaginationControls);
        } else {
          mobilePaginationControls.style.display = "none";
          console.log("[CLEAN] No visible cards, hiding pagination");
        }
      }
    }
  }

  // Update search results counter
  if (searchResultsCounter && resultsCount) {
    const totalVisible =
      (table
        ? table.querySelectorAll("tr.doctor-row[style*='table-row']").length
        : 0) +
      (cards
        ? Array.from(cards.children).filter(
            (card) => card.style.display !== "none"
          ).length
        : 0);

    if (searchTerm !== "" || selectedSpecialization !== "semua") {
      resultsCount.textContent = totalVisible;
      searchResultsCounter.classList.remove("hidden");
    } else {
      searchResultsCounter.classList.add("hidden");
    }
  }

  console.log("[CLEAN] Filters applied successfully");
}

// Desktop pagination initialization
function initializeDesktopPagination(table, paginationControls) {
  console.log("[CLEAN] Initializing desktop pagination...");

  // Get all rows for pagination (not just visible ones)
  const allRows = table.querySelectorAll("tr.doctor-row");
  const visibleRows = Array.from(allRows).filter(
    (row) => row.style.display !== "none"
  );

  const rowsPerPage = 7;
  const totalPages = Math.ceil(allRows.length / rowsPerPage);

  console.log("[CLEAN] Desktop pagination:", {
    totalRows: allRows.length,
    visibleRows: visibleRows.length,
    rowsPerPage: rowsPerPage,
    totalPages: totalPages,
  });

  console.log("[CLEAN] Pagination calculation:", {
    visibleRows: visibleRows.length,
    rowsPerPage: rowsPerPage,
    totalPages: totalPages,
    needsPagination: totalPages > 1,
  });

  if (totalPages > 1 && allRows.length > 0) {
    // Clear pagination controls
    paginationControls.innerHTML = "";

    // Generate pagination HTML
    let paginationHTML = "";
    for (let i = 1; i <= totalPages; i++) {
      paginationHTML += `<button onclick="cleanShowPage(${i})" class="px-3 py-1 mx-1 rounded border ${
        i === 1 ? "bg-[#E6521F] text-white" : "bg-white text-[#E6521F]"
      } font-bold">${i}</button>`;
    }
    paginationControls.innerHTML = paginationHTML;

    // Show first page
    cleanShowPage(1);
  } else {
    // Hide pagination if no pages needed or no rows
    paginationControls.style.display = "none";

    // Show all rows if no pagination needed
    if (allRows.length > 0) {
      allRows.forEach((row) => {
        row.style.display = "table-row";
      });
    }
  }
}

// Filtered desktop pagination initialization
function initializeFilteredDesktopPagination(
  table,
  paginationControls,
  visibleRows
) {
  console.log("[CLEAN] Initializing filtered desktop pagination...");

  const rowsPerPage = 7;
  const totalPages = Math.ceil(visibleRows.length / rowsPerPage);

  console.log("[CLEAN] Filtered desktop pagination:", {
    visibleRows: visibleRows.length,
    rowsPerPage: rowsPerPage,
    totalPages: totalPages,
  });

  if (totalPages > 1 && visibleRows.length > 0) {
    // Clear pagination controls
    paginationControls.innerHTML = "";

    // Generate pagination HTML
    let paginationHTML = "";
    for (let i = 1; i <= totalPages; i++) {
      paginationHTML += `<button onclick="cleanShowFilteredPage(${i})" class="px-3 py-1 mx-1 rounded border ${
        i === 1 ? "bg-[#E6521F] text-white" : "bg-white text-[#E6521F]"
      } font-bold">${i}</button>`;
    }
    paginationControls.innerHTML = paginationHTML;

    // Show first page
    cleanShowFilteredPage(1);
  } else {
    // Hide pagination if no pages needed
    paginationControls.style.display = "none";
  }
}

// Mobile pagination initialization
function initializeMobilePagination(cards, mobilePaginationControls) {
  console.log("[CLEAN] Initializing mobile pagination...");

  const allCardElements = cards.children;
  const visibleCardElements = Array.from(allCardElements).filter(
    (card) => card.style.display !== "none"
  );

  const rowsPerPage = 7;
  const totalPages = Math.ceil(allCardElements.length / rowsPerPage);

  console.log("[CLEAN] Mobile pagination:", {
    totalCards: allCardElements.length,
    visibleCards: visibleCardElements.length,
    rowsPerPage: rowsPerPage,
    totalPages: totalPages,
  });

  if (totalPages > 1 && allCardElements.length > 0) {
    // Clear pagination controls
    mobilePaginationControls.innerHTML = "";

    // Generate pagination HTML
    let paginationHTML = "";
    for (let i = 1; i <= totalPages; i++) {
      paginationHTML += `<button onclick="cleanShowMobilePage(${i})" class="px-3 py-1 mx-1 rounded border ${
        i === 1 ? "bg-[#E6521F] text-white" : "bg-white text-[#E6521F]"
      } font-bold">${i}</button>`;
    }
    mobilePaginationControls.innerHTML = paginationHTML;

    // Show first page
    cleanShowMobilePage(1);
  } else {
    // Hide pagination if no pages needed or no cards
    mobilePaginationControls.style.display = "none";

    // Show all cards if no pagination needed
    if (allCardElements.length > 0) {
      allCardElements.forEach((card) => {
        card.style.display = "block";
      });
    }
  }
}

// Mobile modal initialization
function initializeMobileModal(cards) {
  console.log("[CLEAN] Initializing mobile modal...");

  const modal = document.querySelector(".mobile-schedule-modal");
  const closeBtn = document.getElementById("close-mobile-modal");
  const modalContent = document.getElementById("mobile-schedule-content");
  const profileLink = document.getElementById("mobile-doctor-profile-link");

  console.log("[CLEAN] Modal elements found:", {
    modal: !!modal,
    closeBtn: !!closeBtn,
    modalContent: !!modalContent,
    profileLink: !!profileLink,
    cards: !!cards,
  });

  console.log("[CLEAN] Modal element details:", {
    modal: modal,
    closeBtn: closeBtn,
    modalContent: modalContent,
    profileLink: profileLink,
    cards: cards,
  });

  console.log("[CLEAN] Schedule data available:", window.scheduleData);

  if (modal && closeBtn) {
    // Add click event to cards with stopPropagation to prevent conflicts
    console.log("[CLEAN] Adding click event to cards...");
    cards.addEventListener("click", function (e) {
      console.log("[CLEAN] Card clicked, target:", e.target);
      console.log(
        "[CLEAN] Closest popover-btn-mobile:",
        e.target.closest(".popover-btn-mobile")
      );

      // Stop event propagation immediately to prevent main.js from handling it
      e.stopPropagation();

      if (e.target.closest(".popover-btn-mobile")) {
        console.log("[CLEAN] Opening mobile modal...");
        e.preventDefault();

        // Get doctor data
        const card = e.target.closest("[data-name]");
        const doctorName = card.getAttribute("data-name");
        const doctorId = card.getAttribute("data-id");

        console.log("[CLEAN] Doctor data:", { doctorName, doctorId });

        // Get schedule data
        const scheduleData = window.scheduleData || {};
        const doctorSchedules = scheduleData[doctorName] || [];

        console.log("[CLEAN] Schedule data:", doctorSchedules);

        // Populate modal content
        if (modalContent) {
          if (doctorSchedules.length === 0) {
            modalContent.innerHTML = `
              <div class="text-center py-8">
                <svg class="w-12 h-12 text-gray-300 mx-auto mb-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                </svg>
                <p class="text-gray-500">Belum ada jadwal tersedia</p>
              </div>
            `;
          } else {
            const scheduleHTML = doctorSchedules
              .map(
                (schedule) => `
                <div class="flex items-center justify-between p-4 bg-gradient-to-r from-orange-50 to-red-50 rounded-xl border border-orange-100 hover:shadow-md transition-all duration-200">
                  <div class="flex items-center gap-3">
                    <div class="w-10 h-10 bg-gradient-to-r from-[#E6521F] to-[#FF8000] rounded-lg flex items-center justify-center">
                      <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                      </svg>
                    </div>
                    <div>
                      <span class="font-bold text-[#E6521F] text-base block">${schedule.day}</span>
                      <span class="text-xs text-gray-500">Jadwal Praktik</span>
                    </div>
                  </div>
                  <div class="text-right">
                    <span class="text-sm font-semibold text-gray-700">${schedule.time}</span>
                  </div>
                </div>
              `
              )
              .join("");
            modalContent.innerHTML = scheduleHTML;
          }
        }

        // Update profile link
        if (profileLink && doctorId) {
          profileLink.href = `/doctor-profile/${doctorId}`;
        }

        // Show modal
        console.log(
          "[CLEAN] Modal before show:",
          modal.classList.contains("hidden")
        );
        modal.classList.remove("hidden");
        console.log(
          "[CLEAN] Modal after show:",
          modal.classList.contains("hidden")
        );
      }
    });

    // Close modal
    closeBtn.addEventListener("click", function (e) {
      console.log("[CLEAN] Closing mobile modal...");
      e.preventDefault();
      e.stopPropagation();
      modal.classList.add("hidden");
    });

    // Close modal when clicking outside
    modal.addEventListener("click", function (e) {
      if (e.target === modal) {
        console.log("[CLEAN] Closing mobile modal (outside click)...");
        e.preventDefault();
        e.stopPropagation();
        modal.classList.add("hidden");
      }
    });
  }
}

// Desktop pagination function
function cleanShowPage(page) {
  console.log("[CLEAN] Showing desktop page:", page);

  const table = document.getElementById("doctor-schedule-table-desktop");
  const allRows = table.querySelectorAll("tr.doctor-row");

  // Get visible rows BEFORE hiding all rows
  const visibleRows = Array.from(allRows).filter(
    (row) => row.style.display !== "none"
  );

  const rowsPerPage = 7;
  const totalPages = Math.ceil(allRows.length / rowsPerPage);

  console.log("[CLEAN] Desktop pagination state:", {
    totalRows: allRows.length,
    visibleRows: visibleRows.length,
    currentPage: page,
    totalPages: totalPages,
  });

  // Check if page is valid
  if (page < 1 || page > totalPages) {
    console.log("[CLEAN] Invalid page number:", page);
    return;
  }

  // Hide all rows first
  allRows.forEach((row) => (row.style.display = "none"));

  // Show rows for current page from all rows
  const start = (page - 1) * rowsPerPage;
  const end = Math.min(start + rowsPerPage, allRows.length);

  console.log(
    "[CLEAN] Showing rows from",
    start,
    "to",
    end,
    "of",
    allRows.length,
    "total rows"
  );

  for (let i = start; i < end; i++) {
    if (allRows[i]) {
      allRows[i].style.display = "table-row";
      console.log(
        "[CLEAN] Showing row:",
        i,
        "with name:",
        allRows[i].getAttribute("data-name")
      );
    }
  }

  // Update pagination buttons
  const paginationControls = document.getElementById("pagination-controls");
  if (paginationControls) {
    let paginationHTML = "";
    for (let i = 1; i <= totalPages; i++) {
      paginationHTML += `<button onclick="cleanShowPage(${i})" class="px-3 py-1 mx-1 rounded border ${
        i === page ? "bg-[#E6521F] text-white" : "bg-white text-[#E6521F]"
      } font-bold">${i}</button>`;
    }
    paginationControls.innerHTML = paginationHTML;
  }

  currentPage = page;
}

// Mobile pagination function
function cleanShowMobilePage(page) {
  console.log("[CLEAN] Showing mobile page:", page);

  const cards = document.getElementById("doctor-schedule-cards-mobile");
  const allCardElements = cards.children;

  // Get visible cards BEFORE hiding all cards
  const visibleCardElements = Array.from(allCardElements).filter(
    (card) => card.style.display !== "none"
  );

  const rowsPerPage = 7;
  const totalPages = Math.ceil(allCardElements.length / rowsPerPage);

  console.log("[CLEAN] Mobile pagination state:", {
    totalCards: allCardElements.length,
    visibleCards: visibleCardElements.length,
    currentPage: page,
    totalPages: totalPages,
  });

  // Check if page is valid
  if (page < 1 || page > totalPages) {
    console.log("[CLEAN] Invalid page number:", page);
    return;
  }

  // Hide all cards first
  Array.from(allCardElements).forEach((card) => (card.style.display = "none"));

  // Show cards for current page from all cards
  const start = (page - 1) * rowsPerPage;
  const end = Math.min(start + rowsPerPage, allCardElements.length);

  console.log(
    "[CLEAN] Showing cards from",
    start,
    "to",
    end,
    "of",
    allCardElements.length,
    "total cards"
  );

  for (let i = start; i < end; i++) {
    if (allCardElements[i]) {
      allCardElements[i].style.display = "block";
      console.log(
        "[CLEAN] Showing card:",
        i,
        "with name:",
        allCardElements[i].getAttribute("data-name")
      );
    }
  }

  // Update pagination buttons
  const mobilePaginationControls = document.getElementById(
    "pagination-controls-mobile"
  );
  if (mobilePaginationControls) {
    let paginationHTML = "";
    for (let i = 1; i <= totalPages; i++) {
      paginationHTML += `<button onclick="cleanShowMobilePage(${i})" class="px-3 py-1 mx-1 rounded border ${
        i === page ? "bg-[#E6521F] text-white" : "bg-white text-[#E6521F]"
      } font-bold">${i}</button>`;
    }
    mobilePaginationControls.innerHTML = paginationHTML;
  }

  currentMobilePage = page;
}

// Filtered desktop pagination function
function cleanShowFilteredPage(page) {
  console.log("[CLEAN] Showing filtered desktop page:", page);

  const table = document.getElementById("doctor-schedule-table-desktop");
  const allRows = table.querySelectorAll("tr.doctor-row");

  // Get currently visible rows (filtered results)
  const visibleRows = Array.from(allRows).filter(
    (row) => row.style.display !== "none"
  );

  const rowsPerPage = 7;
  const totalPages = Math.ceil(visibleRows.length / rowsPerPage);

  console.log("[CLEAN] Filtered desktop pagination state:", {
    totalRows: allRows.length,
    visibleRows: visibleRows.length,
    currentPage: page,
    totalPages: totalPages,
  });

  // Check if page is valid
  if (page < 1 || page > totalPages) {
    console.log("[CLEAN] Invalid filtered page number:", page);
    return;
  }

  // Hide all rows first
  allRows.forEach((row) => (row.style.display = "none"));

  // Show only visible rows for current page
  const start = (page - 1) * rowsPerPage;
  const end = Math.min(start + rowsPerPage, visibleRows.length);

  console.log(
    "[CLEAN] Showing filtered rows from",
    start,
    "to",
    end,
    "of",
    visibleRows.length,
    "visible rows"
  );

  for (let i = start; i < end; i++) {
    if (visibleRows[i]) {
      visibleRows[i].style.display = "table-row";
      console.log(
        "[CLEAN] Showing filtered row:",
        i,
        "with name:",
        visibleRows[i].getAttribute("data-name")
      );
    }
  }

  // Update pagination buttons
  const paginationControls = document.getElementById("pagination-controls");
  if (paginationControls) {
    let paginationHTML = "";
    for (let i = 1; i <= totalPages; i++) {
      paginationHTML += `<button onclick="cleanShowFilteredPage(${i})" class="px-3 py-1 mx-1 rounded border ${
        i === page ? "bg-[#E6521F] text-white" : "bg-white text-[#E6521F]"
      } font-bold">${i}</button>`;
    }
    paginationControls.innerHTML = paginationHTML;
  }

  currentPage = page;
}
