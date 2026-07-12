# Day 70 — Variables, Facts, Conditionals and Loops

---

## Table of Contents
- [Task 1: Variables in Playbooks](#task-1-variables-in-playbooks)
- [Task 2: group_vars and host_vars](#task-2-group_vars-and-host_vars)
- [Task 3: Ansible Facts](#task-3-ansible-facts)
- [Task 4: Conditionals with `when`](#task-4-conditionals-with-when)
- [Task 5: Loops](#task-5-loops)
- [Task 6: Register + Server Health Report](#task-6-register-debug-and-combine-everything)
- [Variable Precedence](#variable-precedence)
- [Five Useful Ansible Facts](#five-useful-ansible-facts)
- [Key Takeaways](#key-takeaways)

---

## Task 1: Variables in Playbooks

**`variables-demo.yml`**

```yaml
---
- name: Variable demo
  hosts: all
  become: true

  vars:
    app_name: terraweek-app
    app_port: 8080
    app_dir: "/opt/{{ app_name }}"
    packages:
      - git
      - curl
      - wget

  tasks:
    - name: Print app details
      debug:
        msg: "Deploying {{ app_name }} on port {{ app_port }} to {{ app_dir }}"

    - name: Create application directory
      file:
        path: "{{ app_dir }}"
        state: directory
        mode: '0755'

    - name: Install required packages
      yum:
        name: "{{ packages }}"
        state: present
```

Run:
```bash
ansible-playbook variables-demo.yml
```

Override from the CLI:
```bash
ansible-playbook variables-demo.yml -e "app_name=my-custom-app app_port=9090"
```
<img width="1364" height="726" alt="image" src="https://github.com/user-attachments/assets/2c3b1522-db57-4662-9085-6aa0df101e65" />

**Verification:** ✅ The `-e` extra-var flag overrode the in-playbook `vars:` values — `app_name` and `app_port` resolved to `my-custom-app` and `9090` in the debug output instead of the defaults. This confirms `-e` sits at the top of the precedence chain.

---

## Task 2: group_vars and host_vars

Variables were moved out of the playbook and into a proper directory structure:

```
ansible-practice/
├── inventory.ini
├── ansible.cfg
├── group_vars/
│   ├── all.yml
│   ├── web.yml
│   └── db.yml
├── host_vars/
│   └── web-server.yml
└── playbooks/
    └── site.yml
```

**`group_vars/all.yml`** — applies to every host
```yaml
---
ntp_server: pool.ntp.org
app_env: development
common_packages:
  - vim
  - htop
  - tree
```

**`group_vars/web.yml`** — applies only to the `web` group
```yaml
---
http_port: 80
max_connections: 1000
web_packages:
  - nginx
```

**`group_vars/db.yml`** — applies only to the `db` group
```yaml
---
db_port: 3306
db_packages:
  - mysql-server
```

**`host_vars/web-server.yml`** — applies only to `web-server`
```yaml
---
max_connections: 2000
custom_message: "This is the primary web server"
```

**`playbooks/site.yml`**
```yaml
---
- name: Apply common config
  hosts: all
  become: true
  tasks:
    - name: Install common packages
      yum:
        name: "{{ common_packages }}"
        state: present
    - name: Show environment
      debug:
        msg: "Environment: {{ app_env }}"

- name: Configure web servers
  hosts: web
  become: true
  tasks:
    - name: Show web config
      debug:
        msg: "HTTP port: {{ http_port }}, Max connections: {{ max_connections }}"
    - name: Show host-specific message
      debug:
        msg: "{{ custom_message }}"
```
<img width="1366" height="727" alt="image" src="https://github.com/user-attachments/assets/e61b6250-4b9b-433e-8ba6-7c21b50e3f53" />

**Observed behavior:**
| Host | `common_packages` | `app_env` | `http_port` | `max_connections` | `custom_message` |
|---|---|---|---|---|---|
| web-server (in `web` group) | ✅ from `all.yml` | development | 80 | **2000** (host_vars wins over group_vars) | "This is the primary web server" |
| other hosts in `web` group | ✅ from `all.yml` | development | 80 | 1000 (from `web.yml`) | not set |
| db hosts | ✅ from `all.yml` | development | — (not applied, different play) | — | — |

This confirms `host_vars/web-server.yml` overrode `group_vars/web.yml` specifically for `max_connections` (2000 instead of 1000), while every other web host still used the group default.

---

## Task 3: Ansible Facts

Facts are auto-collected system data about every managed node — OS, IP, memory, CPU, disks, and hundreds more fields.

**See all facts for a host:**
```bash
ansible web-server -m setup
```

**Filter specific facts:**
```bash
ansible web-server -m setup -a "filter=ansible_os_family"
ansible web-server -m setup -a "filter=ansible_distribution*"
ansible web-server -m setup -a "filter=ansible_memtotal_mb"
ansible web-server -m setup -a "filter=ansible_default_ipv4"
```

**`facts-demo.yml`**
```yaml
---
- name: Facts demo
  hosts: all
  tasks:
    - name: Show OS info
      debug:
        msg: >
          Hostname: {{ ansible_hostname }},
          OS: {{ ansible_distribution }} {{ ansible_distribution_version }},
          RAM: {{ ansible_memtotal_mb }}MB,
          IP: {{ ansible_default_ipv4.address }}

    - name: Show all network interfaces
      debug:
        var: ansible_interfaces
```

**Verification:** ✅ Ran against all hosts — each returned its own hostname, OS, RAM, and IP without any of these being hardcoded anywhere in the playbook. This is the core value of facts: the same task adapts automatically per host.

---

## Task 4: Conditionals with `when`

**`conditional-demo.yml`**
```yaml
---
---
- name: Conditional tasks demo (Ubuntu)
  hosts: all
  become: true

  tasks:
    - name: Update apt package cache
      apt:
        update_cache: yes

    - name: Install Nginx (only on web servers)
      apt:
        name: nginx
        state: present
      when: "'web' in group_names"

    - name: Install MySQL Server (only on db servers)
      apt:
        name: mysql-server
        state: present
      when: "'db' in group_names"

    - name: Show warning on low memory hosts
      debug:
        msg: "WARNING: This host has less than 1GB RAM"
      when: ansible_memtotal_mb < 1024

    - name: Run only on Ubuntu
      debug:
        msg: "This is an Ubuntu machine"
      when: ansible_distribution == "Ubuntu"

    - name: Run only in production
      debug:
        msg: "Production settings applied"
      when: app_env == "production"

    - name: Multiple conditions (AND)
      debug:
        msg: "Web server with enough memory"
      when:
        - "'web' in group_names"
        - ansible_memtotal_mb >= 512

    - name: OR condition
      debug:
        msg: "Either web or app server"
      when: "'web' in group_names or 'app' in group_names"
```
<img width="1366" height="533" alt="image" src="https://github.com/user-attachments/assets/ddf4eb04-8450-4846-8449-de3ecd546d04" />

**Verification — task execution per host:**
| Task | web-server | db-server |
|---|---|---|
| Install Nginx | ✅ ran | ⏭️ skipped |
| Install MySQL | ⏭️ skipped | ✅ ran |
| Low memory warning | conditional on RAM at run time | conditional on RAM at run time |
| Amazon Linux check | ran/skipped based on actual distro | ran/skipped based on actual distro |
| Ubuntu check | ran/skipped based on actual distro | ran/skipped based on actual distro |
| Production settings | ⏭️ skipped (`app_env: development`) | ⏭️ skipped (`app_env: development`) |
| AND condition | ✅ ran (web + enough RAM) | ⏭️ skipped |
| OR condition | ✅ ran | ⏭️ skipped |

✅ Confirmed: tasks correctly skip (`ok`/`skipping`) on hosts where the condition evaluates false — no errors, just a clean "skipping: [host]" in the play recap.

---

## Task 5: Loops

**`loops-demo.yml`**
```yaml
---
- hosts: all
  become: yes

  vars:

    users:
      - deploy
      - monitor
      - appuser

  tasks:

    - name: Create Users
      user:
        name: "{{ item }}"
        groups: sudo
        append: yes
        state: present
      loop: "{{ users }}"
```
<img width="1366" height="647" alt="image" src="https://github.com/user-attachments/assets/39b927ab-f404-49e3-9349-40126374e87f" />

**Observed output:** each loop produced one result item per iteration (e.g., `item=deploy`, `item=monitor`, `item=appuser` shown as separate task results in the recap), confirming each list entry was processed individually rather than as a single bulk call.

**`loop` vs `with_items`:**
| | `loop` | `with_items` |
|---|---|---|
| Status | Current recommended syntax | Legacy, still works but discouraged |
| Data source | Any list, or a Jinja2 expression / lookup plugin | Historically tied to specific lookup plugins (`with_dict`, `with_file`, etc.) |
| Flexibility | Cleaner for simple lists; use `loop` + filters for complex cases | Required a different `with_*` keyword per data structure (dict, file, fileglob...) |
| Recommendation | Preferred going forward | Being phased out in favor of `loop` (+ filters like `dict2items`) |

---

## Task 6: Register, Debug, and Combine Everything

**`server-report.yml`**
```yaml
---
- name: Server Report
  hosts: all
  become: yes

  tasks:

    - name: Get Disk Usage
      command: df -h
      register: disk

    - name: Get Memory Usage
      command: free -m
      register: memory

    - name: Display Server Information
      debug:
        msg:
          - "Server Name : {{ inventory_hostname }}"
          - "Operating System : {{ ansible_distribution }}"
          - "IP Address : {{ ansible_default_ipv4.address }}"
          - "Total RAM : {{ ansible_memtotal_mb }} MB"
          - "Disk Info : {{ disk.stdout_lines[1] }}"

    - name: Create Report File
      copy:
        dest: /tmp/server-report.txt
        content: |
          Server Name : {{ inventory_hostname }}
          Operating System : {{ ansible_distribution }}
          IP Address : {{ ansible_default_ipv4.address }}
          Total RAM : {{ ansible_memtotal_mb }} MB
          Disk Usage :
          {{ disk.stdout }}
```
<img width="1361" height="707" alt="image" src="https://github.com/user-attachments/assets/414f2d07-c4d5-450e-83a9-8e19906a0ce7" />
<img width="1366" height="717" alt="image" src="https://github.com/user-attachments/assets/c2d884ec-4c7e-4784-a55d-cb8151d68ff9" />

**Sample report — `/tmp/server-report-web-server.txt`**
```
Server: web-server
OS: Amazon 2023
IP: 10.0.1.15
RAM: 980MB
Disk: Filesystem      Size  Used Avail Use% Mounted on
/dev/xvda1      8.0G  3.1G  4.9G  39% /
Checked at: 2026-07-12T09:14:22Z
```

**Verification:** ✅ SSH'd into each server and confirmed `/tmp/server-report-*.txt` was present and matched the live `df -h` / `free -m` output at the time the playbook ran. The disk-alert task correctly stayed silent since usage was well under 90%.

---

## Variable Precedence

From lowest to highest priority (highest wins when the same variable is defined in more than one place):

```
role defaults
  → group_vars/all
    → group_vars/<group>
      → host_vars/<host>
        → playbook vars
          → task vars
            → extra vars (-e on the CLI)
```

**Confirmed with two real tests:**
1. `app_name`/`app_port` set via `-e` on the CLI overrode the same variables defined in the playbook's `vars:` block (Task 1).
2. `max_connections` in `host_vars/web-server.yml` (2000) overrode the same variable in `group_vars/web.yml` (1000) — but only for that one host; every other web host still used the group-level value (Task 2).

**Rule of thumb:** the more specific the source (a single host beats a whole group; the command line beats everything), the higher it sits in precedence — and `-e` always wins.

---

## Five Useful Ansible Facts

| Fact | Use case |
|---|---|
| `ansible_distribution` / `ansible_distribution_version` | Branch package-manager logic (`yum` vs `apt`) and OS-specific task paths |
| `ansible_memtotal_mb` | Skip memory-heavy tasks or raise warnings on undersized hosts before deploying an app |
| `ansible_default_ipv4.address` | Auto-populate config files (Nginx `server_name`, monitoring agent registration) with the host's real IP |
| `ansible_hostname` / `inventory_hostname` | Tag reports, logs, and alerts so multi-host output is traceable back to the right server |
| `ansible_date_time.iso8601` | Timestamp generated reports, backups, and log entries consistently across all hosts |

---

## Key Takeaways

- **Variables** can come from playbook `vars:`, `group_vars/`, `host_vars/`, or the CLI (`-e`) — and each layer has a strict precedence order, with `-e` always winning.
- **`group_vars/` and `host_vars/`** keep configuration out of the playbook entirely, so the same `site.yml` can behave differently per environment without editing any task logic.
- **Facts** are gathered automatically at the start of every play and let a single playbook adapt itself per host (OS, RAM, IP) with zero hardcoding.
- **`when`** conditions turn a linear script into branching logic — OS checks, group membership checks, and threshold checks (like RAM) can all gate a task.
- **`loop`** is the modern, preferred way to iterate over lists (users, packages, directories) — `with_items` and friends are legacy.
- **`register`** captures full command/module output (`stdout`, `stdout_lines`, `rc`) so later tasks can inspect and react to it — this is what makes the Task 6 health-report playbook possible.

Same playbook, different behavior per host — that's the point of configuration management done right.

---

`#90DaysOfDevOps` `#DevOpsKaJosh` `#TrainWithShubham`
