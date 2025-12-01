#!/bin/bash

MEMORY_PRESSURE=$(memory_pressure | grep "System-wide memory free percentage:" | awk '{print 100-$5}' | sed 's/%//')

if [ -z "$MEMORY_PRESSURE" ]; then
  # Fallback method
  TOTAL_MEM=$(sysctl -n hw.memsize)
  PAGE_SIZE=$(pagesize)
  PAGES_FREE=$(vm_stat | grep "Pages free" | awk '{print $3}' | sed 's/\.//')
  PAGES_INACTIVE=$(vm_stat | grep "Pages inactive" | awk '{print $3}' | sed 's/\.//')
  FREE_MEM=$((($PAGES_FREE + $PAGES_INACTIVE) * $PAGE_SIZE))
  USED_MEM=$(($TOTAL_MEM - $FREE_MEM))
  MEMORY_PRESSURE=$((($USED_MEM * 100) / $TOTAL_MEM))
fi

sketchybar --set ram label="${MEMORY_PRESSURE}%"
