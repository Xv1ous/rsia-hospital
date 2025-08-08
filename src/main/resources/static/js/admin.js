document.addEventListener("DOMContentLoaded", function () {
  // Variables for bulk actions
  let selectedDoctors = new Set();
  let allDoctors = new Set();

  // Initialize doctor checkboxes
  function initializeDoctorCheckboxes() {
    const checkboxes = document.querySelectorAll(".doctor-checkbox");
    const selectAllCheckbox = document.getElementById("select-all-doctors");
    const bulkActionsBtn = document.getElementById("bulk-actions-btn");
    const selectedCountSpan = document.getElementById("selected-count");

    // Add all doctor IDs to the set
    checkboxes.forEach((checkbox) => {
      allDoctors.add(checkbox.getAttribute("data-id"));
    });

    // Handle individual checkbox changes
    checkboxes.forEach((checkbox) => {
      checkbox.addEventListener("change", function () {
        const doctorId = this.getAttribute("data-id");
        const doctorName = this.closest("tr")
          .querySelector("td:nth-child(2)")
          .textContent.trim();

        if (this.checked) {
          selectedDoctors.add(doctorId);
        } else {
          selectedDoctors.delete(doctorId);
        }

        updateBulkActionsUI();
        updateSelectAllCheckbox();
      });
    });

    // Handle select all checkbox
    if (selectAllCheckbox) {
      selectAllCheckbox.addEventListener("change", function () {
        checkboxes.forEach((checkbox) => {
          checkbox.checked = this.checked;
          const doctorId = checkbox.getAttribute("data-id");

          if (this.checked) {
            selectedDoctors.add(doctorId);
          } else {
            selectedDoctors.delete(doctorId);
          }
        });

        updateBulkActionsUI();
      });
    }

    // Handle bulk actions button
    if (bulkActionsBtn) {
      bulkActionsBtn.addEventListener("click", function () {
        openBulkActionsModal();
      });
    }
  }

  // Update bulk actions UI
  function updateBulkActionsUI() {
    // Find bulk actions button by its onclick attribute
    const bulkActionsBtn = document.querySelector(
      'button[onclick="openBulkActionsModal()"]'
    );
    const selectedCountSpan = document.getElementById("selected-count");

    console.log("updateBulkActionsUI - bulkActionsBtn:", bulkActionsBtn);
    console.log("updateBulkActionsUI - selectedCountSpan:", selectedCountSpan);
    console.log(
      "updateBulkActionsUI - selectedDoctors.size:",
      selectedDoctors.size
    );

    if (bulkActionsBtn && selectedCountSpan) {
      const count = selectedDoctors.size;
      selectedCountSpan.textContent = count;

      if (count > 0) {
        bulkActionsBtn.classList.remove("hidden");
        bulkActionsBtn.disabled = false;
        bulkActionsBtn.classList.remove("bg-gray-500");
        bulkActionsBtn.classList.add("bg-blue-500", "hover:bg-blue-600");
        console.log("Bulk actions button enabled");
      } else {
        bulkActionsBtn.classList.add("hidden");
        bulkActionsBtn.disabled = true;
        bulkActionsBtn.classList.remove("bg-blue-500", "hover:bg-blue-600");
        bulkActionsBtn.classList.add("bg-gray-500");
        console.log("Bulk actions button disabled");
      }
    } else {
      console.error("Bulk actions button or selected count span not found");
    }
  }

  // Update select all checkbox state
  function updateSelectAllCheckbox() {
    const selectAllCheckbox = document.getElementById("select-all-doctors");
    if (selectAllCheckbox) {
      selectAllCheckbox.checked = selectedDoctors.size === allDoctors.size;
      selectAllCheckbox.indeterminate =
        selectedDoctors.size > 0 && selectedDoctors.size < allDoctors.size;
    }
  }

  // Open bulk actions modal
  window.openBulkActionsModal = function () {
    console.log("Opening bulk actions modal");
    console.log("Selected doctors:", selectedDoctors);

    const modal = document.getElementById("bulk-actions-modal");
    const selectedCountSpan = document.getElementById("bulk-selected-count");
    const selectedNamesSpan = document.getElementById("bulk-selected-names");

    if (modal && selectedCountSpan && selectedNamesSpan) {
      selectedCountSpan.textContent = selectedDoctors.size;

      // Get selected doctor names
      const selectedNames = [];
      selectedDoctors.forEach((doctorId) => {
        const checkbox = document.querySelector(
          `.doctor-checkbox[data-id="${doctorId}"]`
        );
        if (checkbox) {
          const doctorNameElement = checkbox
            .closest("tr")
            .querySelector("td:nth-child(2) .font-medium");
          if (doctorNameElement) {
            selectedNames.push(doctorNameElement.textContent.trim());
          } else {
            // Fallback: get all text from the cell
            const cellText = checkbox
              .closest("tr")
              .querySelector("td:nth-child(2)")
              .textContent.trim();
            selectedNames.push(cellText);
          }
        }
      });

      console.log("Selected doctor names:", selectedNames);
      selectedNamesSpan.textContent = selectedNames.join(", ");
      modal.classList.remove("hidden");
    } else {
      console.error("Modal elements not found:", {
        modal,
        selectedCountSpan,
        selectedNamesSpan,
      });
    }
  };

  // Handle bulk actions
  function handleBulkAction(action) {
    console.log("handleBulkAction called with:", action);
    const doctorIds = Array.from(selectedDoctors);
    console.log("Doctor IDs to process:", doctorIds);

    if (doctorIds.length === 0) {
      alert("No doctors selected");
      return;
    }

    let confirmMessage = "";
    let endpoint = "";
    let method = "PUT";
    let data = {};

    switch (action) {
      case "set-active":
        confirmMessage = `Set ${doctorIds.length} doctor(s) to active?`;
        data = { isOnLeave: false, isLocked: false };
        break;
      case "set-on-leave":
        confirmMessage = `Set ${doctorIds.length} doctor(s) to on leave?`;
        data = { isOnLeave: true };
        break;
      case "lock":
        confirmMessage = `Lock ${doctorIds.length} doctor(s)?`;
        data = { isLocked: true };
        break;
      case "delete":
        confirmMessage = `Delete ${doctorIds.length} doctor(s)? This action cannot be undone!`;
        method = "DELETE";
        break;
    }

    if (confirm(confirmMessage)) {
      const promises = doctorIds.map((doctorId) => {
        const url =
          method === "DELETE"
            ? `/admin/api/doctors/${doctorId}`
            : `/admin/api/doctors/${doctorId}`;

        console.log(`Making ${method} request to ${url}`, data);
        return fetch(url, {
          method: method,
          headers: {
            "Content-Type": "application/json",
          },
          body: method === "DELETE" ? undefined : JSON.stringify(data),
        });
      });

      Promise.all(promises)
        .then((responses) => {
          console.log("Bulk action responses:", responses);
          const allSuccessful = responses.every((res) => res.ok);
          if (allSuccessful) {
            console.log("All bulk actions successful, reloading page");
            location.reload();
          } else {
            console.error("Some bulk actions failed");
            const failedResponses = responses.filter((res) => !res.ok);
            failedResponses.forEach((res, index) => {
              console.error(
                `Failed response ${index}:`,
                res.status,
                res.statusText
              );
            });
            alert("Some actions failed. Please try again.");
          }
        })
        .catch((error) => {
          console.error("Bulk action error:", error);
          alert("An error occurred. Please try again.");
        });
    }
  }

  // Initialize bulk actions
  initializeDoctorCheckboxes();

  // Initialize doctors table search and pagination only on dashboard page
  if (
    window.location.pathname === "/admin" ||
    window.location.pathname === "/admin/"
  ) {
    initializeDoctorsTableSearch();
  }

  // Add event listeners for bulk action buttons
  document.addEventListener("click", function (e) {
    console.log("Click event on:", e.target.id);
    if (e.target.id === "bulk-set-active") {
      console.log("Bulk set active clicked");
      handleBulkAction("set-active");
    } else if (e.target.id === "bulk-set-on-leave") {
      console.log("Bulk set on leave clicked");
      handleBulkAction("set-on-leave");
    } else if (e.target.id === "bulk-lock") {
      console.log("Bulk lock clicked");
      handleBulkAction("lock");
    } else if (e.target.id === "bulk-delete") {
      console.log("Bulk delete clicked");
      handleBulkAction("delete");
    }
  });

  // Doctors Table Search and Pagination
  function initializeDoctorsTableSearch() {
    // Global variables for doctors table pagination and search
    let allDoctorsTable = [];
    let filteredDoctorsTable = [];
    let currentPageTable = 1;
    let pageSizeTable = 10;
    let totalPagesTable = 0;

    // Initialize when page loads
    setTimeout(() => {
      console.log("Initializing doctors table search...");
      initializeDoctorsTableData();
      setupDoctorsTableEventListeners();
      renderDoctorsTable();
    }, 500); // Increased delay to ensure DOM is ready

    // Initialize doctors data from table
    function initializeDoctorsTableData() {
      const tableRows = document.querySelectorAll("tbody tr");
      console.log("Found table rows:", tableRows.length);

      allDoctorsTable = Array.from(tableRows).map((row, index) => {
        const cells = row.querySelectorAll("td");
        console.log(`Row ${index} has ${cells.length} cells`);

        const nameElement = cells[1]?.querySelector(".font-medium");
        const specializationElement = cells[1]?.querySelector(
          ".text-sm.text-gray-500"
        );
        const statusElement = cells[3]?.querySelector(".px-3.py-1");
        const scheduleElements = cells[4]?.querySelectorAll(".mb-1");

        // Extract schedule information
        const schedules = Array.from(scheduleElements).map((schedule) => {
          const day =
            schedule.querySelector(".font-medium")?.textContent?.trim() || "";
          const time =
            schedule.textContent?.split(":")[1]?.split("(")[0]?.trim() || "";
          const hospital = schedule.textContent?.match(/\((.*?)\)/)?.[1] || "";
          return { day, time, hospital };
        });

        const doctorData = {
          id: cells[0]?.querySelector("input")?.getAttribute("data-id") || "",
          name: nameElement?.textContent?.trim() || "",
          specialization: specializationElement?.textContent?.trim() || "",
          status: statusElement?.textContent?.trim() || "",
          schedules: schedules,
          element: row,
        };

        console.log(`Doctor ${index}:`, doctorData);
        return doctorData;
      });
      filteredDoctorsTable = [...allDoctorsTable];

      console.log("Extracted doctors table data:", allDoctorsTable);
      console.log("Total doctors extracted:", allDoctorsTable.length);

      // Populate specialization filter with actual data
      populateSpecializationFilter();

      updateDoctorsTableCounts();
    }

    // Populate specialization filter with actual data
    function populateSpecializationFilter() {
      const specializationFilter = document.getElementById(
        "filter-specialization-table"
      );
      if (!specializationFilter) return;

      // Get unique specializations from data
      const specializations = [
        ...new Set(
          allDoctorsTable.map((doctor) => doctor.specialization).filter(Boolean)
        ),
      ];

      // Clear existing options except the first one
      specializationFilter.innerHTML =
        '<option value="">Semua Spesialisasi</option>';

      // Add options for each unique specialization
      specializations.sort().forEach((specialization) => {
        const option = document.createElement("option");
        option.value = specialization;
        option.textContent = specialization;
        specializationFilter.appendChild(option);
      });
    }

    // Setup event listeners for doctors table
    function setupDoctorsTableEventListeners() {
      // Search input
      const searchInput = document.getElementById("search-doctors-table");
      if (searchInput) {
        searchInput.addEventListener("input", function (e) {
          console.log("Doctors table search input changed:", e.target.value);
          currentPageTable = 1;
          filterDoctorsTable();
        });
      } else {
        console.error("Doctors table search input not found");
      }

      // Filter dropdowns
      const specializationFilter = document.getElementById(
        "filter-specialization-table"
      );
      if (specializationFilter) {
        specializationFilter.addEventListener("change", function (e) {
          console.log(
            "Doctors table specialization filter changed:",
            e.target.value
          );
          currentPageTable = 1;
          filterDoctorsTable();
        });
      } else {
        console.error("Doctors table specialization filter not found");
      }

      const statusFilter = document.getElementById("filter-status-table");
      if (statusFilter) {
        statusFilter.addEventListener("change", function (e) {
          console.log("Doctors table status filter changed:", e.target.value);
          currentPageTable = 1;
          filterDoctorsTable();
        });
      } else {
        console.error("Doctors table status filter not found");
      }

      // Page size selector
      const pageSizeSelector = document.getElementById("page-size-table");
      if (pageSizeSelector) {
        pageSizeSelector.addEventListener("change", function (e) {
          pageSizeTable = parseInt(e.target.value);
          currentPageTable = 1;
          renderDoctorsTable();
        });
      }

      // Pagination buttons
      const prevBtn = document.getElementById("prev-page-table");
      if (prevBtn) {
        prevBtn.addEventListener("click", function () {
          if (currentPageTable > 1) {
            currentPageTable--;
            renderDoctorsTable();
          }
        });
      }

      const nextBtn = document.getElementById("next-page-table");
      if (nextBtn) {
        nextBtn.addEventListener("click", function () {
          if (currentPageTable < totalPagesTable) {
            currentPageTable++;
            renderDoctorsTable();
          }
        });
      }
    }

    // Filter doctors based on search and filters
    function filterDoctorsTable() {
      const searchTerm =
        document.getElementById("search-doctors-table")?.value?.toLowerCase() ||
        "";
      const specializationFilter =
        document.getElementById("filter-specialization-table")?.value || "";
      const statusFilter =
        document.getElementById("filter-status-table")?.value || "";

      console.log("Doctors table filtering with:", {
        searchTerm,
        specializationFilter,
        statusFilter,
        totalDoctors: allDoctorsTable.length,
      });

      filteredDoctorsTable = allDoctorsTable.filter((doctor) => {
        const matchesSearch =
          !searchTerm ||
          doctor.name.toLowerCase().includes(searchTerm) ||
          doctor.specialization.toLowerCase().includes(searchTerm) ||
          doctor.schedules.some((schedule) =>
            schedule.hospital.toLowerCase().includes(searchTerm)
          );

        const matchesSpecialization =
          !specializationFilter ||
          doctor.specialization === specializationFilter;

        const matchesStatus = !statusFilter || doctor.status === statusFilter;

        return matchesSearch && matchesSpecialization && matchesStatus;
      });

      console.log(
        "Doctors table filtered results:",
        filteredDoctorsTable.length
      );

      updateDoctorsTableCounts();
      renderDoctorsTable();
    }

    // Update counts and pagination info
    function updateDoctorsTableCounts() {
      const countElement = document.getElementById("doctors-table-count");
      const totalElement = document.getElementById("total-doctors-table");

      if (countElement) countElement.textContent = filteredDoctorsTable.length;
      if (totalElement) totalElement.textContent = filteredDoctorsTable.length;

      totalPagesTable = Math.ceil(filteredDoctorsTable.length / pageSizeTable);
    }

    // Render doctors for current page
    function renderDoctorsTable() {
      const tbody = document.querySelector("tbody");
      if (!tbody) return;

      const startIndex = (currentPageTable - 1) * pageSizeTable;
      const endIndex = startIndex + pageSizeTable;
      const doctorsToShow = filteredDoctorsTable.slice(startIndex, endIndex);

      // Clear current table
      tbody.innerHTML = "";

      // Add filtered doctors
      doctorsToShow.forEach((doctor) => {
        const row = document.createElement("tr");
        row.className = "hover:bg-gray-50 transition-colors";

        // Create schedule HTML
        const scheduleHTML = doctor.schedules
          .map(
            (schedule) =>
              `<div class="mb-1">
            <span class="font-medium">${schedule.day}</span>:
            <span>${schedule.time}</span>
            <span class="text-gray-500">(${schedule.hospital})</span>
          </div>`
          )
          .join("");

        row.innerHTML = `
          <td class="py-4 px-6">
            <input
              type="checkbox"
              value="${doctor.id}"
              data-id="${doctor.id}"
              class="doctor-checkbox rounded border-gray-300 text-primary focus:ring-primary"
            />
          </td>
          <td class="py-4 px-6">
            <div class="flex items-center">
              <div class="w-10 h-10 bg-green-100 rounded-full flex items-center justify-center mr-3">
                <span class="text-green-600 font-bold text-sm">${doctor.name.charAt(
                  0
                )}</span>
              </div>
              <div>
                <div class="font-medium text-gray-900">${doctor.name}</div>
                <div class="text-sm text-gray-500">${
                  doctor.specialization
                }</div>
              </div>
            </div>
          </td>
          <td class="py-4 px-6">
            <span class="px-3 py-1 bg-purple-100 text-purple-800 rounded-full text-sm font-medium">${
              doctor.specialization
            }</span>
          </td>
          <td class="py-4 px-6">
            <div class="flex items-center space-x-2">
              <span class="px-3 py-1 bg-green-100 text-green-800 rounded-full text-xs font-medium">${
                doctor.status
              }</span>
            </div>
          </td>
          <td class="py-4 px-6">
            <div class="text-sm text-gray-600 max-w-xs">
              ${scheduleHTML}
            </div>
          </td>
          <td class="py-4 px-6">
            <div class="flex items-center space-x-2">
              <button
                onclick="openEditModal('doctor', '${doctor.id}')"
                class="inline-flex items-center px-3 py-1.5 rounded-md text-xs font-medium bg-blue-100 text-blue-700 hover:bg-blue-200 transition-colors"
              >
                <svg class="w-3 h-3 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
                </svg>
                Edit
              </button>
              <button
                class="schedule-modal-btn inline-flex items-center px-3 py-1.5 rounded-md text-xs font-medium bg-green-100 text-green-700 hover:bg-green-200 transition-colors"
                data-doctor-id="${doctor.id}"
                data-doctor-name="${doctor.name}"
                data-doctor-specialization="${doctor.specialization}"
              >
                <svg class="w-3 h-3 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path>
                </svg>
                Jadwal
              </button>
              <button
                onclick="deleteItem('doctor', '${doctor.id}')"
                class="inline-flex items-center px-3 py-1.5 rounded-md text-xs font-medium bg-red-100 text-red-700 hover:bg-red-200 transition-colors"
              >
                <svg class="w-3 h-3 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path>
                </svg>
                Hapus
              </button>
            </div>
          </td>
        `;
        tbody.appendChild(row);
      });

      // Re-initialize checkboxes after rendering
      initializeDoctorCheckboxes();

      // Update pagination
      updateDoctorsTablePagination();
    }

    // Update pagination controls
    function updateDoctorsTablePagination() {
      const prevBtn = document.getElementById("prev-page-table");
      const nextBtn = document.getElementById("next-page-table");
      const pageNumbers = document.getElementById("page-numbers-table");

      if (prevBtn) prevBtn.disabled = currentPageTable === 1;
      if (nextBtn) nextBtn.disabled = currentPageTable === totalPagesTable;

      if (pageNumbers) {
        pageNumbers.innerHTML = "";

        if (totalPagesTable <= 1) return;

        const maxVisiblePages = 5;
        let startPage = Math.max(
          1,
          currentPageTable - Math.floor(maxVisiblePages / 2)
        );
        let endPage = Math.min(
          totalPagesTable,
          startPage + maxVisiblePages - 1
        );

        if (endPage - startPage + 1 < maxVisiblePages) {
          startPage = Math.max(1, endPage - maxVisiblePages + 1);
        }

        // Add first page if not visible
        if (startPage > 1) {
          addDoctorsTablePageNumber(1);
          if (startPage > 2) {
            addDoctorsTablePageEllipsis();
          }
        }

        // Add visible page numbers
        for (let i = startPage; i <= endPage; i++) {
          addDoctorsTablePageNumber(i);
        }

        // Add last page if not visible
        if (endPage < totalPagesTable) {
          if (endPage < totalPagesTable - 1) {
            addDoctorsTablePageEllipsis();
          }
          addDoctorsTablePageNumber(totalPagesTable);
        }
      }
    }

    // Add page number button
    function addDoctorsTablePageNumber(pageNum) {
      const pageNumbers = document.getElementById("page-numbers-table");
      if (!pageNumbers) return;

      const button = document.createElement("button");
      button.className = `px-3 py-1 text-sm border rounded ${
        pageNum === currentPageTable
          ? "bg-primary text-white border-primary"
          : "border-gray-300 hover:bg-gray-100"
      }`;
      button.textContent = pageNum;
      button.addEventListener("click", () => {
        currentPageTable = pageNum;
        renderDoctorsTable();
      });
      pageNumbers.appendChild(button);
    }

    // Add page ellipsis
    function addDoctorsTablePageEllipsis() {
      const pageNumbers = document.getElementById("page-numbers-table");
      if (!pageNumbers) return;

      const span = document.createElement("span");
      span.className = "px-2 py-1 text-sm text-gray-500";
      span.textContent = "...";
      pageNumbers.appendChild(span);
    }
  }

  // Fungsi openModal universal
  function openModalInternal(html) {
    const modal = document.getElementById("admin-modal");
    const modalContent = document.getElementById("admin-modal-content");
    modalContent.innerHTML =
      '<button id="admin-modal-close" class="absolute top-3 right-3 text-gray-400 hover:text-gray-700 text-2xl font-bold z-10">&times;</button>' +
      '<div class="max-h-[80vh] overflow-y-auto pr-4 modal-scroll">' +
      html +
      "</div>";
    modal.classList.remove("hidden");

    // Close button functionality
    document.getElementById("admin-modal-close").onclick = function () {
      modal.classList.add("hidden");
    };

    // Close modal when clicking outside
    modal.addEventListener("click", function (e) {
      if (e.target === modal) {
        modal.classList.add("hidden");
      }
    });
  }

  // Fungsi openModal untuk tipe tertentu
  window.openModal = function (type) {
    switch (type) {
      case "add-appointment":
        openModalInternal(`
          <h3 class='text-xl font-bold mb-4 text-primary'>Tambah Janji Temu</h3>
          <form id='add-appointment-form' class='space-y-4 pb-4'>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <label class='block'>Nama Pasien
                <input type='text' name='patientName' class='w-full px-3 py-2 rounded border border-gray-200 mt-1' required />
              </label>
              <label class='block'>Telepon
                <input type='tel' name='patientPhone' class='w-full px-3 py-2 rounded border border-gray-200 mt-1' required />
              </label>
            </div>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <label class='block'>Dokter/Departemen
                <input type='text' name='department' class='w-full px-3 py-2 rounded border border-gray-200 mt-1' required />
              </label>
              <label class='block'>Tanggal
                <input type='date' name='appointmentDate' class='w-full px-3 py-2 rounded border border-gray-200 mt-1' required />
              </label>
            </div>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <label class='block'>Jam
                <input type='time' name='appointmentTime' class='w-full px-3 py-2 rounded border border-gray-200 mt-1' required />
              </label>
              <label class='block'>Status
                <select name='status' class='w-full px-3 py-2 rounded border border-gray-200 mt-1' required>
                  <option value='Menunggu'>Menunggu</option>
                  <option value='Dikonfirmasi'>Dikonfirmasi</option>
                  <option value='Selesai'>Selesai</option>
                  <option value='Dibatalkan'>Dibatalkan</option>
                </select>
              </label>
            </div>
            <button type='submit' class='w-full px-4 py-2 rounded bg-primary text-white font-semibold hover:bg-primary-dark transition'>Simpan</button>
          </form>
        `);

        // Handle form submission
        document.getElementById("add-appointment-form").onsubmit = function (
          e
        ) {
          e.preventDefault();
          const formData = new FormData(this);
          const data = Object.fromEntries(formData);

          fetch("/admin/api/appointments", {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
            },
            body: JSON.stringify(data),
          })
            .then((res) => {
              if (res.ok) {
                location.reload();
              } else {
                alert("Gagal menambah janji temu");
              }
            })
            .catch((err) => {
              alert("Error: " + err);
            });
        };
        break;

      case "add-doctor":
        openModalInternal(`
          <h3 class='text-xl font-bold mb-4 text-primary'>Tambah Dokter</h3>
          <form id='add-doctor-form' class='space-y-4 pb-4'>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <label class='block'>Nama Dokter
                <input type='text' name='name' class='w-full px-3 py-2 rounded border border-gray-200 mt-1' required />
              </label>
              <label class='block'>Spesialisasi
                <input type='text' name='specialization' class='w-full px-3 py-2 rounded border border-gray-200 mt-1' required />
              </label>
            </div>
            <label class='block'>Maksimal Pasien per Hari
              <input type='number' name='maxPatientsPerDay' value='30' class='w-full px-3 py-2 rounded border border-gray-200 mt-1' min='1' max='100' />
            </label>
            <button type='submit' class='w-full px-4 py-2 rounded bg-primary text-white font-semibold hover:bg-primary-dark transition'>Simpan</button>
          </form>
        `);

        // Handle form submission
        document.getElementById("add-doctor-form").onsubmit = function (e) {
          e.preventDefault();
          const formData = new FormData(this);
          const data = Object.fromEntries(formData);

          fetch("/admin/api/doctors", {
            method: "POST",
            headers: {
              "Content-Type": "application/json",
            },
            body: JSON.stringify(data),
          })
            .then((res) => {
              if (res.ok) {
                location.reload();
              } else {
                alert("Gagal menambah dokter");
              }
            })
            .catch((err) => {
              alert("Error: " + err);
            });
        };
        break;

      default:
        console.log("Unknown modal type:", type);
    }
  };

  // Fungsi openEditModal untuk edit item
  window.openEditModal = function (type, id) {
    console.log("openEditModal called with:", type, id);
    // Fetch data berdasarkan tipe dan ID
    fetch(`/admin/api/${type}s/${id}`)
      .then((res) => {
        console.log("API response status:", res.status);
        if (!res.ok) {
          throw new Error(`HTTP error! status: ${res.status}`);
        }
        return res.json();
      })
      .then((data) => {
        console.log("API response data:", data);
        if (type === "appointment") {
          openModalInternal(`
            <h3 class='text-xl font-bold mb-4 text-primary'>Edit Janji Temu</h3>
            <form id='edit-appointment-form' class='space-y-4 pb-4'>
              <input type='hidden' name='id' value='${data.id}' />
              <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <label class='block'>Nama Pasien
                  <input type='text' name='patientName' value='${
                    data.patientName || ""
                  }' class='w-full px-3 py-2 rounded border border-gray-200 mt-1' required />
                </label>
                <label class='block'>Telepon
                  <input type='tel' name='patientPhone' value='${
                    data.patientPhone || ""
                  }' class='w-full px-3 py-2 rounded border border-gray-200 mt-1' required />
                </label>
              </div>
              <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <label class='block'>Dokter/Departemen
                  <input type='text' name='department' value='${
                    data.department || ""
                  }' class='w-full px-3 py-2 rounded border border-gray-200 mt-1' required />
                </label>
                <label class='block'>Tanggal
                  <input type='date' name='appointmentDate' value='${
                    data.appointmentDate || ""
                  }' class='w-full px-3 py-2 rounded border border-gray-200 mt-1' required />
                </label>
              </div>
              <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <label class='block'>Jam
                  <input type='time' name='appointmentTime' value='${
                    data.appointmentTime || ""
                  }' class='w-full px-3 py-2 rounded border border-gray-200 mt-1' required />
                </label>
                <label class='block'>Status
                  <select name='status' class='w-full px-3 py-2 rounded border border-gray-200 mt-1' required>
                    <option value='Menunggu' ${
                      data.status === "Menunggu" ? "selected" : ""
                    }>Menunggu</option>
                    <option value='Dikonfirmasi' ${
                      data.status === "Dikonfirmasi" ? "selected" : ""
                    }>Dikonfirmasi</option>
                    <option value='Selesai' ${
                      data.status === "Selesai" ? "selected" : ""
                    }>Selesai</option>
                    <option value='Dibatalkan' ${
                      data.status === "Dibatalkan" ? "selected" : ""
                    }>Dibatalkan</option>
                  </select>
                </label>
              </div>
              <button type='submit' class='w-full px-4 py-2 rounded bg-primary text-white font-semibold hover:bg-primary-dark transition'>Update</button>
            </form>
          `);

          // Handle form submission
          document.getElementById("edit-appointment-form").onsubmit = function (
            e
          ) {
            e.preventDefault();
            const formData = new FormData(this);
            const updateData = Object.fromEntries(formData);

            fetch(`/admin/api/appointments/${id}`, {
              method: "PUT",
              headers: {
                "Content-Type": "application/json",
              },
              body: JSON.stringify(updateData),
            })
              .then((res) => {
                if (res.ok) {
                  location.reload();
                } else {
                  alert("Gagal update janji temu");
                }
              })
              .catch((err) => {
                alert("Error: " + err);
              });
          };
        } else if (type === "doctor") {
          // Show edit form directly with fetched data
          openModalInternal(`
            <h3 class='text-xl font-bold mb-4 text-primary'>Edit Dokter</h3>
            <form id='edit-doctor-form' class='space-y-4 pb-4'>
              <input type='hidden' name='id' value='${data.id}' />
              <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <label class='block'>Nama Dokter
                  <input type='text' name='name' value='${
                    data.name || ""
                  }' class='w-full px-3 py-2 rounded border border-gray-200 mt-1' required />
                </label>
                <label class='block'>Spesialisasi
                  <input type='text' name='specialization' value='${
                    data.specialization || ""
                  }' class='w-full px-3 py-2 rounded border border-gray-200 mt-1' required />
                </label>
              </div>
              <label class='block'>Maksimal Pasien per Hari
                <input type='number' name='maxPatientsPerDay' value='${
                  data.maxPatientsPerDay || 30
                }' class='w-full px-3 py-2 rounded border border-gray-200 mt-1' min='1' max='100' />
              </label>

              <div class="border-t pt-4 mt-4">
                <h4 class="font-semibold text-gray-800 mb-3">Status Cuti</h4>
                <label class="block">Status Cuti
                  <select name="isOnLeave" class="w-full px-3 py-2 rounded border border-gray-200 mt-1">
                    <option value="false" ${
                      data.isOnLeave === true ? "" : "selected"
                    }>✅ Aktif</option>
                    <option value="true" ${
                      data.isOnLeave === true ? "selected" : ""
                    }>🏖️ Cuti</option>
                  </select>
                </label>
                <label class="block">Alasan Cuti
                  <input type="text" name="leaveReason" value="${
                    data.leaveReason || ""
                  }" class="w-full px-3 py-2 rounded border border-gray-200 mt-1" placeholder="Alasan cuti (opsional)" />
                </label>
                <div class="grid grid-cols-2 gap-2">
                  <label class="block">Tanggal Mulai Cuti
                    <input type="date" name="leaveStartDate" value="${
                      data.leaveStartDate || ""
                    }" class="w-full px-3 py-2 rounded border border-gray-200 mt-1" />
                  </label>
                  <label class="block">Tanggal Selesai Cuti
                    <input type="date" name="leaveEndDate" value="${
                      data.leaveEndDate || ""
                    }" class="w-full px-3 py-2 rounded border border-gray-200 mt-1" />
                  </label>
                </div>
              </div>

              <div class="border-t pt-4 mt-4">
                <h4 class="font-semibold text-gray-800 mb-3">Status Kunci</h4>
                <label class="block">Status Kunci
                  <select name="isLocked" class="w-full px-3 py-2 rounded border border-gray-200 mt-1">
                    <option value="false" ${
                      data.isLocked === true ? "" : "selected"
                    }>✅ Aktif</option>
                    <option value="true" ${
                      data.isLocked === true ? "selected" : ""
                    }>🔒 Dikunci</option>
                  </select>
                </label>
                <label class="block">Alasan Kunci
                  <input type="text" name="lockReason" value="${
                    data.lockReason || ""
                  }" class="w-full px-3 py-2 rounded border border-gray-200 mt-1" placeholder="Alasan kunci (opsional)" />
                </label>
                <div class="grid grid-cols-2 gap-2">
                  <label class="block">Tanggal Mulai Kunci
                    <input type="date" name="lockStartDate" value="${
                      data.lockStartDate || ""
                    }" class="w-full px-3 py-2 rounded border border-gray-200 mt-1" />
                  </label>
                  <label class="block">Tanggal Selesai Kunci
                    <input type="date" name="lockEndDate" value="${
                      data.lockEndDate || ""
                    }" class="w-full px-3 py-2 rounded border border-gray-200 mt-1" />
                  </label>
                </div>
              </div>

              <button type='submit' class='w-full px-4 py-2 rounded bg-primary text-white font-semibold hover:bg-primary-dark transition'>Update</button>
            </form>
          `);

          // Handle form submission
          document.getElementById("edit-doctor-form").onsubmit = function (e) {
            e.preventDefault();
            const formData = new FormData(this);
            const updateData = Object.fromEntries(formData);

            // Convert string values to appropriate types
            updateData.maxPatientsPerDay =
              parseInt(updateData.maxPatientsPerDay) || 30;
            updateData.isOnLeave = updateData.isOnLeave === "true";
            updateData.isLocked = updateData.isLocked === "true";

            // Handle empty date strings
            if (!updateData.leaveStartDate) updateData.leaveStartDate = null;
            if (!updateData.leaveEndDate) updateData.leaveEndDate = null;
            if (!updateData.lockStartDate) updateData.lockStartDate = null;
            if (!updateData.lockEndDate) updateData.lockEndDate = null;

            fetch(`/admin/api/doctors/${id}`, {
              method: "PUT",
              headers: {
                "Content-Type": "application/json",
              },
              body: JSON.stringify(updateData),
            })
              .then((res) => {
                if (res.ok) {
                  location.reload();
                } else {
                  alert("Gagal update dokter");
                }
              })
              .catch((err) => {
                alert("Error: " + err);
              });
          };
        }
      })
      .catch((err) => {
        console.error("Error fetching data:", err);
        alert("Gagal mengambil data untuk edit");
      });
  };

  // Fungsi deleteItem untuk hapus item
  window.deleteItem = function (type, id) {
    if (confirm(`Yakin ingin menghapus ${type} ini?`)) {
      fetch(`/admin/api/${type}s/${id}`, {
        method: "DELETE",
      })
        .then((res) => {
          if (res.ok) {
            location.reload();
          } else {
            alert(`Gagal menghapus ${type}`);
          }
        })
        .catch((err) => {
          alert("Error: " + err);
        });
    }
  };

  // Debug: pastikan tombol ditemukan
  const btnAddAppointment = document.getElementById(
    "open-add-appointment-modal"
  );
  const btnAddDoctor = document.getElementById("open-add-doctor-modal");
  const btnAddNews = document.getElementById("open-add-news-modal");
  const btnAddService = document.getElementById("open-add-service-modal");
  console.log(
    "Tombol tambah:",
    btnAddAppointment,
    btnAddDoctor,
    btnAddNews,
    btnAddService
  );

  if (btnAddAppointment)
    btnAddAppointment.addEventListener("click", function () {
      document
        .getElementById("add-appointment-modal")
        .classList.remove("hidden");
    });
  if (btnAddDoctor)
    btnAddDoctor.addEventListener("click", function () {
      document.getElementById("add-doctor-modal").classList.remove("hidden");
    });
  if (btnAddNews)
    btnAddNews.addEventListener("click", function () {
      document.getElementById("add-news-modal").classList.remove("hidden");
    });
  if (btnAddService)
    btnAddService.addEventListener("click", function () {
      console.log("Tambah Layanan diklik");
      openModalInternal(`
        <h3 class='text-xl font-bold mb-4 text-primary'>Tambah Layanan</h3>
        <form class='space-y-4 pb-4'>
          <label class='block'>Nama Layanan
            <input type='text' class='w-full px-3 py-2 rounded border border-gray-200 mt-1' />
          </label>
          <label class='block'>Kategori
            <input type='text' class='w-full px-3 py-2 rounded border border-gray-200 mt-1' />
          </label>
          <label class='block'>Status
            <select class='w-full px-3 py-2 rounded border border-gray-200 mt-1'>
              <option>Aktif</option>
              <option>Nonaktif</option>
            </select>
          </label>
          <button type='submit' class='w-full px-4 py-2 rounded bg-primary-orange text-white font-semibold hover:bg-primary-orange-dark transition'>Simpan</button>
        </form>
      `);
    });
});
