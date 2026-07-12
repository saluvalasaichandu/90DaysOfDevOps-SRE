# Day 69 -- Ansible Playbooks and Modules

`#90DaysOfDevOps` `#DevOpsKaJosh` `#TrainWithShubham`

## Overview

Today's focus was moving from ad-hoc Ansible commands to real automation using **playbooks** -- YAML files that describe the desired state of servers. This document covers plays, tasks, modules, handlers, and dry-run/verbosity flags.

---

## 1. My First Playbook -- `install-nginx.yml`

```yaml
---
- name: Install and start Nginx on web servers   # PLAY -- targets a group of hosts
  hosts: web                                     # Inventory group this play runs against
  become: true                                   # Escalate privileges (sudo) for all tasks in this play

  tasks:                                         # List of TASKS in this play
    - name: Install Nginx                        # TASK -- one unit of work
      yum:                                       # MODULE -- what Ansible does
        name: nginx
        state: present                           # Ensure package is installed

    - name: Start and enable Nginx
      service:
        name: nginx
        state: started                           # Ensure service is running
        enabled: true                            # Ensure it starts on boot

    - name: Create a custom index page
      copy:
        content: "<h1>Deployed by Ansible - TerraWeek Server</h1>"
        dest: /usr/share/nginx/html/index.html
```

**Run it:**
```bash
ansible-playbook install-nginx.yml
```
<img width="1366" height="623" alt="image" src="https://github.com/user-attachments/assets/c3d8bcff-742a-44d7-8cb7-76f0819f4412" />

**Verify idempotency:** running it a second time shows every task as `ok` instead of `changed`, because Ansible checks current state before acting and only makes changes when needed.

**Verification:** curled the web server's public IP and confirmed the custom index page was served.
<img width="1366" height="709" alt="image" src="https://github.com/user-attachments/assets/05a88cdf-f9fc-4aa0-80be-446aa2bd7897" />

<img width="1345" height="221" alt="image" src="https://github.com/user-attachments/assets/7a2e52e5-4bf3-4cdf-85a2-1ad6b8d4b593" />

---

## 2. Playbook Structure -- Q&A

| Question | Answer |
|---|---|
| Difference between a play and a task? | A **play** maps a group of hosts to a set of actions (it has `hosts`, `become`, and its own `tasks:` list). A **task** is a single unit of work inside a play that calls one module. |
| Can you have multiple plays in one playbook? | Yes -- a playbook is just a YAML list of plays, each can target a different host group with different tasks. |
| `become: true` at play level vs task level? | At the **play** level it applies to every task in that play by default. At the **task** level it overrides the play setting for just that one task (e.g. escalate privileges for a single task even if the rest of the play doesn't need it). |
| What happens if a task fails? | By default Ansible stops running further tasks on that host (it's removed from the batch), but other unaffected hosts continue. This can be changed with `ignore_errors: true` or `any_errors_fatal`. |

---

## 3. Essential Modules -- `essential-modules.yml`

| Module | Purpose |
|---|---|
| `yum` / `apt` | Install, upgrade, or remove packages (`state: present` / `absent`) |
| `service` | Start, stop, restart, or enable/disable a service |
| `copy` | Copy a file from the control node to managed nodes, optionally setting owner/group/mode |
| `file` | Create directories/files, set permissions and ownership, or remove paths |
| `command` | Run a command directly (no shell interpretation -- no pipes, redirects, or env vars) |
| `shell` | Run a command through `/bin/sh`, supporting pipes, redirects, and shell features |
| `lineinfile` | Ensure a specific line exists (or is modified) in a file, without rewriting the whole file |

Example tasks used for practice:

```yaml
---
- name: Install packages and perform system tasks
  hosts: all
  become: true

  tasks:

    - name: Update apt package cache
      apt:
        update_cache: yes
        cache_valid_time: 3600

    - name: Install multiple packages
      apt:
        name:
          - nginx
          - git
          - curl
          - wget
          - tree
        state: present

    - name: Ensure Nginx is running
      service:
        name: nginx
        state: started
        enabled: true

    - name: Copy config file
      copy:
        src: files/app.conf
        dest: /etc/app.conf
        owner: root
        group: root
        mode: '0644'

    - name: Create application directory
      file:
        path: /opt/myapp
        state: directory
        owner: ubuntu
        group: ubuntu
        mode: '0755'

    - name: Check disk space
      command: df -h
      register: disk_output

    - name: Print disk space
      debug:
        var: disk_output.stdout_lines

    - name: Count running processes
      shell: ps aux | wc -l
      register: process_count

    - name: Show process count
      debug:
        msg: "Total processes: {{ process_count.stdout }}"
```

A `files/app.conf` sample file was created for the `copy` task, and the playbook was run against all inventory hosts.

### `command` vs `shell`

- **`command`** executes the binary directly without invoking a shell. It's safer and preferred by default because it avoids shell-injection risks, but it **cannot** use pipes (`|`), redirects (`>`), environment variable expansion, or chained commands (`&&`).
- **`shell`** runs the command through `/bin/sh`, so it supports pipes, redirects, wildcards, and shell operators.
- **Rule of thumb:** use `command` unless you specifically need shell features -- then use `shell`.

---

## 4. Handlers -- `nginx-config.yml`

Handlers are tasks that only run when explicitly triggered by `notify`, and only if the notifying task reported `changed`. This avoids unnecessary service restarts.

```yaml
---
- name: Configure Nginx with a custom config
  hosts: web
  become: true

  tasks:
    - name: Install Nginx
      yum:
        name: nginx
        state: present

    - name: Deploy Nginx config
      copy:
        src: files/nginx.conf
        dest: /etc/nginx/nginx.conf
        owner: root
        mode: '0644'
      notify: Restart Nginx

    - name: Deploy custom index page
      copy:
        content: "<h1>Managed by Ansible</h1><p>Server: {{ inventory_hostname }}</p>"
        dest: /usr/share/nginx/html/index.html

    - name: Ensure Nginx is running
      service:
        name: nginx
        state: started
        enabled: true

  handlers:
    - name: Restart Nginx
      service:
        name: nginx
        state: restarted
```

### Before vs After

| Run | Config task result | Handler triggered? |
|---|---|---|
| First run | `changed` (new config deployed) | Yes -- Nginx restarted |
| Second run | `ok` (no change to config) | No -- Nginx left untouched |

Handlers run **once**, at the end of the play, even if multiple tasks notify the same handler.

---

## 5. Dry Run, Diff, and Verbosity

| Command | Purpose |
|---|---|
| `ansible-playbook install-nginx.yml --check` | **Check mode** -- simulates the run and reports what *would* change, without making changes |
| `ansible-playbook nginx-config.yml --check --diff` | **Diff mode** -- shows the actual before/after content differences for files being changed |
| `ansible-playbook install-nginx.yml -v / -vv / -vvv` | **Verbosity** -- increasing levels of output detail; `-vvv` includes connection-level debugging |
| `ansible-playbook install-nginx.yml --limit web-server` | Restrict the run to specific host(s) |
| `ansible-playbook install-nginx.yml --list-hosts` | List hosts that would be targeted, without running anything |
| `ansible-playbook install-nginx.yml --list-tasks` | List tasks that would run, without running anything |
| `ansible-playbook --syntax-check playbook.yml` | Validate YAML/playbook syntax before running |

### Why `--check --diff` is the most important combo for production

`--check` tells you **whether** anything would change, and `--diff` tells you **exactly what** would change (the literal file/content difference). Together they let you preview the full impact of a playbook run against production with zero risk of actually modifying anything -- catching unintended changes, config drift, or mistakes before they're applied for real.

---

## 6. Multiple Plays -- `multi-play.yml`

```yaml
---
- name: Configure web servers
  hosts: web
  become: true
  tasks:
    - name: Install Nginx
      yum:
        name: nginx
        state: present
    - name: Start Nginx
      service:
        name: nginx
        state: started
        enabled: true

- name: Configure app servers
  hosts: app
  become: true
  tasks:
    - name: Install Node.js dependencies
      yum:
        name:
          - gcc
          - make
        state: present
    - name: Create app directory
      file:
        path: /opt/app
        state: directory
        mode: '0755'

- name: Configure database servers
  hosts: db
  become: true
  tasks:
    - name: Install MySQL client
      yum:
        name: mysql
        state: present
    - name: Create data directory
      file:
        path: /var/lib/appdata
        state: directory
        mode: '0700'
```

**Verification:** Nginx was installed only on `web` hosts, Node.js build tools only on `app` hosts, and MySQL client only on `db` hosts -- each play's tasks ran solely against its targeted group.

---

## Screenshots

> Add your terminal screenshots below.

- [ ] Playbook run showing `changed` vs `ok` tasks
- [ ] Second run proving idempotency (all tasks `ok`)
- [ ] `--check --diff` output on `nginx-config.yml`

---

## Key Takeaways

- Playbooks describe **desired state**, not step-by-step imperative commands -- Ansible figures out what needs to change.
- **Idempotency** means running a playbook repeatedly is safe; nothing changes once the target state is reached.
- **Handlers** prevent wasteful restarts by only firing when something actually changed.
- Always dry-run production changes with `--check --diff` before applying them for real.

---
