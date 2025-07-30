// Schedule JavaScript - Simple Version
console.log("[DEBUG] schedule.js starting...");

document.addEventListener("DOMContentLoaded", function () {
  console.log("[DEBUG] DOM loaded");

  // Check if schedule elements exist
  const table = document.getElementById("doctor-schedule-table-desktop");
  const mobileCards = document.getElementById("doctor-schedule-cards-mobile");

  console.log("[DEBUG] Elements found:", {
    table: !!table,
    mobileCards: !!mobileCards,
  });

  if (!table && !mobileCards) {
    console.log("[DEBUG] No schedule elements found, exiting");
    return;
  }

  // Handle popover functionality for desktop
  if (table) {
    console.log("[DEBUG] Setting up desktop popovers");

    // Popover functionality
    const popoverBtns = table.querySelectorAll(".popover-btn");
    popoverBtns.forEach((btn) => {
      btn.addEventListener("click", function (e) {
        e.stopPropagation();

        // Close all other popovers
        document.querySelectorAll(".popover-content").forEach((popover) => {
          popover.classList.add("hidden");
        });

        // Toggle current popover
        const popover = this.nextElementSibling;
        if (popover && popover.classList.contains("popover-content")) {
          popover.classList.toggle("hidden");
        }
      });
    });

    // Close popovers when clicking outside
    document.addEventListener("click", function (e) {
      if (
        !e.target.closest(".popover-btn") &&
        !e.target.closest(".popover-content")
      ) {
        document.querySelectorAll(".popover-content").forEach((popover) => {
          popover.classList.add("hidden");
        });
      }
    });

    // Close popover buttons
    document.querySelectorAll(".close-popover").forEach((btn) => {
      btn.addEventListener("click", function (e) {
        e.stopPropagation();
        const popover = this.closest(".popover-content");
        if (popover) {
          popover.classList.add("hidden");
        }
      });
    });
  }

  // Handle mobile modal functionality
  if (mobileCards) {
    console.log("[DEBUG] Setting up mobile modal");

    const mobileModal = document.querySelector(".mobile-schedule-modal");
    const mobileContent = document.getElementById("mobile-schedule-content");
    const mobileProfileLink = document.getElementById(
      "mobile-doctor-profile-link"
    );
    const closeModalBtn = document.querySelector(".close-mobile-modal");

    // Mobile popover buttons
    const mobilePopoverBtns = mobileCards.querySelectorAll(
      ".popover-btn-mobile"
    );
    mobilePopoverBtns.forEach((btn) => {
      btn.addEventListener("click", function (e) {
        e.preventDefault();

        // Get doctor data from the card
        const card = this.closest("[data-name]");
        const doctorName = card.getAttribute("data-name");
        const doctorId = card.getAttribute("data-id");

        // Get schedule data from the page
        const scheduleData = window.scheduleData || {};
        const doctorSchedules = scheduleData[doctorName] || [];

        // Populate modal content
        if (mobileContent) {
          if (doctorSchedules.length === 0) {
            mobileContent.innerHTML = `
              <div class="text-center py-8">
                <svg class="w-12 h-12 text-gray-300 mx-auto mb-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                </svg>
                <p class="text-gray-500">Belum ada jadwal tersedia</p>
              </div>
            `;
          } else {
            let scheduleHTML = "";
            doctorSchedules.forEach((schedule) => {
              scheduleHTML += `
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
              `;
            });
            mobileContent.innerHTML = scheduleHTML;
          }
        }

        // Update profile link
        if (mobileProfileLink && doctorId) {
          mobileProfileLink.href = `/doctor-profile/${doctorId}`;
        }

        // Show modal
        if (mobileModal) {
          mobileModal.classList.remove("hidden");
        }
      });
    });

    // Close modal
    if (closeModalBtn) {
      closeModalBtn.addEventListener("click", function () {
        if (mobileModal) {
          mobileModal.classList.add("hidden");
        }
      });
    }

    // Close modal when clicking outside
    if (mobileModal) {
      mobileModal.addEventListener("click", function (e) {
        if (e.target === this) {
          this.classList.add("hidden");
        }
      });
    }
  }

  // Simple pagination for desktop
  if (table) {
    console.log("[DEBUG] Setting up desktop pagination");

    const allRows = Array.from(table.querySelectorAll(".doctor-row"));
    console.log("[DEBUG] Found", allRows.length, "doctor rows");

    const rowsPerPage = 7;
    let currentPage = 1;
    const totalPages = Math.ceil(allRows.length / rowsPerPage);

    console.log("[DEBUG] Total pages:", totalPages);

    const paginationControls = document.getElementById("pagination-controls");
    if (paginationControls) {
      console.log("[DEBUG] Pagination controls found");

      function showPage(page) {
        console.log("[DEBUG] Showing page", page);
        currentPage = page;

        // Hide all rows
        allRows.forEach((row) => (row.style.display = "none"));

        // Show rows for current page
        const start = (page - 1) * rowsPerPage;
        const end = start + rowsPerPage;

        for (let i = start; i < end && i < allRows.length; i++) {
          allRows[i].style.display = "";
        }

        // Update pagination buttons
        let html = "";
        if (totalPages > 1) {
          // Previous button
          html += `<button ${page === 1 ? "disabled" : ""} onclick="showPage(${
            page - 1
          })" class="px-3 py-1 mx-1 rounded border bg-white text-[#E6521F] font-bold">&laquo;</button>`;

          // Page numbers
          for (let i = 1; i <= totalPages; i++) {
            const active = i === page;
            html += `<button onclick="showPage(${i})" class="px-3 py-1 mx-1 rounded border ${
              active ? "bg-[#E6521F] text-white" : "bg-white text-[#E6521F]"
            } font-bold">${i}</button>`;
          }

          // Next button
          html += `<button ${
            page === totalPages ? "disabled" : ""
          } onclick="showPage(${
            page + 1
          })" class="px-3 py-1 mx-1 rounded border bg-white text-[#E6521F] font-bold">&raquo;</button>`;
        }

        paginationControls.innerHTML = html;
        paginationControls.style.display = totalPages > 1 ? "" : "none";

        console.log("[DEBUG] Pagination HTML:", html);
      }

      // Make showPage function global
      window.showPage = showPage;

      // Show first page
      showPage(1);
    } else {
      console.log("[ERROR] Pagination controls not found");
    }
  }

  // Simple pagination for mobile
  if (mobileCards) {
    console.log("[DEBUG] Setting up mobile pagination");

    const allCards = Array.from(mobileCards.children);
    console.log("[DEBUG] Found", allCards.length, "mobile cards");

    const cardsPerPage = 7;
    let mobileCurrentPage = 1;
    const totalMobilePages = Math.ceil(allCards.length / cardsPerPage);

    console.log("[DEBUG] Total mobile pages:", totalMobilePages);

    const mobilePaginationControls = document.getElementById(
      "pagination-controls-mobile"
    );
    if (mobilePaginationControls) {
      console.log("[DEBUG] Mobile pagination controls found");

      function showMobilePage(page) {
        console.log("[DEBUG] Showing mobile page", page);
        mobileCurrentPage = page;

        // Hide all cards
        allCards.forEach((card) => (card.style.display = "none"));

        // Show cards for current page
        const start = (page - 1) * cardsPerPage;
        const end = start + cardsPerPage;

        for (let i = start; i < end && i < allCards.length; i++) {
          allCards[i].style.display = "";
        }

        // Update mobile pagination
        let html = "";
        if (totalMobilePages > 1) {
          html += `<button ${
            page === 1 ? "disabled" : ""
          } onclick="showMobilePage(${
            page - 1
          })" class="px-3 py-1 mx-1 rounded border bg-white text-[#E6521F] font-bold">&lt;</button>`;
          html += `<span class="px-3 py-1 mx-1 font-bold">${page} / ${totalMobilePages}</span>`;
          html += `<button ${
            page === totalMobilePages ? "disabled" : ""
          } onclick="showMobilePage(${
            page + 1
          })" class="px-3 py-1 mx-1 rounded border bg-white text-[#E6521F] font-bold">&gt;</button>`;
        }

        mobilePaginationControls.innerHTML = html;
        mobilePaginationControls.style.display =
          totalMobilePages > 1 ? "" : "none";

        console.log("[DEBUG] Mobile pagination HTML:", html);
      }

      // Make showMobilePage function global
      window.showMobilePage = showMobilePage;

      // Show first page
      showMobilePage(1);
    } else {
      console.log("[ERROR] Mobile pagination controls not found");
    }
  }

  console.log("[DEBUG] schedule.js setup complete");
});
