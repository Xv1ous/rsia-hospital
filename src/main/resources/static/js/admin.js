document.addEventListener("DOMContentLoaded", function () {
  // Fungsi openModal universal
  function openModal(html) {
    const modal = document.getElementById("admin-modal");
    const modalContent = document.getElementById("admin-modal-content");
    modalContent.innerHTML =
      '<button id="admin-modal-close" class="absolute top-3 right-3 text-gray-400 hover:text-gray-700 text-2xl font-bold z-10">&times;</button>' +
      '<div class="max-h-[80vh] overflow-y-auto pr-4 modal-scroll">' +
      html +
      "</div>";
    modal.classList.remove("hidden");
    document.getElementById("admin-modal-close").onclick = function () {
      modal.classList.add("hidden");
    };
  }

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
      openModal(`
        <h3 class='text-xl font-bold mb-4 text-[#17695b]'>Tambah Layanan</h3>
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

  // Hapus dokter
  document
    .querySelectorAll("section#doctors button.bg-red-500")
    .forEach((btn) => {
      btn.onclick = function () {
        const id = this.getAttribute("data-id");
        if (confirm("Yakin ingin menghapus dokter ini?")) {
          fetch(`/admin/api/doctors/${id}`, {
            method: "DELETE",
          }).then((res) => {
            if (res.ok) location.reload();
            else alert("Gagal menghapus dokter");
          });
        }
      };
    });

  // Edit dokter
  document
    .querySelectorAll("section#doctors button[data-id]")
    .forEach((btn) => {
      btn.onclick = function () {
        const id = this.getAttribute("data-id");
        const name = this.getAttribute("data-name");
        const specialization = this.getAttribute("data-specialization");
        const maxPatientsPerDay =
          this.getAttribute("data-max-patients-per-day") || "30";
        const isOnLeave = this.getAttribute("data-is-on-leave");
        const leaveReason = this.getAttribute("data-leave-reason") || "";
        const leaveStartDate = this.getAttribute("data-leave-start-date") || "";
        const leaveEndDate = this.getAttribute("data-leave-end-date") || "";
        const isLocked = this.getAttribute("data-is-locked");
        const lockReason = this.getAttribute("data-lock-reason") || "";
        const lockStartDate = this.getAttribute("data-lock-start-date") || "";
        const lockEndDate = this.getAttribute("data-lock-end-date") || "";

        let leaveHtml = `
          <div class="border-t pt-4 mt-4">
            <h4 class="font-semibold text-gray-800 mb-3">Status Cuti</h4>
            <label class="block">Status Cuti
              <select name="isOnLeave" class="w-full px-3 py-2 rounded border border-gray-200 mt-1">
                <option value="false" ${
                  isOnLeave === "false" || isOnLeave === null ? "selected" : ""
                }>✅ Aktif</option>
                <option value="true" ${
                  isOnLeave === "true" ? "selected" : ""
                }>🏖️ Cuti</option>
              </select>
            </label>
            <label class="block">Alasan Cuti
              <input type="text" name="leaveReason" value="${leaveReason}" class="w-full px-3 py-2 rounded border border-gray-200 mt-1" placeholder="Alasan cuti (opsional)" />
            </label>
            <div class="grid grid-cols-2 gap-2">
              <label class="block">Tanggal Mulai Cuti
                <input type="date" name="leaveStartDate" value="${leaveStartDate}" class="w-full px-3 py-2 rounded border border-gray-200 mt-1" />
              </label>
              <label class="block">Tanggal Selesai Cuti
                <input type="date" name="leaveEndDate" value="${leaveEndDate}" class="w-full px-3 py-2 rounded border border-gray-200 mt-1" />
              </label>
            </div>
          </div>
        `;

        let lockHtml = `
          <div class="border-t pt-4 mt-4">
            <h4 class="font-semibold text-gray-800 mb-3">Status Kunci</h4>
            <label class="block">Status Kunci
              <select name="isLocked" class="w-full px-3 py-2 rounded border border-gray-200 mt-1">
                <option value="false" ${
                  isLocked === "false" || isLocked === null ? "selected" : ""
                }>✅ Aktif</option>
                <option value="true" ${
                  isLocked === "true" ? "selected" : ""
                }>🔒 Dikunci</option>
              </select>
            </label>
            <label class="block">Alasan Kunci
              <input type="text" name="lockReason" value="${lockReason}" class="w-full px-3 py-2 rounded border border-gray-200 mt-1" placeholder="Alasan kunci (opsional)" />
            </label>
            <div class="grid grid-cols-2 gap-2">
              <label class="block">Tanggal Mulai Kunci
                <input type="date" name="lockStartDate" value="${lockStartDate}" class="w-full px-3 py-2 rounded border border-gray-200 mt-1" />
              </label>
              <label class="block">Tanggal Selesai Kunci
                <input type="date" name="lockEndDate" value="${lockEndDate}" class="w-full px-3 py-2 rounded border border-gray-200 mt-1" />
              </label>
            </div>
          </div>
        `;

        openModal(`
          <h3 class='text-xl font-bold mb-4 text-[#E6521F]'>Edit Dokter</h3>
          <form id='edit-doctor-form' class='space-y-4 pb-4'>
            <input type='hidden' name='id' value='${id}' />
            <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
              <label class='block'>Nama Dokter
                <input type='text' name='name' value='${name}' class='w-full px-3 py-2 rounded border border-gray-200 mt-1' required />
              </label>
              <label class='block'>Spesialisasi
                <input type='text' name='specialization' value='${specialization}' class='w-full px-3 py-2 rounded border border-gray-200 mt-1' required />
              </label>
            </div>
            <label class='block'>Maksimal Pasien per Hari
              <input type='number' name='maxPatientsPerDay' value='${maxPatientsPerDay}' class='w-full px-3 py-2 rounded border border-gray-200 mt-1' min='1' max='100' />
            </label>
            ${leaveHtml}
            ${lockHtml}
            <button type='submit' class='w-full px-4 py-2 rounded bg-[#E6521F] text-white font-semibold hover:bg-[#FF8000] transition'>Simpan Perubahan</button>
          </form>
        `);

        document.getElementById("edit-doctor-form").onsubmit = function (e) {
          e.preventDefault();

          // Collect form data
          const formData = new FormData(this);
          const doctorData = {
            id: formData.get("id"),
            name: formData.get("name"),
            specialization: formData.get("specialization"),
            maxPatientsPerDay:
              parseInt(formData.get("maxPatientsPerDay")) || 30,
            isOnLeave: formData.get("isOnLeave") === "true",
            leaveReason: formData.get("leaveReason"),
            leaveStartDate: formData.get("leaveStartDate"),
            leaveEndDate: formData.get("leaveEndDate"),
            isLocked: formData.get("isLocked") === "true",
            lockReason: formData.get("lockReason"),
            lockStartDate: formData.get("lockStartDate"),
            lockEndDate: formData.get("lockEndDate"),
          };

          fetch(`/admin/api/doctors/${id}`, {
            method: "PUT",
            headers: {
              "Content-Type": "application/json",
              "X-CSRF-TOKEN": document.querySelector('input[name="_csrf"]')
                .value,
            },
            body: JSON.stringify(doctorData),
          })
            .then((res) => {
              if (res.ok) {
                location.reload();
              } else {
                res
                  .text()
                  .then((txt) =>
                    alert(
                      "Gagal update dokter. Status: " + res.status + "\n" + txt
                    )
                  );
              }
            })
            .catch((err) => {
              alert("Fetch error: " + err);
            });
        };
      };
    });
});
