# JavaScript Structure Documentation

## Overview

Sistem JavaScript telah disederhanakan untuk maintainability yang lebih baik dengan menggabungkan fungsi-fungsi yang berhubungan ke dalam file yang lebih sedikit.

## File Structure

### `/src/main/resources/static/js/`

#### `main.js` - Main JavaScript File

**Fungsi yang termasuk:**

- Navbar mobile menu toggle
- Modal pilihan pasien (desktop & mobile)
- Services search functionality
- Gallery lightbox functionality
- Event delegation untuk semua interaksi

**Fitur:**

- Event delegation untuk elemen yang mungkin belum ada saat DOM ready
- Debug logging untuk troubleshooting
- Conditional loading untuk elemen yang tidak selalu ada

#### `schedule.js` - Schedule Specific JavaScript

**Fungsi yang termasuk:**

- Desktop schedule filtering & pagination
- Mobile schedule filtering & pagination
- Desktop popover functionality
- Mobile modal functionality

**Loading Strategy:**

- Di-load secara conditional hanya jika elemen schedule ada di halaman
- Diatur di `fragments/head.html`

## Fragment Structure

### `fragments/head.html`

- Menyertakan `main.js` di semua halaman
- Conditional loading untuk `schedule.js`
- Tailwind config dan custom styles
- Alpine.js untuk reactive components

### `fragments/footer.html`

- Menyertakan modal pilihan pasien di semua halaman
- Tidak perlu menambahkan modal di setiap halaman individual

## Benefits

### 1. **Reduced File Count**

- Dari 5 file JavaScript → 2 file
- Lebih mudah untuk maintenance

### 2. **Centralized Loading**

- Semua script di-load dari `head.html`
- Tidak perlu menambahkan script tag di setiap halaman

### 3. **Automatic Modal Inclusion**

- Modal otomatis tersedia di semua halaman via footer
- Tidak perlu manual include di setiap halaman

### 4. **Conditional Loading**

- `schedule.js` hanya di-load jika diperlukan
- Menghemat bandwidth

### 5. **Event Delegation**

- Semua event handler menggunakan event delegation
- Bekerja dengan elemen yang di-load secara dinamis

## Usage

### Menambah JavaScript Baru

1. Jika fungsi umum → tambah ke `main.js`
2. Jika fungsi spesifik halaman → buat file baru dan load conditional di `head.html`

### Menambah Modal Baru

1. Buat fragment modal baru di `fragments/`
2. Include di `footer.html` jika untuk semua halaman
3. Atau include manual di halaman spesifik

### Debugging

- Semua debug log menggunakan prefix `[DEBUG]`
- Check console untuk melihat elemen yang ditemukan
- Timeout 1 detik untuk memastikan DOM sudah siap

## File yang Dihapus

- `modal.js` → digabung ke `main.js`
- `navbar.js` → digabung ke `main.js`
- `services.js` → digabung ke `main.js`
- `gallery.js` → digabung ke `main.js`

## Maintenance Tips

1. Selalu gunakan event delegation untuk elemen dinamis
2. Gunakan conditional loading untuk script spesifik
3. Debug dengan console.log untuk troubleshooting
4. Keep it simple - hindari duplikasi kode
