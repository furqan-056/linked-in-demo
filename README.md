# 🚀 Mini Job Board (Rails 8)

A modern **Job Board Web Application** built with **Ruby on Rails 8 APIs**, allowing companies to post jobs and users to apply with resumes.
The project demonstrates **modern Rails practices**, including authentication, search, background jobs, API documentation, and admin features.

---

# 📌 Features

* 🔐 User authentication with **Devise**
* 🏢 Companies can create and manage jobs
* 💼 Users can apply to jobs
* 📄 Resume upload support
* 🔎 Job search with **Searchkick**
* ⚡ Real-time UI updates using **Turbo & Stimulus**
* 📊 Admin dashboard
* 📬 Weekly job digest email
* 🧪 RSpec testing
* 📘 API documentation with **Swagger / Rswag**
* 🎨 UI styled with **TailwindCSS**

---

# 🛠 Tech Stack

* **Ruby** 3.x
* **Rails** 8
* **PostgreSQL**
* **TailwindCSS**
* **Devise**
* **Searchkick + Elasticsearch**
* **Hotwire (Turbo + Stimulus)**
* **RSpec**
* **Swagger (Rswag)**

---

# 📂 Project Setup

## 1️⃣ Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/mini-job-board.git
cd mini-job-board
```

---

# 2️⃣ Install Dependencies

```bash
bundle install
```

---

# 3️⃣ Setup Database

Update your `config/database.yml` if needed.

Then run:

```bash
rails db:create
rails db:migrate
rails db:seed
```

---

# 4️⃣ Setup Search (Elasticsearch)

This project uses **Searchkick**.

Start Elasticsearch:

```bash
sudo service elasticsearch start
```

Then reindex jobs:

```bash
rails searchkick:reindex:all
```

---

# 5️⃣ Run the Application

Start the Rails server:

```bash
bin/dev
```

or

```bash
rails server
```

Open in browser:

```
http://localhost:3000
```

---

# 📬 Background Jobs

This project uses **ActiveJob**.

Example job:

```
NightlyReindexJob
```

You can run it manually:

```bash
rails runner "NightlyReindexJob.perform_now"
```

---

# 📧 Email Setup

Emails are used for **Weekly Job Digest**.

To test in development, check logs or configure SMTP in:

```
config/environments/development.rb
```

---

# 🧪 Running Tests

Run RSpec tests:

```bash
bundle exec rspec
```

---

# 📘 API Documentation

Swagger documentation is available via **Rswag**.

Start the server and open:

```
http://localhost:3000/api-docs
```

---

# 👤 Roles in the System

### User(Candidate)

* Browse jobs
* Apply to jobs
* Upload resume

### Recruiter

* Create jobs
* Manage job listings

### Admin

* View dashboard
* Monitor companies and jobs

---

# 📜 License

This project is open-source and available under the **MIT License**.

---

# 👨‍💻 Author

Developed by **Muhammad Furqan**

---
