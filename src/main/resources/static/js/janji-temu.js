// Kirim ke WhatsApp
function kirimKeWhatsApp() {
  var nama = document.querySelector('[name="patientName"]').value.trim();
  var telp = document.querySelector('[name="patientPhone"]').value.trim();
  var dokter = document.querySelector('[name="doctorId"]');
  var dokterText =
    dokter && dokter.options[dokter.selectedIndex]
      ? dokter.options[dokter.selectedIndex].text
      : "";
  var tanggal = document.querySelector('[name="appointmentDate"]').value;
  var jam = document.querySelector('[name="appointmentTime"]').value;
  var catatan = document.querySelector('[name="notes"]').value;
  var no_wa = "6287770065455";

  // Validasi sederhana
  if (!nama || !telp || !dokterText || !tanggal || !jam) {
    // Show modern alert
    showAlert("Mohon lengkapi semua data janji temu!", "error");
    return;
  }

  var pesan =
    `Halo Admin RSIA Buah Hati Pamulang, saya ingin membuat janji temu:\n\n` +
    `Nama: ${nama}\n` +
    `No. HP: ${telp}\n` +
    `Dokter: ${dokterText}\n` +
    `Tanggal: ${tanggal}\n` +
    `Jam: ${jam}\n` +
    `Catatan: ${catatan}`;

  var url_wa = "https://wa.me/" + no_wa + "?text=" + encodeURIComponent(pesan);
  window.open(url_wa, "_blank");
}

// Modern alert function
function showAlert(message, type = "info") {
  const alertDiv = document.createElement("div");
  alertDiv.className = `fixed top-4 right-4 z-50 p-3 sm:p-4 rounded-xl sm:rounded-2xl shadow-2xl transform transition-all duration-300 max-w-sm ${
    type === "error" ? "bg-red-500 text-white" : "bg-green-500 text-white"
  }`;
  alertDiv.innerHTML = `
    <div class="flex items-center gap-2 sm:gap-3">
      <svg class="w-5 h-5 sm:w-6 sm:h-6 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        ${
          type === "error"
            ? '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>'
            : '<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>'
        }
      </svg>
      <span class="font-medium text-sm sm:text-base">${message}</span>
    </div>
  `;

  document.body.appendChild(alertDiv);

  // Auto remove after 5 seconds
  setTimeout(() => {
    alertDiv.style.transform = "translateX(100%)";
    setTimeout(() => alertDiv.remove(), 300);
  }, 5000);
}

// Set minimum date to today
document.addEventListener("DOMContentLoaded", function () {
  const today = new Date().toISOString().split("T")[0];
  const dateInput = document.querySelector('[name="appointmentDate"]');
  if (dateInput) {
    dateInput.min = today;
  }
});
