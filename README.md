# 🖥️ Windows Remote Workspace (RDP + SSH + Git Bash via Tailscale)

Workflow GitHub Actions ini digunakan untuk membuat **Windows Server 2022 Runner** sementara yang dapat diakses secara aman dari jarak jauh menggunakan **RDP (Remote Desktop)**, **SSH (OpenSSH)**, dan dilengkapi dengan **Git Bash (termasuk Git Bash Here)**. Semua koneksi dirutekan secara aman melalui VPN mesh **Tailscale**.

Sangat cocok untuk *debugging*, menjalankan *script otomatis*, atau sekadar membutuhkan PC Windows berperforma tinggi (16-core, 64GB RAM) secara instan.

---

## ✨ Fitur Utama
- 🔒 **Aman (Secure):** Koneksi RDP & SSH hanya bisa diakses lewat IP Tailscale (VPN privat), bukan IP publik.
- 🖥️ **RDP Aktif:** Dilengkapi NLA (Network Level Authentication) untuk keamanan ekstra.
- 💻 **SSH Server:** Menggunakan OpenSSH bawaan Windows (menggantikan Tailscale SSH yang tidak didukung di Windows).
- 🐚 **Git Bash & Context Menu:** Git terinstal lengkap dengan fitur "Git Bash Here".
- ⏱️ **Keep-Alive:** Runner akan tetap menyala hingga batas maksimal GitHub (5 jam 50 menit).
- 🧹 **Auto-Cleanup:** Menghapus user, mematikan Tailscale, dan membersihkan jejak secara otomatis jika workflow dibatalkan atau selesai.

---

## 🛠️ Persiapan (Setup Secrets)

Sebelum menjalankan workflow, Anda **wajib** mengatur beberapa *Repository Secrets* di GitHub:

1. Buka repository Anda di GitHub.
2. Masuk ke **Settings** > **Secrets and variables** > **Actions**.
3. Klik **New repository secret** dan tambahkan variabel berikut:

| Nama Secret | Deskripsi | Contoh Nilai |
| :--- | :--- | :--- |
| `RDP_PASSWORD` | Password untuk login ke Windows (User: `RDP`). Gunakan password yang kuat. | `P@ssw0rdSangatKuat123!` |
| `TAILSCALE_AUTHKEY` | Auth Key dari Tailscale. **Wajib** bertipe *Reusable* dan *Ephemeral*. | `tskey-auth-k...` |

> **Cara mendapatkan `TAILSCALE_AUTHKEY`:**
> 1. Login ke [Tailscale Admin Console](https://login.tailscale.com/admin/settings/keys).
> 2. Klik **Generate auth key**.
> 3. Centang **Reusable** dan **Ephemeral**.
> 4. Salin kunci dan simpan di GitHub Secrets.

---

## 🚀 Cara Menjalankan

1. Buka tab **Actions** di repository GitHub Anda.
2. Pilih workflow **Windows RDP + SSH + Git Bash via Tailscale (Secure)** di menu sebelah kiri.
3. Klik tombol **Run workflow** di sebelah kanan.
4. Isi form yang muncul:
   - **enable_rdp:** Pilih `true` (untuk mengaktifkan Remote Desktop).
   - **enable_ssh:** Pilih `true` (untuk mengaktifkan SSH Server).
   - **run_script_url:** (Opsional) Masukkan URL raw script `.ps1` atau `.bat` jika Anda ingin menginstal sesuatu secara otomatis (misal: *script instalasi 9Router*). Kosongkan jika tidak ada.
5. Klik **Run workflow** (tombol hijau).

---

## 🔗 Cara Mengakses Runner

Setelah workflow berjalan (sekitar 2-3 menit), buka log dari step **Print Access Info**. Di sana Anda akan melihat **Tailscale IP** (contoh: `100.64.0.113`).

**PENTING:** Pastikan komputer/laptop Anda juga sudah terhubung ke Tailscale yang sama (satu akun/tailnet).

### 1. Akses via RDP (Remote Desktop)
- Buka aplikasi **Remote Desktop Connection** (Windows) atau **Microsoft Remote Desktop** (Mac).
- Masukkan IP: `100.64.0.113` (sesuai log Anda).
- Username: `RDP`
- Password: (Sesuai dengan secret `RDP_PASSWORD` Anda).

### 2. Akses via SSH (Terminal)
Buka terminal di komputer Anda, lalu ketik:
```bash
ssh RDP@100.64.0.113
```
Masukkan password `RDP_PASSWORD` saat diminta.

### 3. Akses via Git Bash
Jika Anda sudah login via RDP, Anda bisa membuka aplikasi **Git Bash** dari menu Start, atau klik kanan di folder mana pun dan pilih **"Git Bash Here"**.

---

## 📜 Script Eksternal (Opsional)

Jika Anda mengisi kolom `run_script_url`, workflow akan mengunduh script tersebut dan mengeksekusinya sebagai **Administrator**. 
Pastikan URL mengarah ke file mentah (contoh: *raw.githubusercontent.com* atau *gist*). Workflow ini mendukung script berekstensi `.ps1`, `.bat`, dan `.cmd`.

---

## ⚠️ Catatan Penting & Peringatan

1. **Batas Waktu:** GitHub Actions memiliki batas maksimal 6 jam per *job*. Workflow ini disetel ke **350 menit** (5 jam 50 menit).
2. **Kebijakan GitHub:** Penggunaan runner GitHub untuk aktivitas non-CI/CD (seperti menjadikannya sebagai VPS/RDP pribadi jangka panjang) dapat melanggar *Acceptable Use Policy* GitHub. Harap gunakan dengan bijak.
3. **Biaya:** Jika Anda menggunakan repository privat, menjalankan Windows Runner akan memotong kuota menit GitHub Actions Anda. Repository publik tidak dikenakan biaya.
4. **Keamanan:** Jangan pernah membagikan IP Tailscale Anda ke publik. Cabut akses perangkat dari dashboard Tailscale jika tidak digunakan lagi.
