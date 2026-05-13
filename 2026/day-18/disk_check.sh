#!/bin/bash
check_disk(){
        echo " displaying disk space.................."
        df -h/
}
check_memory(){
        echo " displaying memory free..........."
        free -h
}
check_disk
check_memory
