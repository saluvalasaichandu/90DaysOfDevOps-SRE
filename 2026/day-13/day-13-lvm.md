# 🚀 Day 13 – Linux Volume Management (LVM)

# 📌 Introduction

Storage management is one of the most critical responsibilities in Linux Administration, DevOps, and Cloud Engineering.

In production environments, applications continuously generate:

* Logs
* Database files
* Backups
* Artifacts
* Container volumes

Traditional disk partitioning is rigid and difficult to resize dynamically.

Linux LVM (Logical Volume Manager) solves this problem by providing:
✅ Flexible storage management
✅ Dynamic volume resizing
✅ Easier disk expansion
✅ Better storage abstraction
✅ Simplified administration

In today’s hands-on challenge, I practiced:
✅ Creating Physical Volumes (PV)
✅ Creating Volume Groups (VG)
✅ Creating Logical Volumes (LV)
✅ Formatting and mounting volumes
✅ Extending storage dynamically
✅ Managing Linux storage efficiently

---

# 💽 What is LVM?

LVM = Logical Volume Manager

LVM is an advanced Linux storage management system that allows flexible disk management.

Instead of directly using partitions, LVM creates:

* Physical Volumes (PV)
* Volume Groups (VG)
* Logical Volumes (LV)

---

# 🏗️ LVM Architecture

```text id="jlwm174"
Disk → Physical Volume (PV) → Volume Group (VG) → Logical Volume (LV) → Filesystem
```

---

# 📌 LVM Components

| Component | Purpose                           |
| --------- | --------------------------------- |
| PV        | Physical storage device           |
| VG        | Pool of storage                   |
| LV        | Virtual partition created from VG |

---

# 📌 Why LVM Matters in DevOps

LVM is heavily used in:

* Cloud servers
* Kubernetes worker nodes
* Databases
* Log storage
* CI/CD servers
* Backup systems

Benefits:

* Extend storage without downtime
* Flexible disk management
* Easier scaling

---

# 🔐 Step 1 – Switch to Root User

## Command

```bash id="jlym175"
sudo -i
```

or

```bash id="jlym176"
sudo su
```

---

# 💿 Step 2 – Create Virtual Disk (If No Spare Disk Available)

# 📌 Why Virtual Disk?

In cloud or VM environments, spare disks may not exist.

We can simulate a disk using loop devices.

---

# 🔹 Create Disk Image

## Command

```bash id="jlym177"
dd if=/dev/zero of=/tmp/disk1.img bs=1M count=1024
```

### Purpose

Creates:

* 1 GB virtual disk image

---

# 🔹 Attach Loop Device

## Command

```bash id="jlym178"
losetup -fP /tmp/disk1.img
```

---

# 🔹 Verify Loop Device

## Command

```bash id="jlym179"
losetup -a
```

## Example Output

```text id="jlym180"
/dev/loop0
```

---

# 📊 Task 1 – Check Current Storage

# 🔹 List Block Devices

## Command

```bash id="jlym181"
lsblk
```

### Purpose

Displays:

* Disks
* Partitions
* Mount points

---

# 🔹 Check Physical Volumes

## Command

```bash id="jlym182"
pvs
```

### Purpose

Displays Physical Volumes.

---

# 🔹 Check Volume Groups

## Command

```bash id="jlym183"
vgs
```

### Purpose

Displays Volume Groups.

---

# 🔹 Check Logical Volumes

## Command

```bash id="jlym184"
lvs
```

### Purpose

Displays Logical Volumes.

---

# 🔹 Check Mounted Filesystems

## Command

```bash id="jlym185"
df -h
```

### Purpose

Displays:

* Mounted filesystems
* Disk usage
* Free space

---

# 🧱 Task 2 – Create Physical Volume (PV)

# 📌 What is PV?

Physical Volume is the actual storage device used by LVM.

Examples:

* `/dev/sdb`
* `/dev/loop0`

---

# 🔹 Create Physical Volume

## Command

```bash id="jlym186"
pvcreate /dev/loop0
```

or

```bash id="jlym187"
pvcreate /dev/sdb
```

---

# 🔹 Verify PV

## Command

```bash id="jlym188"
pvs
```

## Example Output

```text id="jlym189"
PV         VG   Fmt  Attr PSize
/dev/loop0      lvm2 a--  1.00g
```

---

# 🏗️ Task 3 – Create Volume Group (VG)

# 📌 What is VG?

Volume Group is a storage pool created from Physical Volumes.

---

# 🔹 Create VG

## Command

```bash id="jlym190"
vgcreate devops-vg /dev/loop0
```

---

# 🔹 Verify VG

## Command

```bash id="jlym191"
vgs
```

## Example Output

```text id="jlym192"
VG         #PV #LV VSize
devops-vg   1   0  1020M
```

---

# 📦 Task 4 – Create Logical Volume (LV)

# 📌 What is LV?

Logical Volume acts like a flexible virtual partition.

Applications use LVs instead of physical partitions.

---

# 🔹 Create Logical Volume

## Command

```bash id="jlym193"
lvcreate -L 500M -n app-data devops-vg
```

### Breakdown

| Option        | Meaning      |
| ------------- | ------------ |
| `-L 500M`     | LV size      |
| `-n app-data` | LV name      |
| `devops-vg`   | Volume Group |

---

# 🔹 Verify LV

## Command

```bash id="jlym194"
lvs
```

## Example Output

```text id="jlym195"
LV        VG         Attr       LSize
app-data  devops-vg -wi-a----- 500M
```

---

# 🗂️ Task 5 – Format and Mount Logical Volume

# 📌 Why Formatting is Needed

Before mounting:

* Filesystem must be created

Common filesystems:

* ext4
* xfs

---

# 🔹 Create ext4 Filesystem

## Command

```bash id="jlym196"
mkfs.ext4 /dev/devops-vg/app-data
```

---

# 🔹 Create Mount Directory

## Command

```bash id="jlym197"
mkdir -p /mnt/app-data
```

---

# 🔹 Mount Logical Volume

## Command

```bash id="jlym198"
mount /dev/devops-vg/app-data /mnt/app-data
```

---

# 🔹 Verify Mount

## Command

```bash id="jlym199"
df -h /mnt/app-data
```

## Example Output

```text id="jlym200"
/dev/mapper/devops--vg-app--data  487M
```

---

# 🧪 Test Mounted Volume

# 🔹 Create Test File

## Command

```bash id="jlym201"
touch /mnt/app-data/test.txt
```

---

# 🔹 Verify File

## Command

```bash id="jlym202"
ls -l /mnt/app-data
```

---

# 📈 Task 6 – Extend Logical Volume

# 📌 Why Extend Storage?

Applications may run out of space.

LVM allows dynamic expansion without recreating partitions.

---

# 🔹 Extend Logical Volume

## Command

```bash id="jlym203"
lvextend -L +200M /dev/devops-vg/app-data
```

### Purpose

Adds:

* 200 MB additional storage

---

# 🔹 Resize Filesystem

## Command

```bash id="jlym204"
resize2fs /dev/devops-vg/app-data
```

### Purpose

Extends ext4 filesystem to use new space.

---

# 🔹 Verify Extended Storage

## Command

```bash id="jlym205"
df -h /mnt/app-data
```

## Observation

Logical Volume size increased successfully.

---

# 🔍 Understanding LVM Workflow

# Step-by-Step Flow

```text id="jlym206"
Disk
 ↓
Physical Volume (PV)
 ↓
Volume Group (VG)
 ↓
Logical Volume (LV)
 ↓
Filesystem
 ↓
Mount Point
```

---

# 🚨 Troubleshooting Scenario

# Problem

Application running out of disk space.

---

# Step 1 – Check Disk Usage

```bash id="jlym207"
df -h
```

---

# Step 2 – Check LVM Volumes

```bash id="jlym208"
lvs
vgs
pvs
```

---

# Step 3 – Extend Logical Volume

```bash id="jlym209"
lvextend -L +1G /dev/devops-vg/app-data
```

---

# Step 4 – Resize Filesystem

```bash id="jlym210"
resize2fs /dev/devops-vg/app-data
```

---

# Step 5 – Verify Space

```bash id="jlym211"
df -h
```

---

# 🎯 Real-World DevOps Use Cases

LVM is heavily used in:

* Kubernetes worker nodes
* Cloud virtual machines
* Database servers
* Jenkins build servers
* Monitoring systems
* Log storage servers

Examples:

* Extend database storage dynamically
* Increase Docker volume space
* Expand CI/CD artifact storage

---

# 🎯 What I Learned

✅ Understanding Physical Volumes (PV)
✅ Creating Volume Groups (VG)
✅ Creating Logical Volumes (LV)
✅ Formatting and mounting storage
✅ Dynamically extending storage
✅ Real-world Linux storage management

---

# ✅ Commands Practiced Today

```bash id="jlym212"
lsblk
pvs
vgs
lvs
df -h
pvcreate
vgcreate
lvcreate
mkfs.ext4
mount
lvextend
resize2fs
losetup
dd
```

---

# 🏁 Conclusion

Linux LVM provides flexible and scalable storage management for modern DevOps and Cloud environments.

Understanding:

* Physical Volumes
* Volume Groups
* Logical Volumes
* Dynamic storage expansion

