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
