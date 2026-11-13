# To-do app: setup

About 15 minutes, all free. You'll end up with an app icon on your iPhone and in your Mac's Dock, both showing the same list.

**What's in this folder**

| File | What it is |
|---|---|
| `index.html` | The app |
| `config.js` | Where you paste your Supabase details (step 1) |
| `sw.js`, `manifest.webmanifest`, `icons/` | Make it install as an app and work offline |
| `vendor/` | The Supabase sync library, bundled so nothing loads from elsewhere |
| `setup.sql` | The database setup you paste into Supabase |

Your current tasks are **not** in these files. They're in `my-tasks-backup.json`, which came with the app. Keep that file on your Mac, and don't upload it.

---

## 1. Create the sync database (Supabase)

1. Go to **supabase.com**, sign up (GitHub or email), then click **New project**.
   - Name: `todo`
   - Database password: anything strong. You won't need it again.
   - Region: **Mumbai (ap-south-1)** is closest to you.
   - Wait about a minute while it's created.
2. In the left sidebar, open **SQL Editor** and click **New query**. Paste everything from `setup.sql`, then click **Run**. It should say "Success. No rows returned".
3. Copy your keys. Go to **Project Settings → API Keys** (or **Data API**).
   - Copy the **Project URL** (`https://xxxx.supabase.co`).
   - Copy the **publishable** key, or the **anon public** key on older projects. Never use the secret or `service_role` key.
4. Open `config.js` in TextEdit and paste both values between the quotes:
   ```js
   supabaseUrl: "https://xxxx.supabase.co",
   supabaseKey: "sb_publishable_..."
   ```
   Then save the file.

> **Two things to know about the free plan:**
> - Supabase's built-in email sender only sends a few emails per hour. That's fine, since it's only used for the one account-confirmation email.
> - Free projects are paused after about a week with no activity. If that happens, open the Supabase dashboard and click **Restore**. The app keeps working offline in the meantime and catches up afterwards.

## 2. Put the app online (GitHub Pages)

1. Sign up at **github.com** if you don't have an account.
2. Click **+ → New repository**.
   - Name: `todo`
   - Visibility: **Public** (free Pages hosting needs this; your tasks are not in the code)
   - Click **Create repository**.
3. On the new repository page, click **uploading an existing file**. Drag in everything from the app folder: `index.html`, `config.js`, `sw.js`, `manifest.webmanifest`, `setup.sql`, `SETUP.md`, and the `icons` and `vendor` folders. Click **Commit changes**.
4. Go to **Settings → Pages**. Under "Build and deployment", choose **Deploy from a branch**, then **main** and **/ (root)**, and click **Save**.
5. After a minute or two, your app is live at
   **https://YOUR-GITHUB-NAME.github.io/todo/**

> `config.js` is public too. That's expected: the publishable key only lets someone sign in, and the database rules from `setup.sql` mean each person can only ever see their own list.

## 3. Install on your Mac first, and bring your tasks in

1. Open the app link in **Safari** on your Mac.
2. In the menu bar, choose **File → Add to Dock** (macOS Sonoma or later). It now opens as its own app.
3. Open it from the Dock. Click the small **"Sign in to sync"** label next to the date to open **Settings**, then click **Restore…** and choose `my-tasks-backup.json`. All your tasks appear.
4. In the same Settings sheet, enter your email and a password and click **Create account**. Open the confirmation email and click its link (any browser is fine), then come back and click **Sign in**. The label turns green: **Synced**.

## 4. Install on your iPhone

1. Open the app link in **Safari** on your iPhone (it has to be Safari).
2. Tap **Share → Add to Home Screen → Add**.
3. Open **To-do** from your Home Screen, tap **Sign in to sync**, and sign in with the same email and password.

Your tasks appear on the phone. From now on, changes on either device show up on the other within a few seconds of opening the app.

---

## How sync behaves

- **Offline first.** Everything saves on the device right away, so the app works on a plane. It syncs when you're back online, when you open the app, and every 45 seconds while it's open.
- **Edits on both devices merge.** If you add a task on your phone offline and delete one on your Mac, both changes survive. When the same task is edited on both, the most recent edit wins.
- **The dot next to the date** shows the sync status:
  - green: synced
  - blue: syncing
  - amber: offline or signed out
  - red: something went wrong. Your changes are still safe on the device.
- **Backup** is in Settings. Download one now and then if you like.

## Updating the app later

If I make changes for you, re-upload the changed files to the same GitHub repository (**Add file → Upload files**, then commit). Also open `sw.js` and change `todo-v1` to `todo-v2` (then v3, and so on), so your devices fetch the new version. It applies the next time you open the app.
